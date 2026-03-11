import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/auth_provider.dart';
import '../../widgets/common/custom_text_field.dart';
import '../../widgets/common/custom_button.dart';
import 'register_screen.dart';
import '../home/home_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  bool _isLoading = false;
  bool _obscurePassword = true; // Toggle pour montrer/masquer mot de passe
  String? _errorMessage;

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);

    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Center(
          child: SingleChildScrollView(
            child: Form(
              key: _formKey,
              child: Column(
                children: [
                  // Email
                  CustomTextField(
                    label: "Email",
                    controller: _emailController,
                    keyboardType: TextInputType.emailAddress,
                    validator: (value) {
                      if (value == null || value.isEmpty) return "Email obligatoire";
                      if (!value.contains("@") || !value.contains(".")) return "Email invalide";
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),

                  // Mot de passe
                  CustomTextField(
                    label: "Mot de passe",
                    controller: _passwordController,
                    obscureText: _obscurePassword,
                    validator: (value) {
                      if (value == null || value.isEmpty) return "Mot de passe obligatoire";
                      if (value.length < 6) return "Minimum 6 caractères";
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),

                  // Message d'erreur
                  Visibility(
                    visible: _errorMessage != null,
                    child: Text(
                      _errorMessage ?? "",
                      style: const TextStyle(color: Colors.red),
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Bouton Se connecter
                  CustomButton(
                    text: "Se connecter",
                    isLoading: _isLoading,
                    onPressed: () async {
                      if (_formKey.currentState!.validate()) {
                        setState(() {
                          _isLoading = true;
                          _errorMessage = null;
                        });
                        try {
                          await authProvider.login(
                            _emailController.text.trim(),
                            _passwordController.text,
                          );
                          // Navigation vers HomeScreen si succès
                          if (mounted) {
                            Navigator.pushAndRemoveUntil(
                              context,
                              MaterialPageRoute(builder: (_) => const HomeScreen()),
                                  (route) => false,
                            );
                          }
                        } catch (e) {
                          setState(() {
                            _errorMessage = e.toString();
                          });
                        } finally {
                          setState(() {
                            _isLoading = false;
                          });
                        }
                      }
                    },
                  ),
                  const SizedBox(height: 16),

                  // Lien vers RegisterScreen
                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (_) => const RegisterScreen()),
                      );
                    },
                    child: const Text(
                      "Pas de compte ? S'inscrire",
                      style: TextStyle(
                        color: Colors.blue,
                        decoration: TextDecoration.underline,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}