# Sprint 11 — Polish, Animations & Performance

## Goal
This sprint has no new features. It is entirely dedicated to making the app feel exceptional — silky-smooth animations, fast load times, no jank, dark mode, accessibility, and a production-ready release build. This is what separates a good app from a great one.

---

## 1. Animation Audit

Go through every screen and ensure:

### Page Transitions
- All `go_router` routes use `CustomTransitionPage` with consistent animation
- Standard: `FadeTransition` + slight scale (0.95 → 1.0), 250ms
- Modal routes (bottom sheets, overlays): slide up, 300ms
- Back transition: reverse of entry (automatic with go_router)

### Micro-interactions
Every interactive element must have a response:
- Buttons: scale down to 0.96 on press, spring back on release (use `GestureDetector` + `AnimatedScale` or `InkWell`)
- List items: slight background color flash on tap
- Toggle switches: smooth track + thumb animation (Flutter default is fine)
- Checkboxes: check-draw animation

### List Animations
Every `ListView`/`GridView` first load uses staggered entry:
```dart
// flutter_animate example
ListView.builder(
  itemBuilder: (context, index) => MyCard()
    .animate(delay: (index * 40).ms)
    .fadeIn(duration: 300.ms)
    .slideY(begin: 0.1, end: 0)
)
```
Maximum 8 items animated (beyond that, just show immediately — avoid janky long lists).

---

## 2. Dark Mode

Implement full dark mode support:

**`core/theme/app_theme.dart`** — add `AppTheme.dark`:
```dart
static ThemeData get dark => ThemeData(
  brightness: Brightness.dark,
  colorScheme: ColorScheme.fromSeed(
    seedColor: AppColors.primary,
    brightness: Brightness.dark,
  ),
  // ... mirror all customizations from light theme
);
```

**`app.dart`** — respect system preference:
```dart
MaterialApp.router(
  theme: AppTheme.light,
  darkTheme: AppTheme.dark,
  themeMode: ThemeMode.system,
  // ...
)
```

All custom colors must use `Theme.of(context).colorScheme` — no hardcoded `Color()` values in widgets.

Check every screen in dark mode:
- No hardcoded white backgrounds
- Shimmer colors adapt (use theme surface colors)
- Images still look correct on dark backgrounds (add subtle border if needed)
- `CachedNetworkImage` placeholder adapts to dark theme

---

## 3. Performance Optimization

### Image Performance
- Ensure all `CachedNetworkImage` calls specify `width` and `height` (avoids layout shifts)
- Use `memCacheWidth` / `memCacheHeight` to cap decoded image size
- Product list images: decode at card size, not full resolution
- Product detail gallery: use `ResizeImage` wrapper for thumbnails vs. full image

### List Performance
- All large lists use `ListView.builder` (never `ListView` with `children`)
- `const` constructors on all leaf widgets that don't change
- Avoid rebuilding parent widgets on child state changes — use `Consumer` / `select` narrowly
- Profile-test: run in profile mode on a real device, look for red frames in DevTools

### Startup Performance
- Move Hive init and any heavy work to `FutureProvider` initialized lazily, not in `main()`
- Splash screen should display in < 300ms

### Riverpod Optimization
- Use `.select()` to prevent unnecessary rebuilds:
  ```dart
  // Instead of watching the whole cart:
  final count = ref.watch(cartNotifierProvider.select(
    (state) => state.valueOrNull?.items.length ?? 0,
  ));
  ```
- Dispose providers that are no longer needed (use `keepAlive: false` default)

---

## 4. Accessibility

- All interactive elements have `Semantics` labels
- `CachedNetworkImage` includes `semanticsLabel` with product name
- Minimum tap target: 48×48 dp (check all icon buttons)
- Text scales correctly: test with system font size at 150% and 200%
- Color contrast: all text meets WCAG AA (4.5:1 for normal text, 3:1 for large)
- Screen reader test: run with TalkBack (Android) and VoiceOver (iOS)

