import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';
import '../../viewmodels/calculator_viewmodel.dart';
import '../../models/calculator_model.dart';
import '../../widgets/share_to_calculator.dart';

class CalculatorIOSView extends StatelessWidget {
  const CalculatorIOSView({super.key, required this.calculator});
  final CalculatorModel calculator;

  @override
  Widget build(BuildContext context) {
    final CalculatorModel = context.watch<CalculatorViewModel>();

    CalculatorModel.setCalculator(calculator);

    return CupertinoApp(
      home: CupertinoPageScaffold(
        navigationBar: CupertinoNavigationBar(
          middle: Text(calculator.resultFromExternalCalculator.toString() == ""
              ? "IOS Calculator"
              : calculator.resultFromExternalCalculator.toString()),
          trailing: ShareToCalculator(calculator: calculator),
          leading: CupertinoButton(
            padding: EdgeInsets.zero,
            onPressed: () {
              Navigator.pop(context);
            },
            child: Text(
              "Back",
              style: TextStyle(fontSize: 16),
            ),
          ),
        ),
        child: CalculatorModel.showExplosionGif
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
                  _buildButtonRow(CalculatorModel, ["Undo", "<-", "-/+", "/"]),
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
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: buttons.map((buttonText) {
        return CupertinoButton(
          onPressed: () {
            if (buttonText == "C") {
              viewModel.clear();
            } else if (buttonText == "=") {
              viewModel.calculateResult();
            } else if (["+", "-", "*", "/"].contains(buttonText)) {
              viewModel.setOperator(buttonText);
            } else if (buttonText == "Undo") {
              viewModel.undoLastOperation();
            } else if (buttonText == "<-") {
              viewModel.deleteLastDigit();
            } else {
              viewModel.inputNumber(buttonText);
            }
          },
          child: Text(buttonText, style: const TextStyle(fontSize: 24)),
        );
      }).toList(),
    );
  }
}
