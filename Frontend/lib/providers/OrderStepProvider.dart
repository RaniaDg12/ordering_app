import 'package:flutter/material.dart';
import '../models/article.dart';
import '../models/enums/priority.dart';

class OrderStepProvider extends ChangeNotifier {
  int _currentStep = 0;
  Map<String, dynamic> _orderData = {
    'site': '',
    'client': '',
    'dateCommande': '',
    'dateLivraison': '',
    'articles': <Article>[],
    'priority': Priority.Faible,
    'observation': '',
  };

  int get currentStep => _currentStep;
  Map<String, dynamic> get orderData => _orderData;

  void setCurrentStep(int step) {
    _currentStep = step;
    notifyListeners();
  }

  void incrementStep() {
    if (_currentStep < 2) {
      _currentStep++;
      print('Current Step: $_currentStep');
      notifyListeners();
    }
  }

  void decrementStep() {
    if (_currentStep > 0) {
      _currentStep--;
      print('Current Step: $_currentStep');
      notifyListeners();
    }
  }

  void updateOrderData(String key, dynamic value) {
    _orderData[key] = value;
    print('Updated $_orderData');
    notifyListeners();
  }

  dynamic getOrderData(String key) {
    return _orderData[key];
  }

  void resetOrderData() {
    _orderData = {
      'site': '',
      'client': '',
      'dateCommande': '',
      'dateLivraison': '',
      'articles': [],
      'priority': Priority.Faible,
      'observation': '',
    };
    notifyListeners();
  }

}
