import 'package:flutter/material.dart';
import 'dart:async'; // For Timer
import '../models/calculator_model.dart';
import 'package:toastification/toastification.dart';

class CalculatorViewModel extends ChangeNotifier {
  final CalculatorModel _calculatorModel = CalculatorModel();

  String _display = "0"; // Display value for the calculator
  double? _firstNumber; // First operand
  double? _secondNumber; // Second operand
  String? _operator; // Operator (e.g., +, -, *, /)
  bool _isNewInput =
      true; // Flag to check if new input should start after result
  bool _showExplosionGif = false; // Flag to show the explosion GIF
  //event to show toast

  //NOTE: this could be used in the future, to show a toast by emitting an event
  final eventToShowToast = StreamController<String>();

  String get display => _display;
  bool get showExplosionGif => _showExplosionGif; // Expose the flag to the view

  // Handles number input
  void inputNumber(String number) {
    if (_isNewInput) {
      _display = number;
      _isNewInput =
          false; // We are in the middle of input, not a new one anymore
    } else {
      _display += number;
    }
    _showExplosionGif = false; // Reset explosion flag on valid input
    notifyListeners();
  }

  // Set operator and handle continuous calculations
  void setOperator(String operator) {
    if (_firstNumber == null) {
      _firstNumber = double.parse(_display);
    } else if (_operator != null && !_isNewInput) {
      // If an operation is in progress, calculate the result with the previous operator
      calculateResult();
      _firstNumber =
          double.parse(_display); // Use the result for further calculation
    }

    _operator = operator;
    _isNewInput = true; // Prepare for new input after operator
    notifyListeners();
  }

  // Perform the calculation
  void calculateResult() {
    if (_firstNumber != null && _operator != null) {
      _secondNumber = double.parse(_display);

      try {
        double result = _calculatorModel.calculate(
            _firstNumber!, _secondNumber!, _operator!);

        _display = result.toString();

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
        _firstNumber = result; // Save result for continued operations
        _secondNumber = null;
        _isNewInput = true; // Prepare for new input after result
        _showExplosionGif = false; // No explosion on valid calculations
      } catch (e) {
        _display = "Error";
        if (e.toString().contains("Division by zero")) {
          _showExplosionScreen(); // Trigger explosion screen
        }
        _firstNumber = null;
        _secondNumber = null;
        _operator = null;
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

  // Reset everything (clear)
  void clear() {
    _display = "0";
    _firstNumber = null;
    _secondNumber = null;
    _operator = null;
    _isNewInput = true;
    _showExplosionGif = false; // Reset explosion flag
    notifyListeners();
  }
}
