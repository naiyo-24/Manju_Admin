import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../providers/auth_provider.dart';
import '../../themes/app_theme.dart';
import '../../widgets/neumorphic_card.dart';

class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key});

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  bool _isPasswordVisible = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          child: Padding(
            padding: AppTheme.defaultScreenPadding,
            child: NeumorphicCard(
              padding: 32,
              borderRadius: 24,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Image.asset('assets/manju.png', height: 100),
                  const SizedBox(height: 16),
                  Text(
                    'Manju Medical Admin',
                    style: Theme.of(context).textTheme.headlineSmall,
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 32),
                  _buildTextField(context, 'Username', Icons.person),
                  const SizedBox(height: 16),
                  _buildTextField(
                    context, 
                    'Password', 
                    Icons.lock, 
                    obscureText: !_isPasswordVisible,
                    suffixIcon: IconButton(
                      icon: Icon(
                        _isPasswordVisible ? Icons.visibility : Icons.visibility_off,
                        color: AppTheme.textSecondary,
                      ),
                      onPressed: () {
                        setState(() {
                          _isPasswordVisible = !_isPasswordVisible;
                        });
                      },
                    ),
                  ),
                  const SizedBox(height: 32),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      style: AppTheme.primaryButtonStyle,
                      onPressed: () {
                        ref.read(authProvider.notifier).login();
                      },
                      child: const Text('LOGIN'),
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

  Widget _buildTextField(BuildContext context, String hint, IconData icon, {bool obscureText = false, Widget? suffixIcon}) {
    return Container(
      decoration: BoxDecoration(
        color: AppTheme.backgroundColor,
        borderRadius: BorderRadius.circular(16),
        boxShadow: const [
          BoxShadow(color: AppTheme.shadowInsetDark, offset: Offset(2, 2), blurRadius: 4),
          BoxShadow(color: AppTheme.shadowLight, offset: Offset(-2, -2), blurRadius: 4),
        ],
      ),
      child: TextField(
        obscureText: obscureText,
        decoration: InputDecoration(
          prefixIcon: Icon(icon, color: AppTheme.primaryGreen),
          suffixIcon: suffixIcon,
          hintText: hint,
          hintStyle: const TextStyle(color: AppTheme.textHint),
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        ),
      ),
    );
  }
}

