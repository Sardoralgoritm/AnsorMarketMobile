import 'package:ansor_market_mobile/core/network/dio_client.dart';
import 'package:ansor_market_mobile/core/router/route_names.dart';
import 'package:ansor_market_mobile/features/auth/presentation/providers/auth_provider.dart';
import 'package:ansor_market_mobile/features/auth/presentation/screens/login_screen.dart';
import 'package:ansor_market_mobile/features/auth/presentation/screens/register_screen.dart';
import 'package:ansor_market_mobile/features/auth/presentation/screens/splash_screen.dart';
import 'package:ansor_market_mobile/features/branches/presentation/screens/branches_screen.dart';
import 'package:ansor_market_mobile/features/cart/presentation/screens/cart_screen.dart';
import 'package:ansor_market_mobile/features/catalog/presentation/screens/category_tree_screen.dart';
import 'package:ansor_market_mobile/features/catalog/presentation/screens/product_detail_screen.dart';
import 'package:ansor_market_mobile/features/home/presentation/screens/home_screen.dart';
import 'package:ansor_market_mobile/features/profile/presentation/screens/change_password_screen.dart';
import 'package:ansor_market_mobile/features/profile/presentation/screens/edit_profile_screen.dart';
import 'package:ansor_market_mobile/features/profile/presentation/screens/profile_screen.dart';
import 'package:ansor_market_mobile/shared/widgets/bottom_nav_bar.dart';
import 'package:ansor_market_mobile/shared/widgets/offline_banner.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'app_router.g.dart';

final _shellNavigatorKey = GlobalKey<NavigatorState>();

@riverpod
GoRouter appRouter(Ref ref) {
  final authState = ref.watch(authNotifierProvider);
  final isUnauthenticated = ref.watch(unauthenticatedProvider);

  // When token interceptor signals unauth, clear user
  if (isUnauthenticated && authState != null) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(authNotifierProvider.notifier).clearUser();
      ref.read(unauthenticatedProvider.notifier).state = false;
    });
  }

  return GoRouter(
    initialLocation: RouteNames.splash,
    redirect: (context, state) {
      final isLoggedIn = authState != null;
      final loc = state.matchedLocation;
      final isAuthRoute =
          loc.startsWith('/login') || loc.startsWith('/register');
      final isSplash = loc == '/';

      if (isSplash) return null;
      // TODO: remove bypass before production
      if (!isLoggedIn && !isAuthRoute) return RouteNames.home;
      if (isLoggedIn && isAuthRoute) return RouteNames.home;
      return null;
    },
    routes: [
      GoRoute(
        path: RouteNames.splash,
        pageBuilder: (_, state) => _fadePage(state, const SplashScreen()),
      ),
      GoRoute(
        path: RouteNames.login,
        pageBuilder: (_, state) => _fadePage(state, const LoginScreen()),
      ),
      GoRoute(
        path: RouteNames.register,
        pageBuilder: (_, state) =>
            _slideUpPage(state, const RegisterScreen()),
      ),
      GoRoute(
        path: RouteNames.productDetail,
        pageBuilder: (_, state) => _fadePage(
          state,
          ProductDetailScreen(productId: state.pathParameters['id']!),
        ),
      ),
      GoRoute(
        path: RouteNames.editProfile,
        pageBuilder: (_, state) =>
            _slidePage(state, const EditProfileScreen()),
      ),
      GoRoute(
        path: RouteNames.changePassword,
        pageBuilder: (_, state) =>
            _slidePage(state, const ChangePasswordScreen()),
      ),
      ShellRoute(
        navigatorKey: _shellNavigatorKey,
        builder: (context, state, child) => _ShellScaffold(child: child),
        routes: [
          GoRoute(
            path: RouteNames.home,
            pageBuilder: (_, state) =>
                _fadePage(state, const HomeScreen()),
          ),
          GoRoute(
            path: RouteNames.categories,
            pageBuilder: (_, state) =>
                _fadePage(state, const CategoryTreeScreen()),
          ),
          GoRoute(
            path: RouteNames.cart,
            pageBuilder: (_, state) =>
                _fadePage(state, const CartScreen()),
          ),
          GoRoute(
            path: RouteNames.branches,
            pageBuilder: (_, state) =>
                _fadePage(state, const BranchesScreen()),
          ),
          GoRoute(
            path: RouteNames.profile,
            pageBuilder: (_, state) =>
                _fadePage(state, const ProfileScreen()),
          ),
        ],
      ),
    ],
  );
}

CustomTransitionPage<void> _fadePage(GoRouterState state, Widget child) {
  return CustomTransitionPage<void>(
    key: state.pageKey,
    child: child,
    transitionDuration: const Duration(milliseconds: 250),
    transitionsBuilder: (_, animation, __, child) =>
        FadeTransition(opacity: animation, child: child),
  );
}

CustomTransitionPage<void> _slidePage(GoRouterState state, Widget child) {
  return CustomTransitionPage<void>(
    key: state.pageKey,
    child: child,
    transitionDuration: const Duration(milliseconds: 250),
    transitionsBuilder: (_, animation, __, child) => SlideTransition(
      position: Tween<Offset>(
        begin: const Offset(1, 0),
        end: Offset.zero,
      ).animate(CurvedAnimation(parent: animation, curve: Curves.easeOut)),
      child: child,
    ),
  );
}

CustomTransitionPage<void> _slideUpPage(GoRouterState state, Widget child) {
  return CustomTransitionPage<void>(
    key: state.pageKey,
    child: child,
    transitionDuration: const Duration(milliseconds: 300),
    transitionsBuilder: (_, animation, __, child) => SlideTransition(
      position: Tween<Offset>(
        begin: const Offset(0, 1),
        end: Offset.zero,
      ).animate(CurvedAnimation(parent: animation, curve: Curves.easeOut)),
      child: child,
    ),
  );
}

class _ShellScaffold extends ConsumerStatefulWidget {
  const _ShellScaffold({required this.child});
  final Widget child;

  @override
  ConsumerState<_ShellScaffold> createState() => _ShellScaffoldState();
}

class _ShellScaffoldState extends ConsumerState<_ShellScaffold> {
  int _currentIndex = 0;

  static const _routes = [
    RouteNames.home,
    RouteNames.categories,
    RouteNames.cart,
    RouteNames.branches,
    RouteNames.profile,
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: OfflineBanner(child: widget.child),
      bottomNavigationBar: AppBottomNavBar(
        currentIndex: _currentIndex,
        onTap: (i) {
          setState(() => _currentIndex = i);
          context.go(_routes[i]);
        },
      ),
    );
  }
}
