import 'package:flutter/material.dart';
import 'package:pbp_django_auth/pbp_django_auth.dart';
import 'package:provider/provider.dart';
import 'package:jelajah_rasa_mobile/main/screens/login.dart';


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
            primary: const Color(0xFFAB4A2F), // Primary color: AB4A2F (Reddish-brown)
            secondary: const Color(0xFFE1A85F), // Secondary color: E1A85F (Soft yellow-brown)
          ),
          scaffoldBackgroundColor: const Color(0xFFF5F5F5), // Light background color (optional)
        ),
        home: const LoginPage(),
      ),
    );
  }
}