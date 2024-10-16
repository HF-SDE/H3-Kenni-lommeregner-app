import 'package:flutter/material.dart';
import '../models/calculator_model.dart';
import '/utils/calulatorCommand/command.dart';

class CalculatorViewModel extends ChangeNotifier {
  final CalculatorModel _model = CalculatorModel();

  String get display => _model.display;
  bool showExplosionGif = false;

  void inputNumber(String number) {
    if (_model.isNewInput) {
      _model.display = number;
      _model.isNewInput = false;
    } else {
      _model.display += number;
    }
    notifyListeners();
  }

  void setOperator(String operator) {
    if (_model.firstNumber == null) {
      _model.firstNumber = double.tryParse(_model.display.replaceAll(",", "."));
    } else {
      _model.secondNumber =
          double.tryParse(_model.display.replaceAll(",", "."));
      _performCalculation();
    }
    _model.operator = operator;
    _model.isNewInput = true;
    notifyListeners();
  }

  void calculateResult() {
    if (_model.firstNumber != null && _model.operator != null) {
      _model.secondNumber =
          double.tryParse(_model.display.replaceAll(",", "."));
      _performCalculation();
      _model.operator = null;
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

    _model.calculator.clear();
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

  void deleteLastDigit() {
    if (_model.display.isNotEmpty) {
      _model.display = _model.display.substring(0, _model.display.length - 1);
    }
    notifyListeners();
  }
}
