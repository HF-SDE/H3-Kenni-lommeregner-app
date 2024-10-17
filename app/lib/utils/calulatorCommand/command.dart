abstract class Command {
  void execute();
  void undo();
}

// Receiver class: Calculator
class Calculator {
  double _currentValue = 0.0;

  double get currentValue => _currentValue;

  void add(double value) {
    _currentValue += value;
  }

  void subtract(double value) {
    _currentValue -= value;
  }

  void multiply(double value) {
    _currentValue *= value;
  }

  void divide(double value) {
    if (value != 0) {
      _currentValue /= value;
    } else {
      throw Exception('Division by zero');
    }
  }

  void clear() {
    _currentValue = 0.0;
  }
}

// Concrete Command classes
class AddCommand implements Command {
  final Calculator calculator;
  final double operand;

  AddCommand(this.calculator, this.operand);

  @override
  void execute() {
    calculator.add(operand);
  }

  @override
  void undo() {
    calculator.subtract(operand);
  }
}

class SubtractCommand implements Command {
  final Calculator calculator;
  final double operand;

  SubtractCommand(this.calculator, this.operand);

  @override
  void execute() {
    calculator.subtract(operand);
  }

  @override
  void undo() {
    calculator.add(operand);
  }
}

class MultiplyCommand implements Command {
  final Calculator calculator;
  final double operand;

  MultiplyCommand(this.calculator, this.operand);

  @override
  void execute() {
    calculator.multiply(operand);
  }

  @override
  void undo() {
    calculator.divide(operand);
  }
}

class DivideCommand implements Command {
  final Calculator calculator;
  final double operand;

  DivideCommand(this.calculator, this.operand);

  @override
  void execute() {
    calculator.divide(operand);
  }

  @override
  void undo() {
    calculator.multiply(operand);
  }
}

// Invoker class
class CalculatorInvoker {
  final Calculator calculator;
  final List<Command> _commandHistory = [];

  CalculatorInvoker(this.calculator);

  void compute(Command command) {
    command.execute();
    _commandHistory.add(command);
  }

  void clearHistory() {
    _commandHistory.clear();
  }

  void undo() {
    if (_commandHistory.isNotEmpty) {
      var command = _commandHistory.removeLast();
      command.undo();
    }
  }
}

// Example usage
void main() {
  var calculator = Calculator();
  var invoker = CalculatorInvoker(calculator);

  invoker.compute(AddCommand(calculator, 10));
  print('After adding 10: ${calculator.currentValue}');

  invoker.compute(SubtractCommand(calculator, 5));
  print('After subtracting 5: ${calculator.currentValue}');

  invoker.compute(MultiplyCommand(calculator, 2));
  print('After multiplying by 2: ${calculator.currentValue}');

  invoker.compute(DivideCommand(calculator, 3));
  print('After dividing by 3: ${calculator.currentValue}');

  invoker.undo();
  print('After undoing last operation: ${calculator.currentValue}');

  invoker.undo();
  print('After undoing last operation: ${calculator.currentValue}');

  invoker.undo();
  print('After undoing last operation: ${calculator.currentValue}');

  invoker.undo();
  print('After undoing last operation: ${calculator.currentValue}');
}
