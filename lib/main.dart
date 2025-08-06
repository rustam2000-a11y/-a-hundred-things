import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'app/app_root.dart';
import 'core/di/service_locator.dart';
import 'core/services/internet_connection_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  configureDependencies();

  runApp(
    ChangeNotifierProvider(
      create: (_) => InternetConnectionService(),
      child: const AppRoot(),
    ),
  );
}



