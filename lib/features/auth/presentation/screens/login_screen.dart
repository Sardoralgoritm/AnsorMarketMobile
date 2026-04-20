import 'package:ansor_market_mobile/app.dart';
import 'package:ansor_market_mobile/core/theme/app_colors.dart';
import 'package:ansor_market_mobile/core/theme/app_dimensions.dart';
import 'package:ansor_market_mobile/core/utils/validators.dart';
import 'package:ansor_market_mobile/features/auth/presentation/providers/auth_provider.dart';
import 'package:ansor_market_mobile/features/auth/presentation/screens/register_screen.dart';
import 'package:ansor_market_mobile/shared/extensions/context_ext.dart';
import 'package:ansor_market_mobile/shared/widgets/app_button.dart';
import 'package:ansor_market_mobile/shared/widgets/app_text_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key});

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _phoneCtrl = TextEditingController();
  final _passwordCtrl = TextEditingController();
  bool _obscurePassword = true;
  bool _isLoading = false;

  @override
  void dispose() {
    _phoneCtrl.dispose();
    _passwordCtrl.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!(_formKey.currentState?.validate() ?? false)) return;
    setState(() => _isLoading = true);
    try {
      await ref
          .read(authNotifierProvider.notifier)
          .login(_phoneCtrl.text.trim(), _passwordCtrl.text);
      if (!mounted) return;
      HapticFeedback.lightImpact();
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (_) => const MainScreen()),
      );
    } catch (e) {
      if (!mounted) return;
      HapticFeedback.vibrate();
      context.showSnackBar(e.toString(), isError: true);
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  void _goToRegister() {
    Navigator.of(context).push(
      MaterialPageRoute(builder: (_) => const RegisterScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(AppDimensions.paddingL),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const SizedBox(height: AppDimensions.paddingXL),
                Center(
                  child: Container(
                    width: 72,
                    height: 72,
                    decoration: BoxDecoration(
                      color: AppColors.primary,
                      borderRadius: BorderRadius.circular(18),
                    ),
                    child: const Center(
                      child: Text(
                        'AM',
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.w800,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ).animate().fadeIn(duration: 400.ms).scale(begin: const Offset(0.8, 0.8)),
                const SizedBox(height: AppDimensions.paddingL),
                Text(
                  'Welcome back',
                  style: context.textTheme.displayLarge,
                  textAlign: TextAlign.center,
                ).animate().fadeIn(duration: 400.ms, delay: 80.ms).slideY(begin: 0.2),
                const SizedBox(height: AppDimensions.paddingS),
                Text(
                  'Sign in to continue',
                  style: context.textTheme.bodyMedium
                      ?.copyWith(color: AppColors.textSecondary),
                  textAlign: TextAlign.center,
                ).animate().fadeIn(duration: 400.ms, delay: 120.ms).slideY(begin: 0.2),
                const SizedBox(height: AppDimensions.paddingXL),
                AppTextField(
                  controller: _phoneCtrl,
                  label: 'Phone Number',
                  hint: '+998 XX XXX XX XX',
                  keyboardType: TextInputType.phone,
                  textInputAction: TextInputAction.next,
                  autofocus: true,
                  prefixIcon: const Icon(Icons.phone_outlined),
                  validator: Validators.phone,
                ).animate().fadeIn(duration: 400.ms, delay: 160.ms).slideY(begin: 0.2),
                const SizedBox(height: AppDimensions.paddingM),
                AppTextField(
                  controller: _passwordCtrl,
                  label: 'Password',
                  hint: '••••••',
                  obscureText: _obscurePassword,
                  keyboardType: TextInputType.visiblePassword,
                  textInputAction: TextInputAction.done,
                  onSubmitted: (_) => _submit(),
                  validator: (v) => Validators.password(v),
                  suffixIcon: IconButton(
                    icon: Icon(
                      _obscurePassword
                          ? Icons.visibility_outlined
                          : Icons.visibility_off_outlined,
                    ),
                    onPressed: () =>
                        setState(() => _obscurePassword = !_obscurePassword),
                  ),
                ).animate().fadeIn(duration: 400.ms, delay: 200.ms).slideY(begin: 0.2),
                const SizedBox(height: AppDimensions.paddingS),
                Align(
                  alignment: Alignment.centerRight,
                  child: TextButton(
                    onPressed: () {},
                    child: const Text('Forgot password?'),
                  ),
                ).animate().fadeIn(duration: 400.ms, delay: 240.ms),
                const SizedBox(height: AppDimensions.paddingM),
                AppButton(
                  label: 'Sign In',
                  onPressed: _submit,
                  isLoading: _isLoading,
                ).animate().fadeIn(duration: 400.ms, delay: 280.ms).slideY(begin: 0.2),
                const SizedBox(height: AppDimensions.paddingL),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "Don't have an account?",
                      style: context.textTheme.bodyMedium,
                    ),
                    TextButton(
                      onPressed: _goToRegister,
                      child: const Text('Register'),
                    ),
                  ],
                ).animate().fadeIn(duration: 400.ms, delay: 320.ms),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
