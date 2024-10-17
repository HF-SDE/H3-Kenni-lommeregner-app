import 'package:app/views/android/calculator_android-view.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import '../utils/platform_utils.dart';

import '../views/ios/main_ios_view.dart';

class PlatformView extends StatelessWidget {
  const PlatformView({super.key});

  @override
  Widget build(BuildContext context) {
    return isIOS() ? MainIOSView() : CalculatorAndroidView();
  }
}
