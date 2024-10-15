import '../models/main_model.dart';
import '../models/calculator_model.dart';

class MainViewModel {
  MainModel model = MainModel();

  void addCalculator() {
    CalculatorModel calculator = CalculatorModel();
    model.calculators.add(calculator);
  }

  void removeCalculator(String id) {
    model.calculators.removeWhere((calculator) => calculator.id == id);
  }
}
