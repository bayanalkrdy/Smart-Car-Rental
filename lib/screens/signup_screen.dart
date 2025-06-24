import 'package:car_rental_app/screens/login_screen.dart';
import 'package:flutter/material.dart';
// import 'dart:convert';
// import 'package:http/http.dart' as http;
// import 'package:shared_preferences/shared_preferences.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();
  final TextEditingController _licenseNumberController =
      TextEditingController();
// TODO: Add controller or picker for license image if needed

  void _signUp() async {
    // Show a temporary loading indicator (optional but user-friendly)
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => const Center(child: CircularProgressIndicator()),
    );

    await Future.delayed(
        const Duration(seconds: 2)); // simulate API call or processing

    if (!mounted)
      return; // Always good to check if the widget is still mounted after async

    Navigator.pop(context); // Close the loading dialog
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => const LoginScreen()),
    );

    // 🟡 Actual signup logic - Currently disabled. Uncomment to activate.
    /*
  final String name = _nameController.text.trim();
  final String email = _emailController.text.trim();
  final String password = _passwordController.text;
  final String phone = _phoneController.text.trim();
  final String address = _addressController.text.trim();
  final String licenseNumber = _licenseNumberController.text.trim();
  // Optional: Add license image if necessary (e.g., via image picker or URL)

  final url = Uri.parse('https://your-api-url.com/api/signup');
  try {
    final response = await http.post(
      url,
      headers: {'Accept': 'application/json'},
      body: {
        'name': name,
        'email': email,
        'password': password,
        'phone': phone,
        'address': address,
        'license_number': licenseNumber,
        // Optional: 'license_image': 'image_url_or_path' if needed
      },
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Server: ${data['message']}')),
      );

      final prefs = await SharedPreferences.getInstance();
      // Optionally save data if needed, for example, saving user info
      // await prefs.setString('user', jsonEncode(data['user']));

      // Navigate to login screen
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const LoginScreen()),
      );
    } else {
      final error = jsonDecode(response.body);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Signup failed: ${error['message']}')),
      );
    }
  } catch (e) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Network error: $e')),
    );
  }
  */
  }

  void _navigateToLogin() {
    Navigator.pop(context); // Assuming LoginScreen is the previous screen
    // Or you can use:
    // Navigator.push(context, MaterialPageRoute(builder: (context) => LoginScreen()));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Gradient Background
          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [Color(0xFF0D47A1), Color(0xFF42A5F5)],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
            ),
          ),

          SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const SizedBox(height: 20),

                  // Icon Avatar
                  const CircleAvatar(
                    radius: 40,
                    backgroundColor: Colors.white,
                    child: Icon(Icons.person_add,
                        size: 40, color: Color(0xFF0D47A1)),
                  ),

                  const SizedBox(height: 16),

                  // Page Title
                  const Text(
                    'Create Account',
                    style: TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),

                  const SizedBox(height: 30),

                  // Text fields
                  _buildStyledTextField(
                    controller: _nameController,
                    label: 'Name',
                    icon: Icons.person,
                  ),
                  const SizedBox(height: 20),

                  _buildStyledTextField(
                    controller: _emailController,
                    label: 'Email',
                    icon: Icons.email,
                  ),
                  const SizedBox(height: 20),

                  _buildStyledTextField(
                    controller: _passwordController,
                    label: 'Password',
                    icon: Icons.lock,
                    obscure: true,
                  ),
                  const SizedBox(height: 20),

                  _buildStyledTextField(
                    controller: _phoneController,
                    label: 'Phone',
                    icon: Icons.phone,
                  ),
                  const SizedBox(height: 20),

                  _buildStyledTextField(
                    controller: _addressController,
                    label: 'Address',
                    icon: Icons.home,
                  ),
                  const SizedBox(height: 20),

                  _buildStyledTextField(
                    controller: _licenseNumberController,
                    label: 'License Number',
                    icon: Icons.confirmation_num,
                  ),
                  const SizedBox(height: 30),

                  // Sign Up Button with Icon
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      onPressed: _signUp,
                      icon: const Icon(Icons.check_circle_outline),
                      label: const Text(
                        'Sign Up',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white,
                        foregroundColor: const Color(0xFF0D47A1),
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14),
                        ),
                        elevation: 5,
                      ),
                    ),
                  ),

                  const SizedBox(height: 20),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text(
                        'Already have an account?',
                        style: TextStyle(color: Colors.white),
                      ),
                      TextButton(
                        onPressed: _navigateToLogin,
                        child: const Text(
                          'Login',
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            decoration: TextDecoration.underline,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// Helper for styled text fields
Widget _buildStyledTextField({
  required TextEditingController controller,
  required String label,
  required IconData icon,
  bool obscure = false,
}) {
  return TextField(
    controller: controller,
    obscureText: obscure,
    style: const TextStyle(color: Colors.white),
    decoration: InputDecoration(
      labelText: label,
      labelStyle: const TextStyle(color: Colors.white70),
      prefixIcon: Icon(icon, color: Colors.white),
      filled: true,
      fillColor: Colors.white.withOpacity(0.15),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: BorderSide.none,
      ),
    ),
  );
}
