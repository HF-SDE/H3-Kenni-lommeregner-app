import 'package:flutter/material.dart';
import '../models/calculator_model.dart';
import '../views/calculator_view.dart';

class CalculatorItem extends StatelessWidget {
  final CalculatorModel calculator;

  const CalculatorItem({super.key, required this.calculator});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(calculator.name == "" ? calculator.id : calculator.name),
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => CalculatorView(calculator: calculator)),
        );
      },
    );
  }
}
