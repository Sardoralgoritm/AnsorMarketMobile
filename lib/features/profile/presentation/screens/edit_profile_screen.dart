import 'package:ansor_market_mobile/core/theme/app_colors.dart';
import 'package:ansor_market_mobile/core/theme/app_dimensions.dart';
import 'package:ansor_market_mobile/core/utils/validators.dart';
import 'package:ansor_market_mobile/features/profile/presentation/providers/profile_provider.dart';
import 'package:ansor_market_mobile/shared/extensions/context_ext.dart';
import 'package:ansor_market_mobile/shared/extensions/string_ext.dart';
import 'package:ansor_market_mobile/shared/widgets/app_button.dart';
import 'package:ansor_market_mobile/shared/widgets/app_text_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class EditProfileScreen extends ConsumerStatefulWidget {
  const EditProfileScreen({super.key});

  @override
  ConsumerState<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends ConsumerState<EditProfileScreen> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _nameCtrl;
  late final TextEditingController _emailCtrl;
  bool _isLoading = false;
  bool _hasChanges = false;

  Color _avatarColor(String name) {
    final hash = name.codeUnits.fold(0, (a, b) => a + b);
    final colors = [
      const Color(0xFF1A7F5A),
      const Color(0xFF2196F3),
      const Color(0xFF9C27B0),
      const Color(0xFFFF5722),
      const Color(0xFF607D8B),
    ];
    return colors[hash % colors.length];
  }

  @override
  void initState() {
    super.initState();
    final profile = ref.read(profileNotifierProvider).valueOrNull;
    _nameCtrl = TextEditingController(text: profile?.fullName ?? '');
    _emailCtrl = TextEditingController(text: profile?.email ?? '');
    _nameCtrl.addListener(_checkChanges);
    _emailCtrl.addListener(_checkChanges);
  }

  void _checkChanges() {
    final profile = ref.read(profileNotifierProvider).valueOrNull;
    if (profile == null) return;
    final changed = _nameCtrl.text.trim() != profile.fullName ||
        _emailCtrl.text.trim() != (profile.email ?? '');
    if (changed != _hasChanges) setState(() => _hasChanges = changed);
  }

  @override
  void dispose() {
    _nameCtrl.dispose();
    _emailCtrl.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    if (!(_formKey.currentState?.validate() ?? false)) return;
    if (!_hasChanges) return;
    setState(() => _isLoading = true);
    try {
      await ref.read(profileNotifierProvider.notifier).updateProfile(
            _nameCtrl.text.trim(),
            _emailCtrl.text.trim().isEmpty ? null : _emailCtrl.text.trim(),
          );
      if (!mounted) return;
      HapticFeedback.lightImpact();
      context.showSnackBar('Profile updated', isSuccess: true);
      context.pop();
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
    final profile = ref.watch(profileNotifierProvider).valueOrNull;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Profile'),
        actions: [
          IconButton(
            icon: const Icon(Icons.check_rounded),
            onPressed: _hasChanges ? _save : null,
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppDimensions.paddingL),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              CircleAvatar(
                radius: 40,
                backgroundColor:
                    _avatarColor(_nameCtrl.text.isNotEmpty ? _nameCtrl.text : 'User'),
                child: Text(
                  (_nameCtrl.text.isNotEmpty ? _nameCtrl.text : 'U').initials,
                  style: const TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.w700,
                    color: Colors.white,
                  ),
                ),
              ),
              const SizedBox(height: AppDimensions.paddingL),
              AppTextField(
                controller: _nameCtrl,
                label: 'Full Name',
                autofocus: true,
                textInputAction: TextInputAction.next,
                prefixIcon: const Icon(Icons.person_outlined),
                validator: Validators.fullName,
              ),
              const SizedBox(height: AppDimensions.paddingM),
              AppTextField(
                controller: _emailCtrl,
                label: 'Email (optional)',
                hint: 'your@email.com',
                keyboardType: TextInputType.emailAddress,
                textInputAction: TextInputAction.done,
                prefixIcon: const Icon(Icons.email_outlined),
                validator: Validators.email,
                onSubmitted: (_) => _save(),
              ),
              const SizedBox(height: AppDimensions.paddingM),
              if (profile != null)
                AppTextField(
                  controller: TextEditingController(text: profile.phone),
                  label: 'Phone Number',
                  readOnly: true,
                  prefixIcon: const Icon(Icons.phone_outlined),
                ),
              if (profile != null)
                Padding(
                  padding:
                      const EdgeInsets.only(top: AppDimensions.paddingXS),
                  child: Text(
                    'Phone number cannot be changed',
                    style: Theme.of(context)
                        .textTheme
                        .labelSmall
                        ?.copyWith(color: AppColors.textSecondary),
                  ),
                ),
              const SizedBox(height: AppDimensions.paddingXL),
              AppButton(
                label: 'Save Changes',
                onPressed: _hasChanges ? _save : null,
                isLoading: _isLoading,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
