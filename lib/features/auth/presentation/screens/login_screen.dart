import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:inventory_management/core/constants/validators.dart';
import 'package:inventory_management/core/errors/app_exception.dart';
import 'package:inventory_management/features/auth/presentation/providers/login_controller.dart';
import 'package:inventory_management/features/auth/presentation/screens/home_screen.dart';
import 'package:inventory_management/features/auth/presentation/screens/register_screen.dart';
import 'package:inventory_management/features/auth/presentation/widgets/auth_button.dart';
import 'package:inventory_management/features/auth/presentation/widgets/auth_text_field.dart';

class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key});

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  final _formKey = GlobalKey<FormState>();

  final _emailController = TextEditingController();
  final _pwController = TextEditingController();

  void _onLoginPressed() {
    // Validate all fields in the Form
    if (_formKey.currentState!.validate()) {
      // Inputs are valid! Get values via controllers:
      final email = _emailController.text.trim();
      final password = _pwController.text;

      ref
          .read(loginControllerProvider.notifier)
          .login(email: email, password: password);
    }
  }

  @override
  void dispose() {
    _emailController.dispose();
    _pwController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(loginControllerProvider);

    ref.listen(loginControllerProvider, (previous, next) {
      next.whenOrNull(
        data: (response) {
          if (response != null) {
            ScaffoldMessenger.of(
              context,
            ).showSnackBar(const SnackBar(content: Text("Login Successful!")));
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => const HomeScreen()),
            );
          }
        },
        error: (err, stack) {
          final message = err is AppException
              ? err.message
              : "Something went wrong";
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text(message)));
        },
      );
    });

    final isLoading = state.isLoading;

    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "Inventory Management",
                  style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 32),
                AuthTextField(
                  label: "Email",
                  hintText: "Enter your email",
                  controller: _emailController,
                  keyboardType: TextInputType.emailAddress,
                  validator: (value) => Validators.emailValidator(value),
                  onChanged: (value) {},
                ),
                const SizedBox(height: 16),

                AuthTextField(
                  label: "Password",
                  hintText: "Enter your password",
                  controller: _pwController,
                  obscureText: true,
                  validator: (value) => Validators.passwordValidator(value),
                  onChanged: (value) {},
                ),
                const SizedBox(height: 30),

                AuthButton(
                  text: isLoading ? "Login..." : "Login",
                  
                  onPressed: isLoading ? () {} : () {
                    _onLoginPressed();
                  },
                ),

                const SizedBox(height: 16),

                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "Don't have an account?",
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                    TextButton(
                      onPressed: () {
                        // Navigate to the registration screen
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const RegisterScreen(),
                          ),
                        );
                      },
                      child: const Text("Register"),
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
}
