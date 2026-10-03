# Sprint 05 — Customer Profile

## Goal
Build the profile section: view user info, edit profile, change password, and logout. This section must feel clean and trustworthy — users are managing their personal data here.

---

## API Endpoints

| Method | Endpoint | Body | Auth | Description |
|--------|----------|------|------|-------------|
| GET | `/api/customer/getprofile` | — | Bearer | Fetch current user profile |
| PUT | `/api/customer/updateprofile` | `{ fullName, email? }` | Bearer | Update name and email |
| PUT | `/api/customer/changepassword` | `{ currentPassword, newPassword }` | Bearer | Change password |

---

## Models

**`features/profile/domain/models/profile_model.dart`**
```dart
@freezed
class ProfileModel with _$ProfileModel {
  const factory ProfileModel({
    required String id,
    required String fullName,
    required String phone,
    String? email,
  }) = _ProfileModel;

  factory ProfileModel.fromJson(Map<String, dynamic> json) => _$ProfileModelFromJson(json);
}
```

---

## Data Layer

**`features/profile/data/profile_remote_datasource.dart`**
```dart
Future<ProfileModel> getProfile();
Future<ProfileModel> updateProfile({required String fullName, String? email});
Future<void> changePassword({required String currentPassword, required String newPassword});
```

**`features/profile/data/profile_repository.dart`**
Wraps datasource. Exposes same interface. Caches profile in memory for the session.

---

## State

**`features/profile/presentation/providers/profile_provider.dart`**
```dart
@riverpod
class ProfileNotifier extends _$ProfileNotifier {
  // State: AsyncValue<ProfileModel>

  Future<void> loadProfile() async { ... }
  Future<void> updateProfile(String fullName, String? email) async { ... }
  Future<void> changePassword(String current, String newPassword) async { ... }
}
```

Profile is shared between Profile screen and any other screen needing the user's name (e.g., AppBar greeting on Home).

---

## Screens

### Profile Screen

**Layout:**
- No AppBar — custom header area
- Header:
  - Large circular avatar placeholder (initials-based, e.g., "SS" for Sardor Saminov, colored background generated from name hash)
  - Full name (large, bold)
  - Phone number (secondary color)
  - Email if set (secondary color, smaller)
  - "Edit Profile" text button
- Section: "Account"
  - List tile: Edit Profile → navigates to Edit Profile screen
  - List tile: Change Password → navigates to Change Password screen
  - List tile: My Orders → (placeholder, Sprint 07)
- Section: "Other"
  - List tile: Nearby Branches → navigates to Branches screen
  - List tile: Language (placeholder)
  - List tile: App Version (read-only, shows current version)
- Logout button at bottom (text button, red, with confirmation)

**UX details:**
- Avatar initials generated from `fullName.split(' ').map((w) => w[0]).take(2).join()`
- Avatar background color: deterministic from name hash (so it's always the same color per user)
- Edit Profile and Change Password use slide-right page transition
- Logout triggers `AlertDialog`: "Are you sure you want to log out?" — Confirm/Cancel
- On logout: clear tokens → `authNotifier.logout()` → go_router redirects to `/login` (no back stack)
- Pull-to-refresh reloads profile data

---

### Edit Profile Screen

**Layout:**
- AppBar: "Edit Profile" + save icon button (top right)
- Avatar at top (same initials style, slightly smaller)
- Full name field (pre-filled, auto-focused)
- Email field (pre-filled if exists, optional)
- Phone field (read-only, greyed out — phone cannot be changed)
- Hint text below phone: "Phone number cannot be changed"
- Save button at bottom (primary, full width) — same as top-right save

**UX details:**
- Both Save button and top-right icon trigger the same save action
- Form only enables save when values have actually changed
- Show inline success: `SnackBar` with green background + checkmark: "Profile updated"
- Haptic `HapticFeedback.lightImpact()` on success
- On error: red SnackBar + haptic vibrate
- Navigate back automatically on successful save

**Validation:**
- Full name: required, min 2 characters
- Email: optional, but if filled must be valid email format

---

### Change Password Screen

**Layout:**
- AppBar: "Change Password"
- Current password field (show/hide toggle)
- New password field (show/hide toggle)
- Confirm new password field (show/hide toggle)
- Password strength indicator below new password field (weak/medium/strong — color bar)
- "Update Password" button (primary, full width)

**UX details:**
- Password strength bar animates as user types
- Confirm field shows error icon + "Passwords don't match" if they differ
- On success: `SnackBar` "Password changed successfully" + navigate back
- On wrong current password: inline error on Current Password field
- All three fields use `TextInputType.visiblePassword`
- Haptic feedback on success and error

**Validation:**
- Current password: required
- New password: required, min 8 characters, at least one number
- Confirm: must match new password

**Password strength logic:**
```
weak:   length < 8 or no numbers
medium: length >= 8, has numbers
strong: length >= 10, has numbers, has uppercase, has special char
```

---

## Animations Checklist

- [ ] Profile screen: avatar fade-in with scale on entry
- [ ] Section tiles: staggered slide-in from right
- [ ] Edit Profile → save: button loading state crossfade
- [ ] Password strength bar: animated width transition
- [ ] Logout dialog: default AlertDialog animation (no custom needed)

---

## Acceptance Criteria

- [ ] Profile screen loads and shows user data
- [ ] Edit profile saves correctly and updates displayed name
- [ ] Email can be added or updated
- [ ] Phone field is read-only
- [ ] Change password works with correct current password
- [ ] Wrong current password shows appropriate error (not a generic one)
- [ ] Logout clears tokens and redirects to login
- [ ] Pull-to-refresh reloads profile
- [ ] `flutter analyze` returns zero errors