---

## 5. Error & Edge Case Hardening

Audit every screen for:
- [ ] What happens with empty lists? (Empty state shown)
- [ ] What happens with a single item? (No layout breakage)
- [ ] What happens with very long text? (Proper overflow handling)
- [ ] What happens with missing images? (Placeholder shown)
- [ ] What happens on slow network? (Skeleton shown, not blank screen)
- [ ] What happens offline? (Offline banner + cached data or clear error)
- [ ] What if the API returns unexpected fields? (freezed handles gracefully with defaults)

---

## 6. Localization (i18n)

Prepare the app for multi-language support (Uzbekistan: Uzbek, Russian, English):

- Add `flutter_localizations` dependency
- Add `intl` package (already in dependencies)
- Create `lib/l10n/` folder with `.arb` files: `app_en.arb`, `app_uz.arb`, `app_ru.arb`
- Extract all hardcoded strings to ARB files
- Language selector in Profile → Other section (Sprint 05 placeholder becomes real)
- Persist selected locale in Hive

Priority: Uzbek and Russian. English as fallback.

---

## 7. App Icon & Splash Screen

### App Icon
- Use `flutter_launcher_icons` package
- Provide 1024×1024 brand icon
- Configure adaptive icon for Android (foreground + background layers)
- Configure for iOS

### Native Splash Screen
- Use `flutter_native_splash` package
- Brand color background + centered logo
- Appears instantly (before Flutter engine loads) — no blank white flash

```yaml
# flutter_native_splash config in pubspec.yaml:
flutter_native_splash:
  color: "#FFFFFF"  # or brand color
  image: assets/images/splash_logo.png
  android_12:
    image: assets/images/splash_logo.png
    icon_background_color: "#FFFFFF"
```

---

## 8. Release Preparation

### Android
- Update `android/app/build.gradle`: versionCode, versionName
- Generate upload keystore: `keytool -genkey -v -keystore upload-keystore.jks ...`
- Configure signing in `key.properties` (gitignored)
- Build: `flutter build apk --release` and `flutter build appbundle --release`

### iOS
- Update `ios/Runner/Info.plist`: bundle version, display name
- Configure signing in Xcode (team + provisioning profile)
- Build: `flutter build ipa --release`

### Pre-release Checklist
- [ ] `flutter analyze` — zero errors, zero warnings
- [ ] `flutter test` — all tests pass
- [ ] Debug banner removed (`debugShowCheckedModeBanner: false`)
- [ ] API base URL points to production
- [ ] No `print()` statements in code (use `kDebugMode` guard or remove)
- [ ] ProGuard/R8 rules for Android release build
- [ ] Privacy manifest for iOS (required by Apple)

---

## 9. Final Animations Checklist (Full App Review)

- [ ] Splash: logo fade + scale
- [ ] Login/Register: staggered field entry
- [ ] Home: category chips stagger, product cards stagger
- [ ] Category expand/collapse: AnimatedSize
- [ ] Product list: staggered grid
- [ ] Product detail: Hero image, gallery swipe, add-to-cart bounce
- [ ] Cart: item add slide-in, remove slide-out+collapse, badge scale
- [ ] Profile: section tiles stagger, avatar scale
- [ ] Branches: list stagger, map marker bounce, card slide-up
- [ ] Checkout: step slide transitions, confirmation checkmark
- [ ] Search: suggestion list stagger, filter chip pop
- [ ] Notifications: list stagger, badge scale, banner slide-down
- [ ] All page transitions: consistent fade+scale

---

## Acceptance Criteria

- [ ] App runs at 60fps on mid-range Android device (Pixel 4a equivalent)
- [ ] No layout shifts during loading
- [ ] Dark mode looks correct on all screens
- [ ] All hardcoded strings extracted to ARB files
- [ ] App icon and splash screen match brand
- [ ] Release APK/IPA builds successfully
- [ ] Zero `flutter analyze` errors
- [ ] Accessibility labels on all interactive elements
