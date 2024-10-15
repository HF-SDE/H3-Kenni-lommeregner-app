import 'package:uuid/uuid.dart';
import '/utils/calulatorCommand/command.dart';

class CalculatorModel {
  String id = '';
  late Calculator calculator;
  late CalculatorInvoker invoker;

  double? firstNumber;
  double? secondNumber;
  String? operator;
  bool isNewInput = true;
  String display = "0";

  CalculatorModel() {
    calculator = Calculator();
    invoker = CalculatorInvoker(calculator);
    id = const Uuid().v4();
  }
}
