import 'package:flutter/material.dart';

class Counter with ChangeNotifier {
  int _counter;
  Counter(this._counter);
  void addCount() {
    _counter++;
    notifyListeners();
  }

  get count => _counter;
}
