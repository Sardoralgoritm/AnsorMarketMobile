// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'category_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$categoryTreeHash() => r'2cc417c8a54aa7b0bef539cee197d299eb1accd7';

/// See also [categoryTree].
@ProviderFor(categoryTree)
final categoryTreeProvider =
    AutoDisposeFutureProvider<List<CategoryModel>>.internal(
  categoryTree,
  name: r'categoryTreeProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product') ? null : _$categoryTreeHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef CategoryTreeRef = AutoDisposeFutureProviderRef<List<CategoryModel>>;
String _$selectedCategoryNotifierHash() =>
    r'a62dea47c42cb74dfbf90efebb83e5d7d9963b8f';

/// See also [SelectedCategoryNotifier].
@ProviderFor(SelectedCategoryNotifier)
final selectedCategoryNotifierProvider = AutoDisposeNotifierProvider<
    SelectedCategoryNotifier, CategoryModel?>.internal(
  SelectedCategoryNotifier.new,
  name: r'selectedCategoryNotifierProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$selectedCategoryNotifierHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$SelectedCategoryNotifier = AutoDisposeNotifier<CategoryModel?>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
