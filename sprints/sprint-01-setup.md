# Sprint 01 — Project Setup & Core Infrastructure

## Goal
Bootstrap the Flutter project with all dependencies, folder structure, theming, routing skeleton, networking layer, and secure storage. By the end of this sprint the app boots, shows a splash screen, and correctly reads stored tokens to decide where to navigate — even though no real auth exists yet.

---

## Tasks

### 1. Flutter Project Creation

```bash
flutter create ansor_market_mobile --org uz.ansormarket --platforms android,ios
cd ansor_market_mobile
```

Remove default counter app code from `main.dart` and `lib/`.

---

### 2. pubspec.yaml Dependencies

```yaml
dependencies:
  flutter:
    sdk: flutter

  # State management
  flutter_riverpod: ^2.5.1
  riverpod_annotation: ^2.3.5

  # Navigation
  go_router: ^14.0.0

  # Networking
  dio: ^5.4.3+1

  # Secure storage
  flutter_secure_storage: ^9.2.2

  # Models
  freezed_annotation: ^2.4.1
  json_annotation: ^4.9.0

  # Local cache
  hive_flutter: ^1.1.0

  # Images
  cached_network_image: ^3.3.1

  # Animations
  flutter_animate: ^4.5.0

  # Shimmer / skeleton loaders
  shimmer: ^3.0.0

  # Map
  flutter_map: ^7.0.2
  latlong2: ^0.9.1

  # Location
  geolocator: ^12.0.0
  permission_handler: ^11.3.1

  # Pull to refresh
  easy_refresh: ^3.4.0

  # Connectivity
  connectivity_plus: ^6.0.5

  # Utils
  intl: ^0.19.0

dev_dependencies:
  flutter_test:
    sdk: flutter
  flutter_lints: ^4.0.0
  build_runner: ^2.4.11
  riverpod_generator: ^2.4.3
  freezed: ^2.5.2
  json_serializable: ^6.8.0
  custom_lint: ^0.6.4
  riverpod_lint: ^2.3.10
```

---

### 3. analysis_options.yaml

```yaml
include: package:flutter_lints/flutter.yaml

analyzer:
  plugins:
    - custom_lint
  errors:
    invalid_annotation_target: ignore

linter:
  rules:
    - always_use_package_imports
    - avoid_dynamic_calls
    - avoid_print
    - prefer_const_constructors
    - prefer_const_declarations
    - sort_pub_dependencies
```

---

### 4. Folder Structure

Create all folders as described in [architecture.md](../architecture.md). Add `.gitkeep` files so empty folders are tracked.

---

### 5. Theme

**`core/theme/app_colors.dart`**
Define the brand palette:
```dart
class AppColors {
  static const primary = Color(0xFF...) // brand primary — pick a strong marketplace color
  static const primaryDark = Color(0xFF...)
  static const secondary = Color(0xFF...)
  static const background = Color(0xFFF5F5F5)
  static const surface = Color(0xFFFFFFFF)
  static const error = Color(0xFFE53935)
  static const textPrimary = Color(0xFF1A1A1A)
  static const textSecondary = Color(0xFF757575)
  static const divider = Color(0xFFEEEEEE)
  static const shimmerBase = Color(0xFFE0E0E0)
  static const shimmerHighlight = Color(0xFFF5F5F5)
}
```

**`core/theme/app_text_styles.dart`**
Define typography scale: `displayLarge`, `titleLarge`, `titleMedium`, `bodyLarge`, `bodyMedium`, `labelLarge`, `labelSmall`.

**`core/theme/app_dimensions.dart`**
```dart
class AppDimensions {
  static const paddingXS = 4.0;
  static const paddingS = 8.0;
  static const paddingM = 16.0;
  static const paddingL = 24.0;
  static const paddingXL = 32.0;
  static const radiusS = 8.0;
  static const radiusM = 12.0;
  static const radiusL = 16.0;
  static const radiusXL = 24.0;
  static const cardElevation = 2.0;
  static const bottomNavHeight = 64.0;
}
```

**`core/theme/app_theme.dart`**
- Light theme using `ColorScheme.fromSeed` with brand primary
- Apply text styles, card theme, AppBar theme, input decoration theme, elevated button theme
- Consistent border radius everywhere

---

### 6. Constants

**`core/constants/api_constants.dart`**
```dart
class ApiConstants {
  static const baseUrl = String.fromEnvironment('API_BASE_URL', defaultValue: 'https://dev.ansormarket.uz');
  static const cdnBaseUrl = String.fromEnvironment('CDN_BASE_URL', defaultValue: 'https://cdn.ansormarket.uz');

  // Auth
  static const register = '/api/auth/register';
  static const login = '/api/auth/login';
  static const refresh = '/api/auth/refresh';
  static const logout = '/api/auth/logout';

  // Products
  static const productsGetList = '/api/products/getlist';
  static const products = '/api/products';

  // Categories
  static const categoriesGetList = '/api/categories/getlist';
  static const categoriesGetTree = '/api/categories/gettree';
  static const categories = '/api/categories';

  // Cart
  static const cart = '/api/cart';
  static const cartGetCart = '/api/cart/getcart';
  static const cartAddItem = '/api/cart/additem';
  static const cartClear = '/api/cart/clear';

  // Customer
  static const customerGetProfile = '/api/customer/getprofile';
  static const customerUpdateProfile = '/api/customer/updateprofile';
  static const customerChangePassword = '/api/customer/changepassword';

  // Branches
  static const branchesGetList = '/api/branches/getlist';
  static const branches = '/api/branches';
  static const branchesInRange = '/api/branches/in-range';
}
```

