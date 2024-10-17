import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../viewmodels/calculator_viewmodel.dart';
import '../models/calculator_model.dart';
import '../widgets/share_to_calculator.dart';

class CalculatorView extends StatelessWidget {
  const CalculatorView({super.key, required this.calculator});
  final CalculatorModel calculator;

  @override
  Widget build(BuildContext context) {
    final CalculatorModel = context.watch<CalculatorViewModel>();

    CalculatorModel.setCalculator(calculator);

    return MaterialApp(
      theme: ThemeData(
          colorScheme: ColorScheme.fromSwatch(primarySwatch: Colors.green)),
      darkTheme: ThemeData.dark(),
      home: Scaffold(
        appBar: AppBar(
          title: Text(calculator.name == "" ? calculator.id : calculator.name),
          actions: [
            ShareToCalculator(calculator: calculator),
          ],
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
        ),
        body: CalculatorModel.showExplosionGif
            ? Center(
                // Show the GIF over the whole screen
                child: Image.asset(
                  'assets/boom.gif',
                  width: 400,
                  height: 600,
                ),
              )
            : Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  CalculatorModel.resultFromExternalCalculator != "null"
                      ? ColoredBox(
                          color: Colors.green,
                          child: Material(
                            child: ListTile(
                              trailing: IconButton(
                                icon: const Icon(Icons.paste,
                                    size: 36, color: Colors.black),
                                onPressed: () {
                                  CalculatorModel.setInputFromExternal();
                                },
                              ),
                              leading: Text(
                                  style: const TextStyle(
                                      fontSize: 24,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.black),
                                  CalculatorModel.resultFromExternalCalculator
                                      .toString()),
                              title: const Text(
                                  style: TextStyle(color: Colors.black),
                                  'Do you want to past this number?'),
                              subtitle: const Text(
                                  style: TextStyle(color: Colors.black),
                                  "Number was send from another calculator."),
                              tileColor: Colors.blue,
                            ),
                          ),
                        )
                      : const SizedBox.shrink(),
                  Expanded(
                    child: Container(
                      alignment: Alignment.centerRight,
                      padding: const EdgeInsets.all(20),
                      child: Text(
                        CalculatorModel.display.replaceAll(".", ","),
                        style: const TextStyle(fontSize: 48),
                      ),
                    ),
                  ),
                  _buildButtonRow(CalculatorModel, ["Undo", "Del", "-/+", "/"]),
                  _buildButtonRow(CalculatorModel, ["7", "8", "9", "*"]),
                  _buildButtonRow(CalculatorModel, ["4", "5", "6", "-"]),
                  _buildButtonRow(CalculatorModel, ["1", "2", "3", "+"]),
                  _buildButtonRow(CalculatorModel, ["0", "C", ",", "="]),
                ],
              ),
      ),
      debugShowCheckedModeBanner: false,
    );
  }

  Widget _buildButtonRow(CalculatorViewModel viewModel, List<String> buttons) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: buttons.map((buttonText) {
          return TextButton(
            style: TextButton.styleFrom(
                minimumSize: const Size(80, 80),
                backgroundColor: ["+", "-", "*", "/", "="].contains(buttonText)
                    ? buttonText == viewModel.operator
                        ? Colors.orange.shade800
                        : Colors.orange
                    : ["Undo", "Del", "-/+"].contains(buttonText)
                        ? Colors.grey.shade800
                        : Colors.grey,
                shape: const CircleBorder()),
            onPressed: () {
              if (buttonText == "C") {
                viewModel.clear();
              } else if (buttonText == "=") {
                viewModel.calculateResult();
              } else if (["+", "-", "*", "/"].contains(buttonText)) {
                viewModel.setOperator(buttonText);
              } else if (buttonText == "Undo") {
                viewModel.undoLastOperation();
              } else if (buttonText == "Del") {
                viewModel.deleteLastDigit();
              } else if (buttonText == "-/+") {
                viewModel.makeNumberPositiveOrNegative();
              } else {
                viewModel.inputNumber(buttonText);
              }
            },
            child: Text(buttonText,
                style: const TextStyle(fontSize: 24, color: Colors.white)),
          );
        }).toList(),
      ),
    );
  }
}
