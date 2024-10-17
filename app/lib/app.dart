import 'package:app/viewmodels/main_viewmodel.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'viewmodels/calculator_viewmodel.dart';

import 'package:toastification/toastification.dart';
import 'views/platform_view.dart';
import 'views/ios/main_ios_view.dart';

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(providers: [
      ChangeNotifierProvider(create: (_) => MainViewModel()),
      ChangeNotifierProvider(
          create: (_) =>
              CalculatorViewModel()), // Ensure the ViewModel is provided
    ], child: ToastificationWrapper(child: PlatformView())
        // This is where the view will access the ViewModel
        );
  }
}
