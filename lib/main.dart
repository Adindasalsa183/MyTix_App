import 'package:flutter/material.dart';
import 'screens/onboarding_screen.dart';
import 'screens/register_screen.dart';
import 'screens/home_screen.dart';

void main() {
  runApp(const MyTixMainApp());
}

class MyTixMainApp extends StatefulWidget {
  const MyTixMainApp({super.key});

  @override
  State<MyTixMainApp> createState() => _MyTixMainAppState();
}

class _MyTixMainAppState extends State<MyTixMainApp> {
  int _currentStep = 0; // 0: Onboarding, 1: Register, 2: Home

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        fontFamily: 'Roboto',
        scaffoldBackgroundColor: const Color(0xFF001935),
      ),
      home: _buildScreen(),
    );
  }

  Widget _buildScreen() {
    switch (_currentStep) {
      case 0:
        return MyTixOnboardingScreen(
          onNext: () => setState(() => _currentStep = 1),
          onExplore: () => setState(() => _currentStep = 2),
        );
      case 1:
        return MyTixRegisterScreen(
          onBack: () => setState(() => _currentStep = 0),
          onSuccess: () => setState(() => _currentStep = 2),
        );
      case 2:
      default:
        return MyTixHomeScreen();
    }
  }
}