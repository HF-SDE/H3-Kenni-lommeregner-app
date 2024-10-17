import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';
import '../../viewmodels/main_viewmodel.dart';
import '../../widgets/calculator_list.dart';
import 'package:flutter/material.dart';

class MainIOSView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    MainViewModel viewModel = Provider.of<MainViewModel>(context);

    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Text("iOS Calculator"),
        ),
        body: CalculatorListView(viewModel: viewModel),
      ),
    );
  }
}
