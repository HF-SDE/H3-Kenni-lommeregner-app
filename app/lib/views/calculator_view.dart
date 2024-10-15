import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import '../views/android/calculator_android-view.dart';
import '../views/ios/calculator_ios_view.dart';
import '../utils/platform_utils.dart';

class CalculatorView extends StatelessWidget {
  const CalculatorView({super.key});

  @override
  Widget build(BuildContext context) {
    return isIOS() ? CalculatorIOSView() : CalculatorAndroidView();
  }
}
