# Architecture & Tech Stack

## Guiding Principles

1. **User experience first** — every technical decision must serve a smooth, fast, delightful UI.
2. **Feature-first structure** — code is organized by feature, not by layer. Each feature is self-contained.
3. **No business logic in widgets** — widgets are pure UI. All state lives in Riverpod notifiers.
4. **Typed everywhere** — no `dynamic`, no raw `Map<String, dynamic>` passed around. All models use `freezed`.
5. **Design for evolution** — the backend is growing. Data layer must be easy to extend without touching UI.

---

## Tech Stack

| Concern | Package | Reason |
|---------|---------|--------|
| State management | `riverpod` + `flutter_riverpod` + `riverpod_annotation` | Compile-safe, testable, code-gen |
| Navigation | `go_router` | Declarative, deep-link ready, auth redirect support |
| Networking | `dio` | Interceptors for JWT, refresh, logging |
| Secure storage | `flutter_secure_storage` | Keychain/Keystore backed token storage |
| Models | `freezed` + `json_serializable` | Immutable, union types, copyWith, fromJson/toJson |
| Local cache | `hive_flutter` | Fast key-value, offline support |
| Images | `cached_network_image` | CDN image caching + fade-in |
| Animations | `flutter_animate` | Declarative, chainable animations |
| Maps | `flutter_map` + `latlong2` | Lightweight OSM-based map |
| Location | `geolocator` + `permission_handler` | User location for branch proximity |
| Pull-to-refresh | `easy_refresh` | Beautiful custom refresh indicators |
| Shimmer loading | `shimmer` | Skeleton loaders on every list/detail screen |
| Haptics | Flutter built-in `HapticFeedback` | Tactile feedback on cart actions, errors |
| Bottom nav | `persistent_bottom_nav_bar` or custom | Smooth tab transitions with state preservation |
| Form validation | `reactive_forms` or manual with Riverpod | Inline validation, clean error display |
| Connectivity | `connectivity_plus` | Offline detection + banner |
| Linting | `flutter_lints` + custom `analysis_options.yaml` | Consistent code style |
| Code generation | `build_runner` | Freezed + Riverpod + json_serializable |

---

## Project Structure

```
lib/
├── main.dart                          # Entry point, ProviderScope
├── app.dart                           # MaterialApp.router, theme, locale
│
├── core/
│   ├── constants/
│   │   ├── api_constants.dart         # Base URL, endpoint paths
│   │   └── asset_constants.dart       # Image/icon asset paths
│   ├── theme/
│   │   ├── app_theme.dart             # Light + dark ThemeData
│   │   ├── app_colors.dart            # Brand color palette
│   │   ├── app_text_styles.dart       # Typography scale
│   │   └── app_dimensions.dart        # Spacing, radius constants
│   ├── router/
│   │   ├── app_router.dart            # go_router config
│   │   ├── route_names.dart           # Named route constants
│   │   └── auth_redirect_guard.dart   # Redirect unauthenticated users
│   ├── network/
│   │   ├── dio_client.dart            # Dio singleton + interceptor registration
│   │   ├── token_interceptor.dart     # Attach Bearer, handle 401 + refresh
│   │   ├── logging_interceptor.dart   # Pretty-print requests in debug
│   │   └── api_exception.dart         # Typed API error model
│   ├── storage/
│   │   ├── secure_storage.dart        # Token read/write/clear abstraction
│   │   └── hive_storage.dart          # Hive boxes init + helpers
│   └── utils/
│       ├── image_url_helper.dart      # Build CDN URL from imageKey
│       ├── currency_formatter.dart    # Format prices (UZS etc.)
│       └── validators.dart            # Phone, email, password validators
│
├── features/
│   ├── auth/
│   │   ├── data/
│   │   │   ├── auth_remote_datasource.dart
│   │   │   └── auth_repository.dart
│   │   ├── domain/
│   │   │   ├── models/user_model.dart
│   │   │   └── models/token_model.dart
│   │   └── presentation/
│   │       ├── providers/auth_provider.dart
│   │       ├── screens/splash_screen.dart
│   │       ├── screens/login_screen.dart
│   │       └── screens/register_screen.dart
│   │
│   ├── home/
│   │   └── presentation/
│   │       ├── providers/home_provider.dart
│   │       └── screens/home_screen.dart
│   │
│   ├── catalog/
│   │   ├── data/
│   │   │   ├── catalog_remote_datasource.dart
│   │   │   └── catalog_repository.dart
│   │   ├── domain/
│   │   │   ├── models/category_model.dart
│   │   │   └── models/product_model.dart
│   │   └── presentation/
│   │       ├── providers/
│   │       │   ├── category_provider.dart
│   │       │   └── product_provider.dart
│   │       └── screens/
│   │           ├── category_tree_screen.dart
│   │           ├── product_list_screen.dart
│   │           └── product_detail_screen.dart
│   │
│   ├── cart/
│   │   ├── data/
│   │   │   ├── cart_remote_datasource.dart
│   │   │   └── cart_repository.dart
│   │   ├── domain/
│   │   │   └── models/cart_model.dart
│   │   └── presentation/
│   │       ├── providers/cart_provider.dart
│   │       └── screens/cart_screen.dart
│   │
│   ├── profile/
│   │   ├── data/
│   │   │   ├── profile_remote_datasource.dart
│   │   │   └── profile_repository.dart
│   │   ├── domain/
│   │   │   └── models/profile_model.dart
│   │   └── presentation/
│   │       ├── providers/profile_provider.dart
│   │       └── screens/
│   │           ├── profile_screen.dart
│   │           ├── edit_profile_screen.dart
│   │           └── change_password_screen.dart
│   │
│   ├── branches/
│   │   ├── data/
│   │   │   ├── branches_remote_datasource.dart
│   │   │   └── branches_repository.dart
│   │   ├── domain/
│   │   │   └── models/branch_model.dart
│   │   └── presentation/
│   │       ├── providers/branches_provider.dart
│   │       └── screens/
│   │           ├── branch_list_screen.dart
│   │           └── branch_map_screen.dart
│   │
│   ├── orders/
│   │   └── ... (Sprint 07)
│   │
│   ├── search/
│   │   └── ... (Sprint 08)
│   │
│   └── notifications/
│       └── ... (Sprint 10)
│
└── shared/
    ├── widgets/
    │   ├── app_button.dart            # Primary, secondary, text variants
    │   ├── app_text_field.dart        # Styled input with validation display
    │   ├── product_card.dart          # Reusable product card with add-to-cart
    │   ├── category_chip.dart         # Category pill/chip widget
    │   ├── shimmer_box.dart           # Generic shimmer placeholder
    │   ├── error_view.dart            # Centered error + retry button
    │   ├── empty_view.dart            # Empty state illustration + message
    │   ├── offline_banner.dart        # Top banner when no connectivity
    │   └── bottom_nav_bar.dart        # Main app bottom navigation
    └── extensions/
        ├── context_ext.dart           # theme, colors, size shortcuts
        └── string_ext.dart            # capitalize, truncate helpers
```

