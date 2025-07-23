import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'app/app.dart';
import 'app/no_internet_app.dart';
import 'core/di/service_locator.dart';
import 'core/services/internet_connection_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final connectivityResults = await Connectivity().checkConnectivity();
  final hasInternet = connectivityResults.any((r) => r != ConnectivityResult.none);

  if (!hasInternet) {
    runApp(const NoInternetApp());
    return;
  }

  await Firebase.initializeApp();
  configureDependencies();

  runApp(
    ChangeNotifierProvider(
      create: (_) => InternetConnectionService(),
      child: const MyApp(),
    ),
  );
}


