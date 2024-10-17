import 'package:app/viewmodels/main_viewmodel.dart';
import 'package:app/views/main_view.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'viewmodels/calculator_viewmodel.dart';
import 'package:toastification/toastification.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  MyAppState createState() => MyAppState();
}

class MyAppState extends State<MyApp> with WidgetsBindingObserver {
  bool _isColdStart = true;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this); // Add observer for app lifecycle
    _initializeApp();
  }

  @override
  void dispose() {
    WidgetsBinding.instance
        .removeObserver(this); // Remove observer for app lifecycle
    super.dispose();
  }

  void _initializeApp() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    // If this is a cold start (app opened after a complete shutdown)
    if (_isColdStart) {
      _showToast(
          "Welcome"); // Show "Welcome" for the first time after a cold start
      _isColdStart = false; // Mark that the cold start has been handled
    }

    // Mark the app as visited
    prefs.setBool('hasVisited', true);
  }

  // Handle app lifecycle changes
  @override
  void didChangeAppLifecycleState(AppLifecycleState state) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    if (state == AppLifecycleState.resumed) {
      bool hasVisited = prefs.getBool('hasVisited') ?? false;

      if (hasVisited && !_isColdStart) {
        _showToast("Welcome Back");
      }
    } else if (state == AppLifecycleState.paused) {
      // Save the state when the app goes to the background
      await prefs.setBool('hasVisited', true);
    } else if (state == AppLifecycleState.detached) {
      // Reset for the next cold start when the app is fully closed
      _isColdStart = true;
    }
  }

  void _showToast(String message) {
    toastification.show(
      title: Text(message),
      autoCloseDuration: const Duration(seconds: 2),
      type: ToastificationType.info,
    );
  }

  @override
  Widget build(BuildContext context) {
    return MultiProvider(providers: [
      ChangeNotifierProvider(create: (_) => MainViewModel()),
      ChangeNotifierProvider(
          create: (_) =>
              CalculatorViewModel()), // Ensure the ViewModel is provided
    ], child: const ToastificationWrapper(child: MainView()));
  }
}
