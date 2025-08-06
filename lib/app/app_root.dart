import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';
import '../core/services/internet_connection_service.dart';
import 'app.dart';


class AppRoot extends StatelessWidget {
  const AppRoot({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<InternetConnectionService>(
      builder: (context, internetService, _) {
        return const MyApp();

      },
    );
  }
}
