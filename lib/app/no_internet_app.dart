import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class NoInternetApp extends StatelessWidget {
  const NoInternetApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: Scaffold(
        backgroundColor: Colors.white,
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.wifi_off, size: 80, color: Colors.grey),
              SizedBox(height: 20),
              Text(
                'No internet connection',
                style: TextStyle(fontSize: 18),
              ),
              SizedBox(height: 10),
              Text('Please check your connection and restart the app.'),
            ],
          ),
        ),
      ),
    );
  }
}
