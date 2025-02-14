import 'package:flutter/material.dart';
import 'screens/home_screen.dart';
import 'screens/login_screen.dart';
import 'screens/signup_screen.dart';
import 'screens/billing_screen.dart';
import 'screens/paytrack_screen.dart';
import 'screens/billing_history_screen.dart'; // Added Billing History Screen

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Billing App',
      theme: ThemeData(primarySwatch: Colors.blue),
      initialRoute: '/login',
      routes: {
        '/login': (context) => const LoginScreen(),
        '/signup': (context) => const SignupScreen(),
        '/home': (context) => const HomeScreen(),
        '/billing': (context) => const BillingScreen(),
        '/billing-history': (context) =>
            const BillingHistoryScreen(), // Added Route
        '/paytrack': (context) => const PayTrackScreen(),
      },
    );
  }
}
