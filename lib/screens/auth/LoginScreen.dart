import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todo_app/cubits/auth/auth_cubit.dart';
import 'package:todo_app/repositories/auth_repository.dart';
import 'package:todo_app/screens/auth/widgets/form_label.dart';
import 'package:todo_app/screens/auth/widgets/auth_input_field.dart';
import 'package:todo_app/screens/auth/widgets/auth_button.dart';
import 'package:todo_app/screens/auth/widgets/auth_header.dart';
import 'package:todo_app/screens/auth/widgets/auth_footer_link.dart';
import 'package:todo_app/screens/auth/widgets/auth_scaffold.dart';
import '../home/HomeScreen.dart';
import 'SignupScreen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  late AuthCubit authCubit;

  @override
  void initState() {
    super.initState();
    authCubit = AuthCubit(repository: AuthRepository());
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    authCubit.close();
    super.dispose();
  }

  void _onLogin() {
    if (!_formKey.currentState!.validate()) return;

    authCubit.login(
      email: _emailController.text.trim(),
      password: _passwordController.text,
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => authCubit,
      child: BlocListener<AuthCubit, AuthState>(
        listener: (context, state) {
          if (state is AuthError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                  content: Text(state.message),
                  backgroundColor: Colors.redAccent),
            );
          } else if (state is AuthLoggedIn) {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (_) => HomeScreen()),
            );
          }
        },
        child: AuthScaffold(
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                AuthHeader(
                  title: 'Welcome back',
                  subtitle: 'Sign in to continue',
                ),
                FormLabel('Email'),
                const SizedBox(height: 8),
                AuthInputField(
                  controller: _emailController,
                  hint: 'Email',
                  icon: Icons.email_outlined,
                  keyboardType: TextInputType.emailAddress,
                  validator: (v) {
                    if (v == null || v.trim().isEmpty)
                      return 'Email is required';
                    if (!v.contains('@')) return 'Enter a valid email';
                    return null;
                  },
                ),
                const SizedBox(height: 20),
                FormLabel('Password'),
                const SizedBox(height: 8),
                AuthInputField(
                  controller: _passwordController,
                  hint: 'Password',
                  icon: Icons.lock_outline,
                  obscure: true,
                  showVisibilityToggle: true,
                  validator: (v) {
                    if (v == null || v.isEmpty) return 'Password is required';
                    if (v.length < 6) return 'At least 6 characters';
                    return null;
                  },
                ),
                const SizedBox(height: 10),
                Align(
                  alignment: Alignment.centerRight,
                  child: TextButton(
                    onPressed: () {
                      // TODO: forgot password
                    },
                    child: const Text(
                      'Forgot password?',
                      style: TextStyle(color: Color(0xFF5A189A)),
                    ),
                  ),
                ),
                const SizedBox(height: 24),
                BlocBuilder<AuthCubit, AuthState>(
                  builder: (context, state) {
                    final isLoading = state is AuthLoading;
                    return AuthButton(
                      label: 'Sign In',
                      isLoading: isLoading,
                      onPressed: _onLogin,
                    );
                  },
                ),
                const SizedBox(height: 32),
                AuthFooterLink(
                  text: "Don't have an account? ",
                  linkText: 'Sign Up',
                  onTap: () => Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (_) => const SignupScreen()),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