---

## State Management Pattern

Every feature follows the same pattern:

```
RemoteDataSource  →  Repository  →  Riverpod Notifier  →  Widget
```

- **RemoteDataSource**: raw Dio calls, returns `Map` or throws `ApiException`
- **Repository**: converts raw data to typed models, abstracts data source
- **Notifier** (`AsyncNotifier` or `Notifier`): holds state, exposes methods, calls repository
- **Widget**: watches provider, renders UI, calls notifier methods on user actions

---

## Auth Token Flow

```
App start
  └── SplashScreen reads secureStorage
        ├── Token exists → validate (try /getcart or silent check) → Home
        └── No token → Login

Login success
  └── Store accessToken + refreshToken in flutter_secure_storage
      └── Update authStateProvider → go_router redirects to Home

Any API request
  └── TokenInterceptor attaches Authorization: Bearer <accessToken>
        └── 401 received
              ├── Call POST /api/auth/refresh with refreshToken
              │     ├── Success → store new tokens, retry original request
              │     └── Failure → clear tokens, redirect to Login
              └── Other errors → propagate as ApiException
```

---

## UI/UX Standards

These must be respected across every screen:

- **Skeleton loaders** on every screen that fetches data — no raw CircularProgressIndicator
- **Smooth page transitions** — use custom `CustomTransitionPage` in go_router (fade + slide)
- **Haptic feedback** on: add to cart, remove from cart, successful form submission, errors
- **Optimistic UI** on cart — update count immediately, revert on error
- **Pull-to-refresh** on all list screens
- **Infinite scroll pagination** on product lists and order history
- **Error states** with retry button — never a dead end
- **Empty states** with illustration and helpful message
- **Offline banner** — non-intrusive top bar when connectivity lost
- **Hero animations** on product image (list → detail)
- **Bottom sheet modals** instead of new routes for quick actions (quantity picker, filter panel)
- **Safe area** respected on all screens (notch, home indicator)
- **Keyboard avoiding** on all form screens

---

## CDN Image URLs

All images are stored by `imageKey`. Build the full URL via a single helper:

```dart
// core/utils/image_url_helper.dart
class ImageUrlHelper {
  static String build(String imageKey) =>
      '${ApiConstants.cdnBaseUrl}/$imageKey';
}
```

Never construct CDN URLs inline in widgets.

---

## Environment / Flavors

Three flavors: `development`, `staging`, `production`. Each has its own:
- API base URL
- CDN base URL
- App name suffix (dev/staging only)

Configure via `--dart-define` or a `config/` folder with flavor-specific files.
