import 'package:flutter/material.dart';
import 'dart:async'; // For Timer
import '../models/calculator_model.dart';
import 'package:toastification/toastification.dart';

class CalculatorViewModel extends ChangeNotifier {
  final CalculatorModel _calculatorModel = CalculatorModel();

  bool _showExplosionGif = false; // Flag to show the explosion GIF

  //NOTE: this could be used in the future, to show a toast by emitting an event
  final eventToShowToast = StreamController<String>();

  String get display => _calculatorModel.display;
  bool get showExplosionGif => _showExplosionGif; // Expose the flag to the view

  // Handles number input
  void inputNumber(String number) {
    if (_calculatorModel.isNewInput) {
      _calculatorModel.display = number;
      _calculatorModel.isNewInput =
          false; // We are in the middle of input, not a new one anymore
    } else {
      _calculatorModel.display += number;
    }
    _showExplosionGif = false; // Reset explosion flag on valid input
    notifyListeners();
  }

  // Set operator and handle continuous calculations
  void setOperator(String operator) {
    if (_calculatorModel.firstNumber == null) {
      _calculatorModel.firstNumber = double.parse(_calculatorModel.display);
    } else if (_calculatorModel.operator != null &&
        !_calculatorModel.isNewInput) {
      // If an operation is in progress, calculate the result with the previous operator
      calculateResult();
      _calculatorModel.firstNumber = double.parse(
          _calculatorModel.display); // Use the result for further calculation
    }

    _calculatorModel.operator = operator;
    _calculatorModel.isNewInput = true; // Prepare for new input after operator
    notifyListeners();
  }

  // Perform the calculation
  void calculateResult() {
    if (_calculatorModel.firstNumber != null &&
        _calculatorModel.operator != null) {
      _calculatorModel.secondNumber = double.parse(_calculatorModel.display);

      try {
        double result = calculate(_calculatorModel.firstNumber!,
            _calculatorModel.secondNumber!, _calculatorModel.operator!);

        _calculatorModel.display = result.toString();

        if (result == 69 || result == 80085) {
          // NOTE: this could be used in the future, to show a toast by emitting an event.
          // eventToShowToast.sink.add("Nice!");
          toastification.show(
            style: ToastificationStyle.flatColored,
            autoCloseDuration: const Duration(seconds: 4),
            title: const Text("Nice!"),
            type: ToastificationType.success,
          );
        }
        _calculatorModel.firstNumber =
            result; // Save result for continued operations
        _calculatorModel.secondNumber = null;
        _calculatorModel.isNewInput =
            true; // Prepare for new input after result
        _showExplosionGif = false; // No explosion on valid calculations
      } catch (e) {
        _calculatorModel.display = "Error";
        if (e.toString().contains("Division by zero")) {
          _showExplosionScreen(); // Trigger explosion screen
        }
        _calculatorModel.firstNumber = null;
        _calculatorModel.secondNumber = null;
        _calculatorModel.operator = null;
      }
      notifyListeners();
    }
  }

  // Method to show explosion screen for 3 seconds and then revert back
  void _showExplosionScreen() {
    _showExplosionGif = true;
    notifyListeners();

    Timer(Duration(seconds: 2), () {
      _showExplosionGif = false; // Switch back to calculator
      notifyListeners(); // Update the UI after the timer finishes
    });
  }

  double calculate(double num1, double num2, String operator) {
    switch (operator) {
      case '+':
        return num1 + num2;
      case '-':
        return num1 - num2;
      case '*':
        return num1 * num2;
      case '/':
        if (num2 != 0) {
          return num1 / num2;
        } else {
          throw Exception("Division by zero");
        }
      default:
        throw Exception("Unknown operator");
    }
  }

  // Reset everything (clear)
  void clear() {
    _calculatorModel.display = "0";
    _calculatorModel.firstNumber = null;
    _calculatorModel.secondNumber = null;
    _calculatorModel.operator = null;
    _calculatorModel.isNewInput = true;
    _showExplosionGif = false; // Reset explosion flag
    notifyListeners();
  }
}
