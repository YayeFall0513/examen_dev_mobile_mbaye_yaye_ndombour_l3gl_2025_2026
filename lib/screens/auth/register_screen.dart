import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/auth_provider.dart';
import '../../widgets/common/custom_button.dart';
import '../../widgets/common/custom_text_field.dart';
import '../home/home_screen.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmController = TextEditingController();

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
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CustomTextField(
                  label: "Nom",
                  controller: _nameController,
                  validator: (value) {
                    if (value == null || value.isEmpty) return "Nom obligatoire";
                    if (value.length < 2) return "Minimum 2 caractères";
                    return null;
                  },
                ),
                const SizedBox(height: 16),
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
                CustomTextField(
                  label: "Confirmer mot de passe",
                  controller: _confirmController,
                  obscureText: true,
                  validator: (value) {
                    if (value != _passwordController.text) return "Les mots de passe ne correspondent pas";
                    return null;
                  },
                ),
                const SizedBox(height: 16),

                // Message d'erreur global avec Visibility
                Visibility(
                  visible: _errorMessage != null,
                  child: Text(
                    _errorMessage ?? "",
                    style: const TextStyle(color: Colors.red),
                  ),
                ),

                const SizedBox(height: 16),

                // Bouton S'inscrire
                CustomButton(
                  text: "S'inscrire",
                  isLoading: _isLoading,
                  onPressed: () async {
                    if (_formKey.currentState!.validate()) {
                      setState(() {
                        _isLoading = true;
                        _errorMessage = null;
                      });
                      try {
                        await authProvider.register(
                          _nameController.text.trim(),
                          _emailController.text.trim(),
                          _passwordController.text,
                        );
                        // Si inscription réussie, naviguer vers HomeScreen
                        Navigator.pushAndRemoveUntil(
                          context,
                          MaterialPageRoute(builder: (_) => const HomeScreen()),
                              (route) => false,
                        );
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
                GestureDetector(
                  onTap: () {
                    Navigator.pop(context);
                  },
                  child: const Text("Déjà un compte ? Se connecter"),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}