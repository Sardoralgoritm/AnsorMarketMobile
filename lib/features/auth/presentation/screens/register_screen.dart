import 'package:ansor_market_mobile/app.dart';
import 'package:ansor_market_mobile/core/theme/app_dimensions.dart';
import 'package:ansor_market_mobile/core/utils/validators.dart';
import 'package:ansor_market_mobile/features/auth/presentation/providers/auth_provider.dart';
import 'package:ansor_market_mobile/shared/extensions/context_ext.dart';
import 'package:ansor_market_mobile/shared/widgets/app_button.dart';
import 'package:ansor_market_mobile/shared/widgets/app_text_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class RegisterScreen extends ConsumerStatefulWidget {
  const RegisterScreen({super.key});

  @override
  ConsumerState<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends ConsumerState<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameCtrl = TextEditingController();
  final _phoneCtrl = TextEditingController();
  final _passwordCtrl = TextEditingController();
  final _confirmCtrl = TextEditingController();
  bool _obscurePassword = true;
  bool _obscureConfirm = true;
  bool _agreedToTerms = false;
  bool _isLoading = false;

  @override
  void dispose() {
    _nameCtrl.dispose();
    _phoneCtrl.dispose();
    _passwordCtrl.dispose();
    _confirmCtrl.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!(_formKey.currentState?.validate() ?? false)) return;
    if (!_agreedToTerms) {
      context.showSnackBar('Please accept the Terms of Service', isError: true);
      return;
    }
    setState(() => _isLoading = true);
    try {
      await ref.read(authNotifierProvider.notifier).register(
            _nameCtrl.text.trim(),
            _phoneCtrl.text.trim(),
            _passwordCtrl.text,
          );
      if (!mounted) return;
      HapticFeedback.lightImpact();
      Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (_) => const MainScreen()),
        (_) => false,
      );
    } catch (e) {
      if (!mounted) return;
      HapticFeedback.vibrate();
      context.showSnackBar(e.toString(), isError: true);
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Create Account')),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(AppDimensions.paddingL),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                AppTextField(
                  controller: _nameCtrl,
                  label: 'Full Name',
                  hint: 'Your full name',
                  keyboardType: TextInputType.name,
                  textInputAction: TextInputAction.next,
                  autofocus: true,
                  prefixIcon: const Icon(Icons.person_outlined),
                  validator: Validators.fullName,
                ).animate().fadeIn(duration: 400.ms, delay: 50.ms).slideY(begin: 0.2),
                const SizedBox(height: AppDimensions.paddingM),
                AppTextField(
                  controller: _phoneCtrl,
                  label: 'Phone Number',
                  hint: '+998 XX XXX XX XX',
                  keyboardType: TextInputType.phone,
                  textInputAction: TextInputAction.next,
                  prefixIcon: const Icon(Icons.phone_outlined),
                  validator: Validators.phone,
                ).animate().fadeIn(duration: 400.ms, delay: 100.ms).slideY(begin: 0.2),
                const SizedBox(height: AppDimensions.paddingM),
                AppTextField(
                  controller: _passwordCtrl,
                  label: 'Password',
                  hint: '••••••',
                  obscureText: _obscurePassword,
                  keyboardType: TextInputType.visiblePassword,
                  textInputAction: TextInputAction.next,
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
                ).animate().fadeIn(duration: 400.ms, delay: 150.ms).slideY(begin: 0.2),
                const SizedBox(height: AppDimensions.paddingM),
                AppTextField(
                  controller: _confirmCtrl,
                  label: 'Confirm Password',
                  hint: '••••••',
                  obscureText: _obscureConfirm,
                  keyboardType: TextInputType.visiblePassword,
                  textInputAction: TextInputAction.done,
                  onSubmitted: (_) => _submit(),
                  validator: (v) =>
                      Validators.confirmPassword(v, _passwordCtrl.text),
                  suffixIcon: IconButton(
                    icon: Icon(
                      _obscureConfirm
                          ? Icons.visibility_outlined
                          : Icons.visibility_off_outlined,
                    ),
                    onPressed: () =>
                        setState(() => _obscureConfirm = !_obscureConfirm),
                  ),
                ).animate().fadeIn(duration: 400.ms, delay: 200.ms).slideY(begin: 0.2),
                const SizedBox(height: AppDimensions.paddingM),
                Row(
                  children: [
                    Checkbox(
                      value: _agreedToTerms,
                      onChanged: (v) =>
                          setState(() => _agreedToTerms = v ?? false),
                    ),
                    Expanded(
                      child: Text(
                        'I agree to the Terms of Service',
                        style: context.textTheme.bodyMedium,
                      ),
                    ),
                  ],
                ).animate().fadeIn(duration: 400.ms, delay: 250.ms),
                const SizedBox(height: AppDimensions.paddingL),
                AppButton(
                  label: 'Create Account',
                  onPressed: _submit,
                  isLoading: _isLoading,
                ).animate().fadeIn(duration: 400.ms, delay: 300.ms).slideY(begin: 0.2),
                const SizedBox(height: AppDimensions.paddingL),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Already have an account?',
                      style: context.textTheme.bodyMedium,
                    ),
                    TextButton(
                      onPressed: () => Navigator.of(context).pop(),
                      child: const Text('Sign in'),
                    ),
                  ],
                ).animate().fadeIn(duration: 400.ms, delay: 350.ms),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
