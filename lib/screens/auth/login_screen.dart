import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/auth_provider.dart';
import '../../widgets/common/custom_text_field.dart';
import '../../widgets/common/custom_button.dart';
import '../home/home_screen.dart';
import 'register_screen.dart';

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
  String? _errorMessage;

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);

    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
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
              CustomTextField(
                label: "Mot de passe",
                controller: _passwordController,
                obscureText: true,
                validator: (value) {
                  if (value == null || value.isEmpty) return "Mot de passe obligatoire";
                  if (value.length < 6) return "Minimum 6 caractères";
                  return null;
                },
              ),
              const SizedBox(height: 16),

              // Message d'erreur global
              Visibility(
                visible: _errorMessage != null,
                child: Text(
                  _errorMessage ?? "",
                  style: const TextStyle(color: Colors.red),
                ),
              ),

              const SizedBox(height: 16),

              CustomButton(
                text: "Se connecter",
                isLoading: _isLoading,
                onPressed: () async {
                  if (_formKey.currentState!.validate()) {

                    setState(() {
                      _isLoading = true;
                      _errorMessage = null;
                    });

                    final authProvider = context.read<AuthProvider>();

                    try {
                      final success = await authProvider.login(
                        _emailController.text.trim(),
                        _passwordController.text.trim(),
                      );

                      if (success && mounted) {
                        Navigator.pushAndRemoveUntil(
                          context,
                          MaterialPageRoute(builder: (_) => const HomeScreen()),
                              (route) => false,
                        );
                      } else {
                        setState(() {
                          _errorMessage =
                              authProvider.error ?? "Email ou mot de passe incorrect";
                        });
                      }
                    } catch (e) {
                      setState(() {
                        _errorMessage = e.toString();
                      });
                    } finally {
                      if (mounted) {
                        setState(() {
                          _isLoading = false;
                        });
                      }
                    }
                  }
                },
              ),

              const SizedBox(height: 16),
              GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const RegisterScreen()),
                  );
                },
                child: const Text("Pas de compte ? S'inscrire"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}