import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:jelajah_rasa_mobile/main/screens/login.dart';
import 'package:pbp_django_auth/pbp_django_auth.dart';
import 'package:provider/provider.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final _usernameController = TextEditingController();
  final _firstNameController = TextEditingController();
  final _lastNameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  final _adminCodeController = TextEditingController();
  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;

  @override
  Widget build(BuildContext context) {
    final request = context.watch<CookieRequest>();
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/background.png'),
            fit: BoxFit.cover,
            opacity: 0.2,
          ),
        ),
        child: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Image.asset(
                  'assets/logo.png',
                  height: 160,
                ),
                const Text(
                  'Register',
                  style: TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 16),
                _buildTextField(
                  controller: _usernameController,
                  hintText: 'Username*',
                ),
                const SizedBox(height: 16),
                _buildTextField(
                  controller: _firstNameController,
                  hintText: 'First Name*',
                ),
                const SizedBox(height: 16),
                _buildTextField(
                  controller: _lastNameController,
                  hintText: 'Last Name*',
                ),
                const SizedBox(height: 16),
                _buildTextField(
                  controller: _emailController,
                  hintText: 'Email*',
                  keyboardType: TextInputType.emailAddress,
                ),
                const SizedBox(height: 16),
                _buildTextField(
                  controller: _passwordController,
                  hintText: 'Password*',
                  isPassword: true,
                  obscureText: _obscurePassword,
                  onToggleVisibility: () {
                    setState(() {
                      _obscurePassword = !_obscurePassword;
                    });
                  },
                ),
                const SizedBox(height: 16),
                _buildTextField(
                  controller: _confirmPasswordController,
                  hintText: 'Confirm Password*',
                  isPassword: true,
                  obscureText: _obscureConfirmPassword,
                  onToggleVisibility: () {
                    setState(() {
                      _obscureConfirmPassword = !_obscureConfirmPassword;
                    });
                  },
                ),
                const SizedBox(height: 16),
                _buildTextField(
                  controller: _adminCodeController,
                  hintText: 'Admin Code',
                ),
                const SizedBox(height: 24),
                ElevatedButton(
                  onPressed: () async {
                    try {
                      String username = _usernameController.text;
                      String firstName = _firstNameController.text;
                      String lastName = _lastNameController.text;
                      String email = _emailController.text;
                      String password1 = _passwordController.text;
                      String password2 = _confirmPasswordController.text;
                      String adminCode = _adminCodeController.text;

                      // Basic validation
                      if (username.isEmpty ||
                          firstName.isEmpty ||
                          lastName.isEmpty ||
                          email.isEmpty ||
                          password1.isEmpty ||
                          password2.isEmpty) {
                        showDialog(
                          context: context,
                          builder: (context) => AlertDialog(
                            title: const Text('Registration Error'),
                            content: const Text(
                                'Please fill in all required fields.'),
                            actions: [
                              TextButton(
                                child: const Text('OK'),
                                onPressed: () => Navigator.pop(context),
                              ),
                            ],
                          ),
                        );
                        return;
                      }

                      // Length validation
                      if (username.length > 30) {
                        _usernameController.clear();
                        showDialog(
                          context: context,
                          builder: (context) => AlertDialog(
                            title: const Text('Registration Error'),
                            content: const Text(
                                'Username cannot exceed 30 characters.'),
                            actions: [
                              TextButton(
                                child: const Text('OK'),
                                onPressed: () => Navigator.pop(context),
                              ),
                            ],
                          ),
                        );
                        return;
                      }

                      if (firstName.length > 30) {
                        _firstNameController.clear();
                        showDialog(
                          context: context,
                          builder: (context) => AlertDialog(
                            title: const Text('Registration Error'),
                            content: const Text(
                                'First name cannot exceed 30 characters.'),
                            actions: [
                              TextButton(
                                child: const Text('OK'),
                                onPressed: () => Navigator.pop(context),
                              ),
                            ],
                          ),
                        );
                        return;
                      }

                      if (lastName.length > 30) {
                        showDialog(
                          context: context,
                          builder: (context) => AlertDialog(
                            title: const Text('Registration Error'),
                            content: const Text(
                                'Last name cannot exceed 30 characters.'),
                            actions: [
                              TextButton(
                                child: const Text('OK'),
                                onPressed: () => Navigator.pop(context),
                              ),
                            ],
                          ),
                        );
                        return;
                      }

                      if (email.length > 320) {
                        showDialog(
                          context: context,
                          builder: (context) => AlertDialog(
                            title: const Text('Registration Error'),
                            content: const Text(
                                'Email cannot exceed 320 characters.'),
                            actions: [
                              TextButton(
                                child: const Text('OK'),
                                onPressed: () => Navigator.pop(context),
                              ),
                            ],
                          ),
                        );
                        return;
                      }

                      // Check if passwords match
                      if (password1 != password2) {
                        showDialog(
                          context: context,
                          builder: (context) => const AlertDialog(
                            title: Text('Registration Error'),
                            content: Text('Passwords do not match.'),
                          ),
                        );
                        return;
                      }

                      // Check admin code if provided
                      if (adminCode.isNotEmpty &&
                          adminCode != "PBPC05ASELOLE") {
                        _adminCodeController.clear();
                        showDialog(
                          context: context,
                          builder: (context) => AlertDialog(
                            title: const Text('Registration Error'),
                            content: const Text(
                                'Invalid admin code. Leave empty if not admin.'),
                            actions: [
                              TextButton(
                                child: const Text('OK'),
                                onPressed: () => Navigator.pop(context),
                              ),
                            ],
                          ),
                        );
                        return;
                      }

                      final response = await request.postJson(
                        "https://daffa-desra-jelajahrasa.pbp.cs.ui.ac.id/auth/register/",
                        jsonEncode({
                          "username": username,
                          "first_name": firstName,
                          "last_name": lastName,
                          "email": email,
                          "password1": password1,
                          "password2": password2,
                          "admin_code": adminCode,
                          "image_url":
                              "https://upload.wikimedia.org/wikipedia/commons/7/7c/Profile_avatar_placeholder_large.png?20150327203541",
                        }),
                      );

                      // Add debug print to see raw response
                      print('Raw response: $response');

                      if (context.mounted) {
                        if (response['status'] == 'success') {
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const LoginPage(),
                            ),
                          );
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(
                                  "${response['message']} User ${response['username']}!"),
                            ),
                          );
                        } else {
                          String errorMessage = response['message'];
                          // Check for specific error messages and make them more user-friendly
                          if (errorMessage.contains(
                              'UNIQUE constraint failed: main_customuser.email')) {
                            errorMessage = 'This email is already registered.';
                            _emailController.clear();
                          } else if (errorMessage
                              .contains('Invalid admin code')) {
                            errorMessage =
                                'Invalid admin code. Leave empty if not admin.';
                            _adminCodeController.clear();
                          }

                          showDialog(
                            context: context,
                            builder: (context) => AlertDialog(
                              title: const Text('Registration Failed'),
                              content: Text(errorMessage),
                              actions: [
                                TextButton(
                                  child: const Text('OK'),
                                  onPressed: () => Navigator.pop(context),
                                ),
                              ],
                            ),
                          );
                        }
                      }
                    } catch (e) {
                      if (context.mounted) {
                        showDialog(
                          context: context,
                          builder: (context) => AlertDialog(
                            title: const Text('Error'),
                            content: Text('Registration failed: $e'),
                            actions: [
                              TextButton(
                                child: const Text('OK'),
                                onPressed: () => Navigator.pop(context),
                              ),
                            ],
                          ),
                        );
                        // Print error for debugging
                        print('Registration Error: $e');
                        print('Request Body: ${jsonEncode({
                              "username": _usernameController.text,
                              "first_name": _firstNameController.text,
                              "last_name": _lastNameController.text,
                              "email": _emailController.text,
                              "password1": _passwordController.text,
                              "password2": _confirmPasswordController.text,
                              "admin_code": _adminCodeController.text,
                            })}');
                      }
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFF18F73),
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: const Text(
                    'Register',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text("Already have an Account? "),
                    GestureDetector(
                      onTap: () {
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const LoginPage(),
                          ),
                        );
                      },
                      child: Text(
                        'Login',
                        style: TextStyle(
                          color: Theme.of(context).colorScheme.primary,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String hintText,
    bool isPassword = false,
    bool obscureText = false,
    VoidCallback? onToggleVisibility,
    TextInputType? keyboardType,
  }) {
    return TextField(
      controller: controller,
      obscureText: isPassword && obscureText,
      keyboardType: keyboardType,
      decoration: InputDecoration(
        hintText: hintText,
        filled: true,
        fillColor: Colors.white,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 16,
        ),
        suffixIcon: isPassword
            ? IconButton(
                icon: Icon(
                  obscureText ? Icons.visibility_off : Icons.visibility,
                  color: Colors.grey,
                ),
                onPressed: onToggleVisibility,
              )
            : null,
      ),
    );
  }
}
