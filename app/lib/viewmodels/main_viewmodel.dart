import '../models/main_model.dart';
import '../models/calculator_model.dart';
import 'package:flutter/material.dart';

class MainViewModel extends ChangeNotifier {
  MainModel mainModel = MainModel();

  List<CalculatorModel> get calculators => mainModel.calculators;

  void shareResult(String result, String calculatorId) {
    CalculatorModel calculator = mainModel.calculators
        .firstWhere((calculator) => calculator.id == calculatorId);
    calculator.resultFromExternalCalculator = double.parse(result);
    notifyListeners();
  }

  void updateCalculatorName(String id, String name) {
    CalculatorModel calculator =
        mainModel.calculators.firstWhere((calculator) => calculator.id == id);
    calculator.name = name;
    notifyListeners();
  }

  void addCalculator() {
    CalculatorModel calculator = CalculatorModel();
    mainModel.calculators.add(calculator);
    print(mainModel.calculators);
    notifyListeners();
  }

  void removeCalculator(String id) {
    mainModel.calculators.removeWhere((calculator) => calculator.id == id);
    notifyListeners();
  }
}
