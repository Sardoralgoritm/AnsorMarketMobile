# Sprint 06 — Branches & Map

## Goal
Show users where AnsorMarket branches are located, with both a list view and an interactive map. Users can see which branches are near them and get key info (address, delivery radius). This builds trust and helps customers know where to pick up orders or which branch will deliver to them.

---

## API Endpoints

| Method | Endpoint | Body / Query | Auth | Description |
|--------|----------|-------------|------|-------------|
| POST | `/api/branches/getlist` | `{ page, pageSize }` | — | Paginated list of branches |
| GET | `/api/branches/{id}` | — | — | Single branch detail |
| GET | `/api/branches/in-range` | `?lat=...&lng=...` | — | Branches within delivery radius of a coordinate |

---

## Models

**`features/branches/domain/models/branch_model.dart`**
```dart
@freezed
class BranchModel with _$BranchModel {
  const factory BranchModel({
    required String id,
    required String name,
    required String address,
    required String city,
    required double latitude,
    required double longitude,
    required double deliveryRadiusKm,
    String? phone,
    String? workingHours,
  }) = _BranchModel;

  factory BranchModel.fromJson(Map<String, dynamic> json) => _$BranchModelFromJson(json);
}
```

---

## Data Layer

**`features/branches/data/branches_remote_datasource.dart`**
```dart
Future<PaginatedResult<BranchModel>> getBranchList({int page = 1, int pageSize = 50});
Future<BranchModel> getBranchById(String id);
Future<List<BranchModel>> getBranchesInRange({required double lat, required double lng});
```

---

## State

**`features/branches/presentation/providers/branches_provider.dart`**
```dart
@riverpod
Future<List<BranchModel>> allBranches(Ref ref) async {
  // Fetch all branches (small dataset, load all at once)
  return ref.watch(branchesRepositoryProvider).getAllBranches();
}

@riverpod
class NearbyBranchesNotifier extends _$NearbyBranchesNotifier {
  // State: AsyncValue<List<BranchModel>>
  // Requests user location then calls /in-range
  Future<void> loadNearby() async {
    state = const AsyncLoading();
    try {
      final position = await _getLocation();
      final branches = await ref.read(branchesRepositoryProvider)
          .getBranchesInRange(lat: position.latitude, lng: position.longitude);
      state = AsyncData(branches);
    } catch (e, st) {
      state = AsyncError(e, st);
    }
  }

  Future<Position> _getLocation() async {
    // Check permission, request if needed
    // Throw descriptive exception if denied
  }
}

@riverpod
class BranchViewModeNotifier extends _$BranchViewModeNotifier {
  // State: enum BranchViewMode { list, map }
  void toggle() => state = state == BranchViewMode.list ? BranchViewMode.map : BranchViewMode.list;
}
```

---

## Screens

### Branches Screen (List + Map Toggle)

This is a single screen with two views toggled by a segmented button in the AppBar.

**AppBar:**
- Title: "Branches"
- Segmented toggle: `[≡ List] [🗺 Map]` — smooth cross-fade between views
- "Near Me" button (location icon) — triggers `nearbyBranchesNotifier.loadNearby()`

---

#### List View

**Layout:**
- Vertical list of `BranchCard` widgets
- Pull-to-refresh

**BranchCard Widget:**
- Branch name (bold)
- City + address (secondary color, 2 lines max)
- Working hours (if available)
- Delivery radius chip: "Delivers within 5 km" (green pill)
- "View on Map" button → switches to map view with that branch highlighted

**UX details:**
- Cards animate in with staggered fade+slide on first load
- Distance from user shown if location permission is granted: "2.3 km away"

---

#### Map View

**Layout:**
- Full-screen `FlutterMap` (OpenStreetMap tiles)
- Custom map markers for each branch (brand color pin with icon)
- User location dot (blue pulsing dot) if permission granted
- Delivery radius circle overlay (semi-transparent, per branch when selected)
- Floating bottom card: appears when a marker is tapped, shows branch details
- "Center on me" FAB (bottom right)

**Map behavior:**
- Initial camera: zoom to fit all markers
- Tap a marker: map smoothly animates to center on that branch + shows bottom card
- Bottom card: branch name, address, delivery radius, "Get Directions" button (opens native maps)
- "Get Directions" opens `maps.google.com/?daddr=lat,lng` or Apple Maps via `url_launcher`

**"Near Me" behavior:**
1. Request location permission via `permission_handler`
2. If granted: get current position, call `/api/branches/in-range`, highlight nearby branches with a different marker color, scroll list to first nearby branch
3. If denied: show bottom sheet explaining why location is needed + "Open Settings" button

**UX details:**
- Map tile loading: tiles fade in as they load
- Marker tap: scale animation on marker
- Camera animation: smooth 500ms ease-in-out transition
- Pulsing user location dot: custom animated widget (scale + opacity loop)

---

## Location Permission Handling

```dart
// In branches_provider.dart
Future<Position> _getLocation() async {
  var permission = await Geolocator.checkPermission();
  if (permission == LocationPermission.denied) {
    permission = await Geolocator.requestPermission();
  }
  if (permission == LocationPermission.deniedForever) {
    throw const LocationPermissionDeniedException();
  }
  return await Geolocator.getCurrentPosition(
    desiredAccuracy: LocationAccuracy.high,
  );
}
```

Always handle:
- Permission denied → explain and offer to open settings
- Location services disabled → prompt to enable GPS
- Timeout → show error with retry

---

## "Get Directions" Deep Link

```dart
void openDirections(double lat, double lng) async {
  final uri = Platform.isIOS
      ? Uri.parse('maps:?daddr=$lat,$lng')
      : Uri.parse('geo:$lat,$lng?q=$lat,$lng');
  if (await canLaunchUrl(uri)) {
    await launchUrl(uri);
  } else {
    // fallback to google maps web
    await launchUrl(Uri.parse('https://maps.google.com/?daddr=$lat,$lng'));
  }
}
```

---

## Animations Checklist

- [ ] List/Map toggle: cross-fade between views (AnimatedSwitcher)
- [ ] Branch cards: staggered slide-in on list load
- [ ] Map markers: scale bounce when map loads
- [ ] Selected marker: scale up + color change
- [ ] Branch detail card: slide up from bottom
- [ ] User location dot: pulsing scale + opacity animation (looping)
- [ ] Camera movement: smooth CameraFit animation

---

## Acceptance Criteria

- [ ] All branches load in list view
- [ ] Map view shows all branches as markers
- [ ] Tapping a marker shows branch detail card
- [ ] "Near Me" requests location permission and shows nearby branches
- [ ] "Get Directions" opens native maps app
- [ ] List/map toggle works smoothly
- [ ] Location permission denied shows helpful prompt
- [ ] Pull-to-refresh reloads branch list
- [ ] `flutter analyze` returns zero errors
