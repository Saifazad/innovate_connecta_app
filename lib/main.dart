import 'package:flutter/material.dart';
import 'app/routes/app_routes.dart';
import 'core/theme/theme.dart';
import 'features/splash/views/splash_screen.dart';

void main() {
  runApp(const InnovateConnectaApp());
}

class InnovateConnectaApp extends StatelessWidget {
  const InnovateConnectaApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Innovate Connecta',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.darkTheme,
      home: const SplashScreen(),
      onGenerateRoute: AppRoutes.onGenerateRoute,
    );
  }
}
