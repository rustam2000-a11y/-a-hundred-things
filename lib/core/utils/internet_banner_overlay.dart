import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../core/services/internet_connection_service.dart';

class InternetBannerOverlay extends StatelessWidget {
  const InternetBannerOverlay({super.key});

  @override
  Widget build(BuildContext context) {
    final hasInternet = context.watch<InternetConnectionService>().hasInternet;

    if (hasInternet) return const SizedBox.shrink();

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
      color: Colors.red.shade700,
      child: const SafeArea(
        bottom: false,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.wifi_off, color: Colors.white),
            SizedBox(width: 8),
            Text(
              'No internet connection',
              style: TextStyle(color: Colors.white),
            ),
          ],
        ),
      ),
    );
  }
}
