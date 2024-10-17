import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';
import '../viewmodels/main_viewmodel.dart';
import '../widgets/calculator_list.dart';
import 'package:flutter/material.dart';

class MainView extends StatelessWidget {
  const MainView({super.key});

  @override
  Widget build(BuildContext context) {
    MainViewModel viewModel = Provider.of<MainViewModel>(context);

    return MaterialApp(
      theme: ThemeData(
          colorScheme: ColorScheme.fromSwatch(primarySwatch: Colors.green)),
      darkTheme: ThemeData.dark(),
      home: Scaffold(
        appBar: AppBar(
          title: const Text("Awesome Calculator"),
          actions: [
            IconButton(
              onPressed: () {
                viewModel.addCalculator();
              },
              icon: const Icon(Icons.add),
            ),
          ],
        ),
        body: CalculatorListView(viewModel: viewModel),
      ),
    );
  }
}
