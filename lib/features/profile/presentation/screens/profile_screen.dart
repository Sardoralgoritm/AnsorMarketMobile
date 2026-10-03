import 'package:ansor_market_mobile/core/router/route_names.dart';
import 'package:ansor_market_mobile/core/theme/app_colors.dart';
import 'package:ansor_market_mobile/core/theme/app_dimensions.dart';
import 'package:ansor_market_mobile/features/auth/presentation/providers/auth_provider.dart';
import 'package:ansor_market_mobile/features/profile/presentation/providers/profile_provider.dart';
import 'package:ansor_market_mobile/shared/extensions/string_ext.dart';
import 'package:ansor_market_mobile/shared/widgets/error_view.dart';
import 'package:ansor_market_mobile/shared/widgets/shimmer_box.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class ProfileScreen extends ConsumerStatefulWidget {
  const ProfileScreen({super.key});

  @override
  ConsumerState<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends ConsumerState<ProfileScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(profileNotifierProvider.notifier).loadProfile();
    });
  }

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
  Widget build(BuildContext context) {
    final profileAsync = ref.watch(profileNotifierProvider);

    return Scaffold(
      body: RefreshIndicator(
        onRefresh: () async =>
            ref.read(profileNotifierProvider.notifier).loadProfile(),
        child: profileAsync.when(
          data: (profile) => CustomScrollView(
            slivers: [
              SliverToBoxAdapter(
                child: Container(
                  padding: EdgeInsets.only(
                    top: MediaQuery.of(context).padding.top +
                        AppDimensions.paddingL,
                    bottom: AppDimensions.paddingL,
                    left: AppDimensions.paddingL,
                    right: AppDimensions.paddingL,
                  ),
                  color: AppColors.primary,
                  child: Column(
                    children: [
                      CircleAvatar(
                        radius: 40,
                        backgroundColor: _avatarColor(profile.fullName),
                        child: Text(
                          profile.fullName.initials,
                          style: const TextStyle(
                            fontSize: 28,
                            fontWeight: FontWeight.w700,
                            color: Colors.white,
                          ),
                        ),
                      )
                          .animate()
                          .fadeIn(duration: 400.ms)
                          .scale(begin: const Offset(0.7, 0.7)),
                      const SizedBox(height: AppDimensions.paddingS),
                      Text(
                        profile.fullName,
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w700,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        profile.phone,
                        style: const TextStyle(
                            color: Colors.white70, fontSize: 14),
                      ),
                      if (profile.email != null)
                        Text(
                          profile.email!,
                          style: const TextStyle(
                              color: Colors.white70, fontSize: 13),
                        ),
                    ],
                  ),
                ),
              ),
              SliverList(
                delegate: SliverChildListDelegate([
                  _Section(
                    title: 'Account',
                    tiles: [
                      _Tile(
                        icon: Icons.person_outline_rounded,
                        label: 'Edit Profile',
                        onTap: () => context.push(RouteNames.editProfile),
                        delay: 0,
                      ),
                      _Tile(
                        icon: Icons.lock_outline_rounded,
                        label: 'Change Password',
                        onTap: () =>
                            context.push(RouteNames.changePassword),
                        delay: 40,
                      ),
                      _Tile(
                        icon: Icons.receipt_long_outlined,
                        label: 'My Orders',
                        onTap: () {},
                        trailing: const Text('Coming soon',
                            style: TextStyle(
                                color: AppColors.textSecondary,
                                fontSize: 12)),
                        delay: 80,
                      ),
                    ],
                  ),
                  _Section(
                    title: 'Other',
                    tiles: [
                      _Tile(
                        icon: Icons.store_outlined,
                        label: 'Nearby Branches',
                        onTap: () => context.go(RouteNames.branches),
                        delay: 120,
                      ),
                      _Tile(
                        icon: Icons.language_outlined,
                        label: 'Language',
                        onTap: () {},
                        delay: 160,
                      ),
                      const _AppVersionTile(delay: 200),
                    ],
                  ),
                  Padding(
                    padding: const EdgeInsets.all(AppDimensions.paddingL),
                    child: TextButton(
                      onPressed: () => _confirmLogout(context),
                      child: const Text(
                        'Log Out',
                        style: TextStyle(color: AppColors.error),
                      ),
                    ),
                  ).animate().fadeIn(duration: 300.ms, delay: 240.ms),
                  SizedBox(
                      height: MediaQuery.of(context).padding.bottom),
                ]),
              ),
            ],
          ),
          loading: () => _ProfileSkeleton(),
          error: (e, _) => ErrorView(
            message: e.toString(),
            onRetry: () =>
                ref.read(profileNotifierProvider.notifier).loadProfile(),
          ),
        ),
      ),
    );
  }

  void _confirmLogout(BuildContext context) {
    showDialog<void>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Log Out'),
        content: const Text('Are you sure you want to log out?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () async {
              Navigator.of(ctx).pop();
              await ref.read(authNotifierProvider.notifier).logout();
              if (context.mounted) context.go(RouteNames.login);
            },
            child: const Text('Log Out',
                style: TextStyle(color: AppColors.error)),
          ),
        ],
      ),
    );
  }
}

class _Section extends StatelessWidget {
  const _Section({required this.title, required this.tiles});
  final String title;
  final List<Widget> tiles;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(
            AppDimensions.paddingM,
            AppDimensions.paddingM,
            AppDimensions.paddingM,
            AppDimensions.paddingXS,
          ),
          child: Text(
            title,
            style: Theme.of(context).textTheme.labelSmall?.copyWith(
                  color: AppColors.textSecondary,
                  fontWeight: FontWeight.w600,
                  letterSpacing: 1,
                ),
          ),
        ),
        ...tiles,
      ],
    );
  }
}

class _Tile extends StatelessWidget {
  const _Tile({
    required this.icon,
    required this.label,
    required this.onTap,
    required this.delay,
    this.trailing,
  });
  final IconData icon;
  final String label;
  final VoidCallback onTap;
  final int delay;
  final Widget? trailing;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(icon, color: AppColors.primary),
      title: Text(label),
      trailing: trailing ??
          const Icon(Icons.chevron_right_rounded,
              color: AppColors.textSecondary),
      onTap: onTap,
    ).animate().fadeIn(duration: 300.ms, delay: Duration(milliseconds: delay)).slideX(begin: 0.05);
  }
}

class _AppVersionTile extends StatefulWidget {
  const _AppVersionTile({required this.delay});
  final int delay;

  @override
  State<_AppVersionTile> createState() => _AppVersionTileState();
}

class _AppVersionTileState extends State<_AppVersionTile> {
  @override
  Widget build(BuildContext context) {
    return const ListTile(
      leading: Icon(Icons.info_outline_rounded, color: AppColors.primary),
      title: Text('App Version'),
      trailing: Text(
        'v1.0.0',
        style: TextStyle(color: AppColors.textSecondary),
      ),
    )
        .animate()
        .fadeIn(
            duration: 300.ms,
            delay: Duration(milliseconds: widget.delay))
        .slideX(begin: 0.05);
  }
}

class _ProfileSkeleton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          height: 180,
          color: AppColors.primary.withAlpha(60),
        ),
        const Padding(
          padding: EdgeInsets.all(AppDimensions.paddingM),
          child: Column(
            children: [
              ShimmerBox(width: double.infinity, height: 52),
              SizedBox(height: AppDimensions.paddingS),
              ShimmerBox(width: double.infinity, height: 52),
              SizedBox(height: AppDimensions.paddingS),
              ShimmerBox(width: double.infinity, height: 52),
            ],
          ),
        ),
      ],
    );
  }
}
