import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:pbp_django_auth/pbp_django_auth.dart';
import 'package:jelajah_rasa_mobile/main/screens/splash_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return Provider(
      create: (_) {
        CookieRequest request = CookieRequest();
        return request;
      },
      child: MaterialApp(
        title: 'Jelajah Rasa',
        theme: ThemeData(
          useMaterial3: true,
          colorScheme: ColorScheme.fromSwatch(
            primarySwatch: Colors.deepOrange,
          ).copyWith(
            primary: const Color(0xFFF18F73),  // Primary color: F18F73 (Reddish-orange)
            secondary: const Color(0xFFE1A85F),  // Secondary color: E1A85F (Soft yellow-brown)
          ),
          scaffoldBackgroundColor: const Color(0xFFF5F5F5),  // Background color: F5F5F5 (light gray)
        ),
        home: const SplashScreen(),
      ),
    );
  }
}