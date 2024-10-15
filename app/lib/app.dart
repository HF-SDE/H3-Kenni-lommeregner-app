import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'viewmodels/calculator_viewmodel.dart';
import 'views/calculator_view.dart';
import 'package:toastification/toastification.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(providers: [
      ChangeNotifierProvider(
          create: (_) =>
              CalculatorViewModel()), // Ensure the ViewModel is provided
    ], child: ToastificationWrapper(child: CalculatorView())
        // This is where the view will access the ViewModel
        );
  }
}
