import 'package:flutter/material.dart';
import '../models/calculator_model.dart';
import '/utils/calulatorCommand/command.dart';
import 'package:toastification/toastification.dart';

class CalculatorViewModel extends ChangeNotifier {
  late CalculatorModel _model;

  String get display => _model.display;
  bool showExplosionGif = false;

  void setCalculator(CalculatorModel calculator) {
    _model = calculator;
  }

  void setInputFromExternal() {
    inputNumber(_model.resultFromExternalCalculator.toString());
  }

  void inputNumber(String number) {
    // Prevent adding more than one decimal point per input
    if (number == "." && _model.display.contains(".")) {
      return;
    }

    if (_model.isNewInput) {
      if (number == ".") {
        _model.display = "0.";
      } else {
        _model.display = number;
      }
      _model.isNewInput = false;
    } else {
      _model.display += number;
    }

    // Indicate that a new number has been input
    _model.hasNewNumber = true;

    notifyListeners();
  }

  void setOperator(String operator) {
    // Ensure that an operator can only be set if a number has been input
    if (_model.display == null ||
        _model.display.isEmpty ||
        _model.display == "0") {
      return;
    }

    // Perform calculation only if a new number has been entered after the last operation
    if (_model.hasNewNumber) {
      double? currentNumber =
          double.tryParse(_model.display.replaceAll(",", "."));

      if (currentNumber == null) {
        return;
      }

      if (_model.firstNumber == null) {
        _model.firstNumber = currentNumber;
      } else {
        _model.secondNumber = currentNumber;
        _performCalculation();
        _model.firstNumber = _model.calculator.currentValue;
      }

      _model.hasNewNumber = false; // Reset the flag after using the new number
    }

    _model.operator = operator;
    _model.isNewInput = true;
    notifyListeners();
  }

  void calculateResult() {
    if (_model.firstNumber != null &&
        _model.operator != null &&
        _model.hasNewNumber) {
      _model.secondNumber =
          double.tryParse(_model.display.replaceAll(",", "."));
      _performCalculation();
      _model.firstNumber = _model.calculator.currentValue;
      _model.operator = null;
      _model.hasNewNumber = false;
    }
    _model.isNewInput = true;
    notifyListeners();
  }

  void clear() {
    _model.display = "0";
    _model.firstNumber = null;
    _model.secondNumber = null;
    _model.operator = null;
    _model.isNewInput = true;
    _model.hasNewNumber = false;

    _model.calculator.clear();
    _model.invoker.clearHistory();
    notifyListeners();
  }

  void _performCalculation() {
    if (_model.operator == null || _model.secondNumber == null) return;

    Command? command;

    // Initialize the calculator's internal currentValue with the firstNumber
    if (_model.calculator.currentValue == 0.0 && _model.firstNumber != null) {
      _model.calculator
          .add(_model.firstNumber!); // Set the first number to current value
    }

    switch (_model.operator) {
      case "+":
        command = AddCommand(_model.calculator, _model.secondNumber!);
        break;
      case "-":
        command = SubtractCommand(_model.calculator, _model.secondNumber!);
        break;
      case "*":
        command = MultiplyCommand(_model.calculator, _model.secondNumber!);
        break;
      case "/":
        command = DivideCommand(_model.calculator, _model.secondNumber!);
        break;
    }

    if (command != null) {
      _model.invoker.compute(command); // Execute the command
      _model.display = _model.calculator.currentValue.toString();
    }
  }

  void undoLastOperation() {
    _model.invoker.undo();
    _model.display = _model.calculator.currentValue.toString();
    notifyListeners();
  }

  void triggerExplosionGif() {
    showExplosionGif = true;
    notifyListeners();
  }

  void shareResultToExternalCalculator(Calculator calculator) {
    _model.resultFromExternalCalculator = _model.calculator.currentValue;
    notifyListeners();
  }

  void deleteLastDigit() {
    if (_model.display.isNotEmpty) {
      _model.display = _model.display.substring(0, _model.display.length - 1);
      if (_model.display.isEmpty) {
        _model.display = "0";
        _model.isNewInput = true;
      }
    }
    notifyListeners();
  }
}
