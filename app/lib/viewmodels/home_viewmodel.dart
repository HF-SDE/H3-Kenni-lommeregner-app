// // lib/viewmodels/home_viewmodel.dart

// import 'package:flutter/material.dart';
// import './calculator_viewmodel.dart';
// import '../models/calculator_model.dart';

// class HomeViewModel extends ChangeNotifier {
//   final List<CalculatorViewModel> calculators = [];

//   void addCalculator() {
//     calculators.add(CalculatorViewModel(model: CalculatorModel()));
//     notifyListeners();
//   }

//   void removeCalculator(String id) {
//     calculators.removeWhere((calculator) => calculator.model.id == id);
//     notifyListeners();
//   }
// }
