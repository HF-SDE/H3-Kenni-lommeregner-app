import 'package:app/widgets/calculator_list_item.dart';
import 'package:flutter/material.dart';
import '../viewmodels/main_viewmodel.dart';
import '../models/calculator_model.dart';
import 'package:flutter/cupertino.dart';

class CalculatorListView extends StatelessWidget {
  final MainViewModel viewModel;

  const CalculatorListView({super.key, required this.viewModel});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: ListView.builder(
            itemCount: viewModel.mainModel.calculators.length,
            itemBuilder: (context, index) {
              final calculator = viewModel.mainModel.calculators[index];
              return Column(
                children: [
                  Dismissible(
                    key: Key(calculator.id),
                    background: _buildSwipeActionLeft(),
                    secondaryBackground: _buildSwipeActionRight(),
                    confirmDismiss: (direction) async {
                      if (direction == DismissDirection.startToEnd) {
                        // Update name
                        _showUpdateNameDialog(context, calculator);
                        return false; // Prevent dismiss, as we're just updating the name
                      } else if (direction == DismissDirection.endToStart) {
                        // Delete the calculator
                        viewModel.removeCalculator(calculator.id);
                        return true; // Confirm deletion
                      }
                      return false;
                    },
                    child: CalculatorItem(calculator: calculator),
                  ),
                  const Divider(
                      height: 0, thickness: 1, indent: 0, endIndent: 0),
                ],
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildSwipeActionLeft() {
    return Container(
      color: Colors.blue,
      alignment: Alignment.centerLeft,
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: const Icon(Icons.edit, color: Colors.white),
    );
  }

  Widget _buildSwipeActionRight() {
    return Container(
      color: Colors.red,
      alignment: Alignment.centerRight,
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: const Icon(Icons.delete, color: Colors.white),
    );
  }

  void _showUpdateNameDialog(BuildContext context, CalculatorModel calculator) {
    final TextEditingController controller =
        TextEditingController(text: calculator.name);
    showCupertinoDialog(
      context: context,
      builder: (context) {
        return CupertinoAlertDialog(
          title: const Text('Update Calculator Name'),
          content: CupertinoTextField(
            controller: controller,
            placeholder: 'Enter new name',
            style:
                TextStyle(color: Theme.of(context).textTheme.bodyLarge?.color),
            autofocus: true,
          ),
          actions: [
            CupertinoDialogAction(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Cancel'),
            ),
            CupertinoDialogAction(
              onPressed: () {
                viewModel.updateCalculatorName(calculator.id, controller.text);
                Navigator.of(context).pop();
              },
              isDefaultAction: true,
              child: const Text('Update'),
            ),
          ],
        );
      },
    );
  }
}
