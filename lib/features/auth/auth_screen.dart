import 'package:flutter/material.dart';
import 'package:shopping_app_task/features/auth/widgets/auth_screen_body.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surfaceContainerLowest,
      body: const AuthScreenBody(),
    );
  }
}
