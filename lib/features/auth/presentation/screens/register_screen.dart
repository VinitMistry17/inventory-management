import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:inventory_management/core/constants/validators.dart';
import 'package:inventory_management/core/errors/app_exception.dart';
import 'package:inventory_management/core/navigation/main_shell.dart';
import 'package:inventory_management/features/auth/presentation/providers/register_controller.dart';
import 'package:inventory_management/features/auth/presentation/screens/home_screen.dart';
import 'package:inventory_management/features/auth/presentation/screens/login_screen.dart';
import 'package:inventory_management/features/auth/presentation/widgets/auth_button.dart';
import 'package:inventory_management/features/auth/presentation/widgets/auth_text_field.dart';

class RegisterScreen extends ConsumerStatefulWidget {
  const RegisterScreen({super.key});

  @override
  ConsumerState<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends ConsumerState<RegisterScreen> {
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _pwController = TextEditingController();
  final _confirmPwController = TextEditingController();

  final _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _pwController.dispose();
    _confirmPwController.dispose();
    super.dispose();
  }

  void _onRegisterPressed() {
    if (_formKey.currentState!.validate()) {
      ref
          .read(registerControllerProvider.notifier)
          .register(
            name: _nameController.text,
            email: _emailController.text.trim(),
            password: _pwController.text,
            passwordConfirmation: _confirmPwController.text,
          );
    }
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(registerControllerProvider);

    // Success ya error hone pe react karo (one-time actions — navigation, snackbar)
    ref.listen(registerControllerProvider, (previous, next) {
      next.whenOrNull(
        data: (response) {
          if (response != null) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text("Registered successfully!")),
            );
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => const MainShell()),
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
          child: SingleChildScrollView(
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
                    label: "Name",
                    hintText: "Enter your name",
                    controller: _nameController,
                    validator: (value) => Validators.requiredField(value),
                    onChanged: (value) {},
                  ),
                  const SizedBox(height: 16),

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
                  const SizedBox(height: 16),

                  AuthTextField(
                    label: "Confirm Password",
                    hintText: "Re-enter your password",
                    controller: _confirmPwController,
                    obscureText: true,
                    validator: (value) => Validators.confirmPasswordValidator(
                      _pwController.text,
                      value,
                    ),
                    onChanged: (value) {},
                  ),
                  const SizedBox(height: 30),

                  AuthButton(
                    text: isLoading ? "Registering..." : "Register",
                    onPressed: isLoading ? () {} : _onRegisterPressed,
                  ),
                  const SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "Already have an account?",
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                      TextButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => LoginScreen(),
                            ),
                          );
                        },
                        child: const Text("Login"),
                      ),
                    ],
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
