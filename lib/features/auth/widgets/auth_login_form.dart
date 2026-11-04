import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shopping_app_task/features/auth/controller/auth_cubit/auth_cubit.dart';

class AuthLoginForm extends StatefulWidget {
  const AuthLoginForm({super.key});

  @override
  State<AuthLoginForm> createState() => AuthLoginFormState();
}

class AuthLoginFormState extends State<AuthLoginForm> {
  final form = GlobalKey<FormState>();
  final usernameController = TextEditingController();
  final passwordController = TextEditingController();
  final isPasswordHidden = ValueNotifier(true);

  @override
  void dispose() {
    usernameController.dispose();
    passwordController.dispose();
    isPasswordHidden.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => BlocConsumer<AuthCubit, AuthState>(
    listenWhen: (previous, current) => current is AuthError,
    listener: (context, state) {
      final message = context.read<AuthCubit>().error;
      if (message == null) return;
      ScaffoldMessenger.of(context)
        ..hideCurrentSnackBar()
        ..showSnackBar(SnackBar(content: Text(message)));
    },
    builder: (context, state) {
      final auth = context.read<AuthCubit>();
      final loading = auth.status == AuthStatus.loading;
      final theme = Theme.of(context);
      final colors = theme.colorScheme;
      final border = OutlineInputBorder(
        borderRadius: BorderRadius.circular(16.r),
        borderSide: BorderSide(color: colors.outlineVariant),
      );
      return AutofillGroup(
        child: Form(
          key: form,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Icon(
                Icons.shopping_bag_outlined,
                size: 48.r,
                color: colors.primary,
              ),
              SizedBox(height: 20.h),
              Text(
                'Welcome to Maher Store',
                textAlign: TextAlign.center,
                style: theme.textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.w700,
                ),
              ),
              SizedBox(height: 8.h),
              Text(
                'Sign in to continue shopping.',
                textAlign: TextAlign.center,
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: colors.onSurfaceVariant,
                ),
              ),
              SizedBox(height: 28.h),
              TextFormField(
                controller: usernameController,
                enabled: !loading,
                autocorrect: false,
                decoration: InputDecoration(
                  labelText: 'Username',
                  prefixIcon: const Icon(Icons.person_outline_rounded),
                  filled: true,
                  fillColor: colors.surfaceContainerLowest,
                  border: border,
                  enabledBorder: border,
                ),
                textInputAction: TextInputAction.next,
                autofillHints: const [AutofillHints.username],
                validator: (value) => value == null || value.trim().isEmpty
                    ? 'Username is required'
                    : null,
              ),
              SizedBox(height: 18.h),
              ValueListenableBuilder<bool>(
                valueListenable: isPasswordHidden,
                builder: (context, hidden, child) => TextFormField(
                  controller: passwordController,
                  enabled: !loading,
                  obscureText: hidden,
                  autocorrect: false,
                  enableSuggestions: false,
                  decoration: InputDecoration(
                    labelText: 'Password',
                    prefixIcon: const Icon(Icons.lock_outline_rounded),
                    filled: true,
                    fillColor: colors.surfaceContainerLowest,
                    border: border,
                    enabledBorder: border,
                    suffixIcon: IconButton(
                      tooltip: hidden ? 'Show password' : 'Hide password',
                      onPressed: loading
                          ? null
                          : () => isPasswordHidden.value = !hidden,
                      icon: Icon(
                        hidden ? Icons.visibility : Icons.visibility_off,
                      ),
                    ),
                  ),
                  autofillHints: const [AutofillHints.password],
                  textInputAction: TextInputAction.done,
                  onFieldSubmitted: (_) {
                    final auth = context.read<AuthCubit>();
                    if (auth.status == AuthStatus.loading ||
                        !form.currentState!.validate()) {
                      return;
                    }
                    FocusScope.of(context).unfocus();
                    auth.signIn(
                      usernameController.text,
                      passwordController.text,
                    );
                  },
                  validator: (value) => value == null || value.isEmpty
                      ? 'Password is required'
                      : null,
                ),
              ),
              SizedBox(height: 24.h),
              FilledButton(
                onPressed: loading
                    ? null
                    : () {
                        final auth = context.read<AuthCubit>();
                        if (auth.status == AuthStatus.loading ||
                            !form.currentState!.validate()) {
                          return;
                        }
                        FocusScope.of(context).unfocus();
                        auth.signIn(
                          usernameController.text,
                          passwordController.text,
                        );
                      },
                style: FilledButton.styleFrom(
                  padding: EdgeInsets.symmetric(
                    horizontal: 20.w,
                    vertical: 18.h,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16.r),
                  ),
                ),
                child: loading
                    ? SizedBox.square(
                        dimension: 22.r,
                        child: const CircularProgressIndicator(
                          strokeWidth: 2,
                          semanticsLabel: 'Signing in',
                        ),
                      )
                    : Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Flexible(child: Text('Sign in')),
                          SizedBox(width: 10.w),
                          Icon(Icons.arrow_forward_rounded, size: 20.r),
                        ],
                      ),
              ),
            ],
          ),
        ),
      );
    },
  );
}
