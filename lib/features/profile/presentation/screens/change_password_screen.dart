import 'package:ansor_market_mobile/core/theme/app_colors.dart';
import 'package:ansor_market_mobile/core/theme/app_dimensions.dart';
import 'package:ansor_market_mobile/core/utils/validators.dart';
import 'package:ansor_market_mobile/features/profile/presentation/providers/profile_provider.dart';
import 'package:ansor_market_mobile/shared/extensions/context_ext.dart';
import 'package:ansor_market_mobile/shared/widgets/app_button.dart';
import 'package:ansor_market_mobile/shared/widgets/app_text_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class ChangePasswordScreen extends ConsumerStatefulWidget {
  const ChangePasswordScreen({super.key});

  @override
  ConsumerState<ChangePasswordScreen> createState() =>
      _ChangePasswordScreenState();
}

class _ChangePasswordScreenState extends ConsumerState<ChangePasswordScreen> {
  final _formKey = GlobalKey<FormState>();
  final _currentCtrl = TextEditingController();
  final _newCtrl = TextEditingController();
  final _confirmCtrl = TextEditingController();
  bool _obscureCurrent = true;
  bool _obscureNew = true;
  bool _obscureConfirm = true;
  bool _isLoading = false;

  double _strength = 0;

  @override
  void initState() {
    super.initState();
    _newCtrl.addListener(_updateStrength);
  }

  void _updateStrength() {
    final v = _newCtrl.text;
    double s = 0;
    if (v.length >= 8) s += 0.4;
    if (v.contains(RegExp(r'\d'))) s += 0.2;
    if (v.contains(RegExp(r'[A-Z]'))) s += 0.2;
    if (v.contains(RegExp(r'[^a-zA-Z0-9]'))) s += 0.2;
    setState(() => _strength = s);
  }

  @override
  void dispose() {
    _currentCtrl.dispose();
    _newCtrl.dispose();
    _confirmCtrl.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!(_formKey.currentState?.validate() ?? false)) return;
    setState(() => _isLoading = true);
    try {
      await ref.read(profileNotifierProvider.notifier).changePassword(
            _currentCtrl.text,
            _newCtrl.text,
          );
      if (!mounted) return;
      HapticFeedback.lightImpact();
      context.showSnackBar('Password changed successfully', isSuccess: true);
      context.pop();
    } catch (e) {
      if (!mounted) return;
      HapticFeedback.vibrate();
      context.showSnackBar(e.toString(), isError: true);
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  Color get _strengthColor {
    if (_strength < 0.4) return AppColors.error;
    if (_strength < 0.7) return Colors.orange;
    return AppColors.success;
  }

  String get _strengthLabel {
    if (_strength < 0.4) return 'Weak';
    if (_strength < 0.7) return 'Medium';
    return 'Strong';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Change Password')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppDimensions.paddingL),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              AppTextField(
                controller: _currentCtrl,
                label: 'Current Password',
                obscureText: _obscureCurrent,
                keyboardType: TextInputType.visiblePassword,
                textInputAction: TextInputAction.next,
                validator: (v) => Validators.required(v, 'Current password'),
                suffixIcon: IconButton(
                  icon: Icon(_obscureCurrent
                      ? Icons.visibility_outlined
                      : Icons.visibility_off_outlined),
                  onPressed: () =>
                      setState(() => _obscureCurrent = !_obscureCurrent),
                ),
              ),
              const SizedBox(height: AppDimensions.paddingM),
              AppTextField(
                controller: _newCtrl,
                label: 'New Password',
                obscureText: _obscureNew,
                keyboardType: TextInputType.visiblePassword,
                textInputAction: TextInputAction.next,
                validator: Validators.strongPassword,
                suffixIcon: IconButton(
                  icon: Icon(_obscureNew
                      ? Icons.visibility_outlined
                      : Icons.visibility_off_outlined),
                  onPressed: () =>
                      setState(() => _obscureNew = !_obscureNew),
                ),
              ),
              const SizedBox(height: AppDimensions.paddingS),
              // Strength bar
              if (_newCtrl.text.isNotEmpty) ...[
                Row(
                  children: [
                    Expanded(
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 300),
                        height: 4,
                        decoration: BoxDecoration(
                          color: AppColors.cardBorder,
                          borderRadius: BorderRadius.circular(2),
                        ),
                        child: FractionallySizedBox(
                          alignment: Alignment.centerLeft,
                          widthFactor: _strength,
                          child: Container(
                            decoration: BoxDecoration(
                              color: _strengthColor,
                              borderRadius: BorderRadius.circular(2),
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: AppDimensions.paddingS),
                    Text(
                      _strengthLabel,
                      style: TextStyle(
                        color: _strengthColor,
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: AppDimensions.paddingS),
              ],
              AppTextField(
                controller: _confirmCtrl,
                label: 'Confirm New Password',
                obscureText: _obscureConfirm,
                keyboardType: TextInputType.visiblePassword,
                textInputAction: TextInputAction.done,
                onSubmitted: (_) => _submit(),
                validator: (v) =>
                    Validators.confirmPassword(v, _newCtrl.text),
                suffixIcon: IconButton(
                  icon: Icon(_obscureConfirm
                      ? Icons.visibility_outlined
                      : Icons.visibility_off_outlined),
                  onPressed: () =>
                      setState(() => _obscureConfirm = !_obscureConfirm),
                ),
              ),
              const SizedBox(height: AppDimensions.paddingXL),
              AppButton(
                label: 'Update Password',
                onPressed: _submit,
                isLoading: _isLoading,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
