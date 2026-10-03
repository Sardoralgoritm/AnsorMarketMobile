import 'package:ansor_market_mobile/features/branches/data/branches_repository.dart';
import 'package:ansor_market_mobile/features/branches/domain/models/branch_model.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:geolocator/geolocator.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'branches_provider.g.dart';

enum BranchViewMode { list, map }

class LocationPermissionDeniedException implements Exception {
  const LocationPermissionDeniedException([this.message = 'Location permission denied']);
  final String message;
  @override
  String toString() => message;
}

@riverpod
Future<List<BranchModel>> allBranches(Ref ref) async {
  return ref.watch(branchesRepositoryProvider).getAllBranches();
}

@riverpod
class NearbyBranchesNotifier extends _$NearbyBranchesNotifier {
  @override
  AsyncValue<List<BranchModel>> build() => const AsyncData([]);

  Future<void> loadNearby() async {
    state = const AsyncLoading();
    try {
      final position = await _getLocation();
      final branches =
          await ref.read(branchesRepositoryProvider).getBranchesInRange(
                lat: position.latitude,
                lng: position.longitude,
              );
      state = AsyncData(branches);
    } catch (e, st) {
      state = AsyncError(e, st);
    }
  }

  Future<Position> _getLocation() async {
    var permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
    }
    if (permission == LocationPermission.deniedForever ||
        permission == LocationPermission.denied) {
      throw const LocationPermissionDeniedException();
    }
    return Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high,
    );
  }
}

@riverpod
class BranchViewModeNotifier extends _$BranchViewModeNotifier {
  @override
  BranchViewMode build() => BranchViewMode.list;

  void toggle() => state =
      state == BranchViewMode.list ? BranchViewMode.map : BranchViewMode.list;

  void setMode(BranchViewMode mode) => state = mode;
}
