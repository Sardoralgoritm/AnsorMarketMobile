// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'branches_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$allBranchesHash() => r'a445ccf672321ae0910e5aa5d569083c6cdd15f8';

/// See also [allBranches].
@ProviderFor(allBranches)
final allBranchesProvider =
    AutoDisposeFutureProvider<List<BranchModel>>.internal(
  allBranches,
  name: r'allBranchesProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product') ? null : _$allBranchesHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef AllBranchesRef = AutoDisposeFutureProviderRef<List<BranchModel>>;
String _$nearbyBranchesNotifierHash() =>
    r'b31a4f15af3ff83f076fde7e80af36601fd981ff';

/// See also [NearbyBranchesNotifier].
@ProviderFor(NearbyBranchesNotifier)
final nearbyBranchesNotifierProvider = AutoDisposeNotifierProvider<
    NearbyBranchesNotifier, AsyncValue<List<BranchModel>>>.internal(
  NearbyBranchesNotifier.new,
  name: r'nearbyBranchesNotifierProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$nearbyBranchesNotifierHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$NearbyBranchesNotifier
    = AutoDisposeNotifier<AsyncValue<List<BranchModel>>>;
String _$branchViewModeNotifierHash() =>
    r'b06fd88553993dacdacbcaf1a675841d7968cfd9';

/// See also [BranchViewModeNotifier].
@ProviderFor(BranchViewModeNotifier)
final branchViewModeNotifierProvider = AutoDisposeNotifierProvider<
    BranchViewModeNotifier, BranchViewMode>.internal(
  BranchViewModeNotifier.new,
  name: r'branchViewModeNotifierProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$branchViewModeNotifierHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$BranchViewModeNotifier = AutoDisposeNotifier<BranchViewMode>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
