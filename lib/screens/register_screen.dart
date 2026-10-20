import 'package:flutter/material.dart';
import '../services/auth_service.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final AuthService _auth = AuthService();

  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final bloodController = TextEditingController();
  final cityController = TextEditingController();
  final contactController = TextEditingController();

  bool isLoading = false;

  void registerUser() async {
    setState(() => isLoading = true);

    try {
      final user = await _auth.registerUser(
        name: nameController.text.trim(),
        email: emailController.text.trim(),
        password: passwordController.text.trim(),
        bloodGroup: bloodController.text.trim(),
        city: cityController.text.trim(),
        contact: contactController.text.trim(),
      );

      if (user != null) {
        Navigator.pop(context);
      }
    } finally {
      setState(() => isLoading = false);
    }
  }

  Widget _buildField({
    required TextEditingController controller,
    required String label,
    IconData? icon,
    bool obscure = false,
  }) {
    return TextField(
      controller: controller,
      obscureText: obscure,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: icon != null ? Icon(icon) : null,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(

      // 🌈 BACKGROUND
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.red, Colors.deepOrange],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),

        child: Center(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Card(
                elevation: 10,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [

                      // ❤️ TITLE
                      const Text(
                        "Create Account",
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Colors.red,
                        ),
                      ),

                      const SizedBox(height: 6),

                      const Text(
                        "Join LifeDrop & save lives ❤️",
                        style: TextStyle(color: Colors.grey),
                      ),

                      const SizedBox(height: 20),

                      // 🧑 NAME
                      _buildField(
                        controller: nameController,
                        label: "Name",
                        icon: Icons.person,
                      ),

                      const SizedBox(height: 12),

                      // 📧 EMAIL
                      _buildField(
                        controller: emailController,
                        label: "Email",
                        icon: Icons.email,
                      ),

                      const SizedBox(height: 12),

                      // 🔒 PASSWORD
                      _buildField(
                        controller: passwordController,
                        label: "Password",
                        icon: Icons.lock,
                        obscure: true,
                      ),

                      const SizedBox(height: 12),

                      // 🩸 BLOOD GROUP
                      _buildField(
                        controller: bloodController,
                        label: "Blood Group",
                        icon: Icons.bloodtype,
                      ),

                      const SizedBox(height: 12),

                      // 🏙 CITY
                      _buildField(
                        controller: cityController,
                        label: "City",
                        icon: Icons.location_city,
                      ),

                      const SizedBox(height: 12),

                      // 📞 CONTACT
                      _buildField(
                        controller: contactController,
                        label: "Contact",
                        icon: Icons.phone,
                      ),

                      const SizedBox(height: 20),

                      // 🔘 REGISTER BUTTON
                      SizedBox(
                        width: double.infinity,
                        height: 50,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.red,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          onPressed: isLoading ? null : registerUser,
                          child: isLoading
                              ? const SizedBox(
                                  height: 20,
                                  width: 20,
                                  child: CircularProgressIndicator(
                                    color: Colors.white,
                                    strokeWidth: 2,
                                  ),
                                )
                              : const Text(
                                  "REGISTER",
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                    letterSpacing: 1,
                                  ),
                                ),
                        ),
                      ),

                      const SizedBox(height: 10),

                      // 🔙 BACK
                      TextButton(
                        onPressed: () => Navigator.pop(context),
                        child: const Text(
                          "Already have an account? Login",
                          style: TextStyle(color: Colors.red),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}