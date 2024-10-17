import 'package:app/views/ios/calculator_ios_view.dart';
import 'package:flutter/material.dart';
import '../viewmodels/main_viewmodel.dart';
import '../models/calculator_model.dart';
import 'package:flutter/cupertino.dart';

class CalculatorListView extends StatelessWidget {
  final MainViewModel viewModel;

  CalculatorListView({required this.viewModel});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: ListView.builder(
            itemCount: viewModel.mainModel.calculators.length,
            itemBuilder: (context, index) {
              final calculator = viewModel.mainModel.calculators[index];
              return Dismissible(
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
              );
            },
          ),
        ),
        CupertinoButton(
          onPressed: () {
            viewModel.addCalculator();
            print("adding calculator " +
                viewModel.mainModel.calculators.length.toString());
          },
          child: Text('Add New Calculator'),
        ),
      ],
    );
  }

  Widget _buildSwipeActionLeft() {
    return Container(
      color: Colors.blue,
      alignment: Alignment.centerLeft,
      padding: EdgeInsets.symmetric(horizontal: 20),
      child: Icon(Icons.edit, color: Colors.white),
    );
  }

  Widget _buildSwipeActionRight() {
    return Container(
      color: Colors.red,
      alignment: Alignment.centerRight,
      padding: EdgeInsets.symmetric(horizontal: 20),
      child: Icon(Icons.delete, color: Colors.white),
    );
  }

  void _showUpdateNameDialog(BuildContext context, CalculatorModel calculator) {
    final TextEditingController controller =
        TextEditingController(text: calculator.name);
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Update Calculator Name'),
          content: TextField(
            controller: controller,
            decoration: InputDecoration(hintText: 'Enter new name'),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                viewModel.updateCalculatorName(calculator.id, controller.text);
                Navigator.of(context).pop();
              },
              child: Text('Update'),
            ),
          ],
        );
      },
    );
  }
}

class CalculatorItem extends StatelessWidget {
  final CalculatorModel calculator;

  CalculatorItem({required this.calculator});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(calculator.name == "" ? calculator.id : calculator.name),
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => CalculatorIOSView(calculator: calculator)),
        );
      },
    );
  }
}
