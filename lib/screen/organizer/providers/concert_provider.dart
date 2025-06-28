import 'package:flutter/material.dart';

class ConcertProvider extends ChangeNotifier {
  Map<String, dynamic> _concert = {};

  Map<String, dynamic> get concert => _concert;

  void setConcert(Map<String, dynamic> newConcert) {
    _concert = Map<String, dynamic>.from(newConcert);
    notifyListeners();
  }

  void updateConcert(Map<String, dynamic> updatedFields) {
    _concert.addAll(updatedFields);
    notifyListeners();
  }
}