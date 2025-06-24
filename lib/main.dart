import 'package:flutter/material.dart';
import 'screens/splash_screen.dart'; // Importing the splash screen

void main() {
  runApp(const CarRentalApp());
}

class CarRentalApp extends StatelessWidget {
  const CarRentalApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Car Rental',
      theme: ThemeData(
        primaryColor: const Color(0xFF0D47A1), // Deep Blue
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF0D47A1),
          primary: const Color(0xFF0D47A1),
          secondary: const Color(0xFFFFC107), // Yellow
        ),
        scaffoldBackgroundColor: const Color(0xFFF5F5F5), // Light Gray
        useMaterial3: true, // Using Material 3 for modern design
        fontFamily: 'Roboto', // Clean and readable font
      ),
      home: const SplashScreen(),
    );
  }
}
