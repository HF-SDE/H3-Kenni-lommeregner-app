import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';
import '../../viewmodels/calculator_viewmodel.dart';

class CalculatorIOSView extends StatelessWidget {
  const CalculatorIOSView({super.key});

  @override
  Widget build(BuildContext context) {
    final viewModel = context.watch<CalculatorViewModel>();

    return CupertinoApp(
      home: CupertinoPageScaffold(
        navigationBar: const CupertinoNavigationBar(
          middle: Text("iOS Calculator"),
        ),
        child: viewModel.showExplosionGif
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
                        viewModel.display.replaceAll(".", ","),
                        style: const TextStyle(fontSize: 48),
                      ),
                    ),
                  ),
                  _buildButtonRow(viewModel, ["Undo", "<-", "-/+", "/"]),
                  _buildButtonRow(viewModel, ["7", "8", "9", "*"]),
                  _buildButtonRow(viewModel, ["4", "5", "6", "-"]),
                  _buildButtonRow(viewModel, ["1", "2", "3", "+"]),
                  _buildButtonRow(viewModel, ["0", "C", ",", "="]),
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
