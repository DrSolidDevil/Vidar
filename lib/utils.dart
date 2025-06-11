import 'package:flutter/material.dart';

class Updater extends ChangeNotifier {
  void update() {
    notifyListeners();
  }
}