class CalculatorModel {
  // The method that handles calculation based on operator
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
}
