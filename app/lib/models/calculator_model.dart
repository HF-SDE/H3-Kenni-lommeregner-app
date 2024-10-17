import 'package:uuid/uuid.dart';
import '/utils/calulatorCommand/command.dart';

class CalculatorModel {
  late Calculator calculator;
  late CalculatorInvoker invoker;

  String id = '';
  String name = '';
  double? firstNumber;
  double? secondNumber;
  String? operator;
  bool isNewInput = true;
  String display = "0";
  bool hasNewNumber = false;
  double? resultFromExternalCalculator;

  CalculatorModel() {
    calculator = Calculator();
    invoker = CalculatorInvoker(calculator);
    id = const Uuid().v4();
  }
}
