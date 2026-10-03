# Sprint 02 — Authentication

## Goal
Implement the full authentication flow: register, login, logout, and silent token refresh. Users with a valid session skip auth entirely. The UI must feel polished — smooth transitions, inline validation, clear error messages, and satisfying haptic feedback on success/failure.

---

## API Endpoints

| Method | Endpoint | Body | Response |
|--------|----------|------|----------|
| POST | `/api/auth/register` | `{ phone, password, fullName }` | `{ accessToken, refreshToken, user }` |
| POST | `/api/auth/login` | `{ phone, password }` | `{ accessToken, refreshToken, user }` |
| POST | `/api/auth/refresh` | `{ refreshToken }` | `{ accessToken, refreshToken }` |
| POST | `/api/auth/logout` | `{ refreshToken }` | `204` |

---

## Models

**`features/auth/domain/models/token_model.dart`**
```dart
@freezed
class TokenModel with _$TokenModel {
  const factory TokenModel({
    required String accessToken,
    required String refreshToken,
  }) = _TokenModel;

  factory TokenModel.fromJson(Map<String, dynamic> json) => _$TokenModelFromJson(json);
}
```

**`features/auth/domain/models/user_model.dart`**
```dart
@freezed
class UserModel with _$UserModel {
  const factory UserModel({
    required String id,
    required String fullName,
    required String phone,
    String? email,
  }) = _UserModel;

  factory UserModel.fromJson(Map<String, dynamic> json) => _$UserModelFromJson(json);
}
```

**`features/auth/domain/models/auth_response_model.dart`**
```dart
@freezed
class AuthResponseModel with _$AuthResponseModel {
  const factory AuthResponseModel({
    required TokenModel tokens,
    required UserModel user,
  }) = _AuthResponseModel;

  factory AuthResponseModel.fromJson(Map<String, dynamic> json) => _$AuthResponseModelFromJson(json);
}
```

---

## Data Layer

**`features/auth/data/auth_remote_datasource.dart`**

Methods:
- `Future<AuthResponseModel> register({required String fullName, required String phone, required String password})`
- `Future<AuthResponseModel> login({required String phone, required String password})`
- `Future<TokenModel> refresh({required String refreshToken})`
- `Future<void> logout({required String refreshToken})`

All methods catch `DioException` and rethrow as `ApiException`.

**`features/auth/data/auth_repository.dart`**

Wraps datasource. On successful login/register: calls `secureStorage.saveTokens(...)`. On logout: calls `secureStorage.clearTokens()`.

---

## State

**`features/auth/presentation/providers/auth_provider.dart`**

```dart
// Holds current auth state
@riverpod
class AuthNotifier extends _$AuthNotifier {
  // State: AsyncValue<UserModel?> — null means not logged in

  Future<void> login(String phone, String password) async { ... }
  Future<void> register(String fullName, String phone, String password) async { ... }
  Future<void> logout() async { ... }
  Future<void> loadFromStorage() async { ... } // called on splash
}
```

`go_router` listens to `authStateProvider` for redirect logic.

---

## Screens

### Splash Screen (update from Sprint 01)

Already created in Sprint 01. Now wire it to real token check:
1. Read token from secure storage
2. If valid: fetch user profile (or decode JWT) → set auth state → navigate to `/home`
3. If not: navigate to `/login`

---

### Login Screen

**Layout:**
- Full-screen scroll-safe layout
- App logo at top (centered, with padding)
- Title: "Welcome back" (large, bold)
- Subtitle: "Sign in to continue" (secondary color)
- Phone number field with `+998` country prefix (Uzbekistan)
- Password field with show/hide toggle
- "Forgot password?" text button (placeholder for now)
- Large primary "Sign In" button
- "Don't have an account? Register" row at bottom

**UX details:**
- Phone field auto-focuses on screen enter
- Keyboard type: `TextInputType.phone`
- Password field: `TextInputType.visiblePassword`, obscureText toggled
- Button shows `CircularProgressIndicator` (white, small) while loading — do NOT disable the button text, replace it
- On error: show `SnackBar` with red background + haptic `HapticFeedback.vibrate()`
- On success: haptic `HapticFeedback.lightImpact()` then navigate to `/home` with `go_router` (no back stack)
- Inline validation only on submit (not on every keystroke — annoying)
- Smooth fade+slide entry animation on screen load (use `flutter_animate`)

**Validation:**
- Phone: required, valid UZ phone format (`+998XXXXXXXXX` or `09X XXXXXXX`)
- Password: required, min 6 characters

---

### Register Screen

**Layout:**
- Back button in AppBar
- Title: "Create Account"
- Full name field (person icon prefix)
- Phone number field (same as login)
- Password field (show/hide toggle)
- Confirm password field
- Terms & conditions checkbox: "I agree to the Terms of Service"
- Large primary "Create Account" button
- "Already have an account? Sign in" row at bottom

**UX details:**
- Same loading/error/success behavior as Login
- On success: navigate to `/home` and clear auth stack (user is now logged in)
- Field order follows natural top-down flow — fullName → phone → password → confirm
- Tab order between fields works correctly
- Confirm password field shows red border + "Passwords don't match" instantly when user leaves the field

**Validation:**
- Full name: required, min 2 characters
- Phone: required, valid format
- Password: required, min 6 characters
- Confirm password: must match password
- Terms checkbox: must be checked

---

## Token Refresh (update TokenInterceptor from Sprint 01)

The interceptor created in Sprint 01 must now be fully wired:

```
onError (DioException, 401)
  ├── Lock dio queue (prevent duplicate refreshes)
  ├── Call POST /api/auth/refresh with stored refreshToken
  │     ├── Success:
  │     │     ├── Save new tokens to secure storage
  │     │     ├── Unlock queue
  │     │     └── Retry original request with new accessToken
  │     └── Failure:
  │           ├── Clear tokens from secure storage
  │           ├── Unlock queue
  │           └── Call onUnauthenticated callback → go_router redirects to /login
  └── Non-401 errors: pass through unchanged
```

Use `dio`'s `QueuedInterceptorsWrapper` or a `Lock` pattern to prevent multiple simultaneous refreshes.

---

## go_router Auth Guard (update from Sprint 01)

```dart
redirect: (context, state) {
  final isLoggedIn = ref.read(authStateProvider) != null;
  final isAuthRoute = state.matchedLocation.startsWith('/login') ||
                      state.matchedLocation.startsWith('/register');

  if (!isLoggedIn && !isAuthRoute) return RouteNames.login;
  if (isLoggedIn && isAuthRoute) return RouteNames.home;
  return null;
}
```

---

## Animations Checklist

- [ ] Splash logo: fade in + scale up (600ms)
- [ ] Login/Register screen: staggered fade+slide-up for each form field (50ms delay between fields)
- [ ] Button loading state: smooth crossfade between text and spinner
- [ ] Error SnackBar: slide up from bottom
- [ ] Transition from Login → Home: fade (no slide — avoids visual direction confusion)

---

## Acceptance Criteria

- [ ] User can register with full name, phone, password
- [ ] User can log in with phone + password
- [ ] Tokens stored securely on login/register
- [ ] Splash correctly detects existing session → skips auth screens
- [ ] 401 on any protected call triggers silent refresh
- [ ] Refresh failure → logout + redirect to login
- [ ] All validation messages display correctly
- [ ] Haptic feedback on success and error
- [ ] `flutter analyze` returns zero errors