---

### 7. Secure Storage Abstraction

**`core/storage/secure_storage.dart`**
```dart
abstract class SecureStorageKeys {
  static const accessToken = 'access_token';
  static const refreshToken = 'refresh_token';
}

class SecureStorageService {
  final FlutterSecureStorage _storage;
  // read, write, delete, clearTokens methods
  // Future<String?> getAccessToken()
  // Future<String?> getRefreshToken()
  // Future<void> saveTokens({required String access, required String refresh})
  // Future<void> clearTokens()
}
```

Expose as a Riverpod provider: `secureStorageProvider`.

---

### 8. Networking

**`core/network/api_exception.dart`**
```dart
@freezed
class ApiException with _$ApiException implements Exception {
  const factory ApiException({
    required int statusCode,
    required String message,
    String? errorCode,
  }) = _ApiException;
}
```

**`core/network/logging_interceptor.dart`**
Pretty-print requests/responses in debug mode only (`kDebugMode`).

**`core/network/token_interceptor.dart`**
- `onRequest`: attach `Authorization: Bearer <accessToken>` if token exists
- `onError`: if 401, attempt refresh → retry; if refresh fails, clear tokens + trigger auth redirect via a `ProviderContainer` ref or a simple callback

**`core/network/dio_client.dart`**
```dart
Dio createDio(SecureStorageService storage) {
  final dio = Dio(BaseOptions(
    baseUrl: ApiConstants.baseUrl,
    connectTimeout: const Duration(seconds: 15),
    receiveTimeout: const Duration(seconds: 15),
    headers: {'Content-Type': 'application/json'},
  ));
  dio.interceptors.addAll([
    TokenInterceptor(storage, dio),
    if (kDebugMode) LoggingInterceptor(),
  ]);
  return dio;
}
```

Expose as `dioProvider`.

---

### 9. Image URL Helper

**`core/utils/image_url_helper.dart`**
```dart
class ImageUrlHelper {
  static String build(String imageKey) =>
      '${ApiConstants.cdnBaseUrl}/$imageKey';

  static String buildThumbnail(String imageKey) =>
      '${ApiConstants.cdnBaseUrl}/thumbnails/$imageKey';
}
```

---

### 10. Routing Skeleton

**`core/router/route_names.dart`**
```dart
abstract class RouteNames {
  static const splash = '/';
  static const login = '/login';
  static const register = '/register';
  static const home = '/home';
  static const categories = '/categories';
  static const productList = '/products';
  static const productDetail = '/products/:id';
  static const cart = '/cart';
  static const profile = '/profile';
  static const editProfile = '/profile/edit';
  static const changePassword = '/profile/change-password';
  static const branches = '/branches';
}
```

**`core/router/app_router.dart`**
- Define all routes with `GoRoute`
- Add `redirect` logic: unauthenticated users trying to access `/cart` or `/profile` → `/login`
- Use `CustomTransitionPage` with fade+slide for all transitions (duration: 250ms)
- Bottom navigation shell route wrapping Home, Catalog, Cart, Profile, Branches

---

### 11. Shared Widgets (Stubs)

Create stub implementations for:
- `AppButton` — primary filled, secondary outlined, text variants
- `AppTextField` — with label, hint, validation error display, prefix/suffix icon
- `ShimmerBox` — generic shimmer rectangle/circle
- `ErrorView` — centered icon + message + retry button
- `EmptyView` — centered illustration + message
- `OfflineBanner` — top warning strip, listens to `connectivityProvider`

---

### 12. main.dart & app.dart

**`main.dart`**
```dart
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();
  runApp(const ProviderScope(child: AnsorMarketApp()));
}
```

**`app.dart`**
```dart
class AnsorMarketApp extends ConsumerWidget {
  const AnsorMarketApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final router = ref.watch(appRouterProvider);
    return MaterialApp.router(
      title: 'AnsorMarket',
      theme: AppTheme.light,
      routerConfig: router,
      debugShowCheckedModeBanner: false,
    );
  }
}
```

---

### 13. Splash Screen

**`features/auth/presentation/screens/splash_screen.dart`**
- Show centered logo with a fade-in animation (`flutter_animate`)
- Read `accessToken` from secure storage
- If token exists → navigate to `/home`
- If not → navigate to `/login`
- Minimum display time: 1.5s (so the animation completes gracefully)

```dart
// Animation example
Logo().animate().fadeIn(duration: 600.ms).scale(begin: const Offset(0.8, 0.8))
```

---

## Acceptance Criteria

- [ ] `flutter pub get` runs with no errors
- [ ] `dart run build_runner build` runs with no errors
- [ ] App launches on Android and iOS simulator
- [ ] Splash screen shows, reads token, navigates to login (no token exists yet)
- [ ] All route stubs navigate without crashing
- [ ] Theme is applied consistently across stub screens
- [ ] No `dynamic` types in any core file
- [ ] `flutter analyze` returns zero errors
