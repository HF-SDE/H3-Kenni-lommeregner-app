import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/calculator_model.dart';
import '../viewmodels/main_viewmodel.dart';

class ShareToCalculator extends StatefulWidget {
  final CalculatorModel calculator;

  const ShareToCalculator({super.key, required this.calculator});

  @override
  ShareToCalculatorState createState() => ShareToCalculatorState();
}

class ShareToCalculatorState extends State<ShareToCalculator> {
  String? selectedCalculatorId;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final mainModel = context.watch<MainViewModel>();

    //if list of calculators (excluding current calculator) is not empty, set selectedCalculatorId to the first calculator id
    if (mainModel.calculators.length > 1) {
      selectedCalculatorId = mainModel.calculators
          .where((calc) => calc.id != widget.calculator.id)
          .first
          .id;
    }

    void shareResultWithSelectedCalculator() {
      if (selectedCalculatorId != null) {
        // Perform the action with the selected calculator id
        mainModel.shareResult(widget.calculator.display, selectedCalculatorId!);
        print(
            "Shared $widget.calculator.display; result with calculator: $widget.calculator.id");
      }
    }

    return mainModel.calculators.length > 1
        ? CupertinoButton(
            padding: EdgeInsets.zero,
            child: const Text("Share"),
            onPressed: () {
              showCupertinoDialog(
                context: context,
                builder: (BuildContext context) {
                  return CupertinoActionSheet(
                    title: const Text('Select Calculator to Share'),
                    actions: <Widget>[
                      SizedBox(
                        height: 200, // Limit the height for picker
                        child: CupertinoPicker(
                          itemExtent: 32.0,
                          onSelectedItemChanged: (int index) {
                            setState(() {
                              selectedCalculatorId =
                                  mainModel.calculators[index].id;
                            });
                          },
                          children: mainModel.calculators
                              .where((calc) => calc.id != widget.calculator.id)
                              .map((calc) =>
                                  Text(calc.name == "" ? calc.id : calc.name))
                              .toList(),
                        ),
                      ),
                      CupertinoActionSheetAction(
                        /// This parameter indicates the action would be a default
                        /// default behavior, turns the action's text to bold text.
                        isDefaultAction: true,
                        onPressed: () {
                          shareResultWithSelectedCalculator();
                          Navigator.pop(context);
                        },
                        child: const Text('Send Result'),
                      ),
                    ],
                    cancelButton: CupertinoActionSheetAction(
                      child: const Text('Cancel'),
                      onPressed: () {
                        Navigator.pop(context);
                      },
                    ),
                  );
                },
              );
            },
          )
        : const SizedBox.shrink();
  }
}
