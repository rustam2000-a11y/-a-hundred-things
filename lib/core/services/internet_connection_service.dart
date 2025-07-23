import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';

class InternetConnectionService extends ChangeNotifier {
  bool hasInternet = true;

  InternetConnectionService() {
    Connectivity().onConnectivityChanged.listen((results) {
      final connected = results.any((r) => r != ConnectivityResult.none);
      if (connected != hasInternet) {
        hasInternet = connected;
        notifyListeners();
      }
    });
  }
}
