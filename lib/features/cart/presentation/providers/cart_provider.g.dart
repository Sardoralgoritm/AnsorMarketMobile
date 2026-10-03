// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'cart_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$cartItemCountHash() => r'670493ebdad32f97e2c762ea4bce59cd13bb2f85';

/// See also [cartItemCount].
@ProviderFor(cartItemCount)
final cartItemCountProvider = AutoDisposeProvider<int>.internal(
  cartItemCount,
  name: r'cartItemCountProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$cartItemCountHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef CartItemCountRef = AutoDisposeProviderRef<int>;
String _$cartItemForProductHash() =>
    r'756b12c9e6a8018695d43ee948d3e7ea51937cf6';

/// Copied from Dart SDK
class _SystemHash {
  _SystemHash._();

  static int combine(int hash, int value) {
    // ignore: parameter_assignments
    hash = 0x1fffffff & (hash + value);
    // ignore: parameter_assignments
    hash = 0x1fffffff & (hash + ((0x0007ffff & hash) << 10));
    return hash ^ (hash >> 6);
  }

  static int finish(int hash) {
    // ignore: parameter_assignments
    hash = 0x1fffffff & (hash + ((0x03ffffff & hash) << 3));
    // ignore: parameter_assignments
    hash = hash ^ (hash >> 11);
    return 0x1fffffff & (hash + ((0x00003fff & hash) << 15));
  }
}

/// See also [cartItemForProduct].
@ProviderFor(cartItemForProduct)
const cartItemForProductProvider = CartItemForProductFamily();

/// See also [cartItemForProduct].
class CartItemForProductFamily extends Family<CartItemModel?> {
  /// See also [cartItemForProduct].
  const CartItemForProductFamily();

  /// See also [cartItemForProduct].
  CartItemForProductProvider call(
    String productId,
  ) {
    return CartItemForProductProvider(
      productId,
    );
  }

  @override
  CartItemForProductProvider getProviderOverride(
    covariant CartItemForProductProvider provider,
  ) {
    return call(
      provider.productId,
    );
  }

  static const Iterable<ProviderOrFamily>? _dependencies = null;

  @override
  Iterable<ProviderOrFamily>? get dependencies => _dependencies;

  static const Iterable<ProviderOrFamily>? _allTransitiveDependencies = null;

  @override
  Iterable<ProviderOrFamily>? get allTransitiveDependencies =>
      _allTransitiveDependencies;

  @override
  String? get name => r'cartItemForProductProvider';
}

/// See also [cartItemForProduct].
class CartItemForProductProvider extends AutoDisposeProvider<CartItemModel?> {
  /// See also [cartItemForProduct].
  CartItemForProductProvider(
    String productId,
  ) : this._internal(
          (ref) => cartItemForProduct(
            ref as CartItemForProductRef,
            productId,
          ),
          from: cartItemForProductProvider,
          name: r'cartItemForProductProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$cartItemForProductHash,
          dependencies: CartItemForProductFamily._dependencies,
          allTransitiveDependencies:
              CartItemForProductFamily._allTransitiveDependencies,
          productId: productId,
        );

  CartItemForProductProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.productId,
  }) : super.internal();

  final String productId;

  @override
  Override overrideWith(
    CartItemModel? Function(CartItemForProductRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: CartItemForProductProvider._internal(
        (ref) => create(ref as CartItemForProductRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        productId: productId,
      ),
    );
  }

  @override
  AutoDisposeProviderElement<CartItemModel?> createElement() {
    return _CartItemForProductProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is CartItemForProductProvider && other.productId == productId;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, productId.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin CartItemForProductRef on AutoDisposeProviderRef<CartItemModel?> {
  /// The parameter `productId` of this provider.
  String get productId;
}

class _CartItemForProductProviderElement
    extends AutoDisposeProviderElement<CartItemModel?>
    with CartItemForProductRef {
  _CartItemForProductProviderElement(super.provider);

  @override
  String get productId => (origin as CartItemForProductProvider).productId;
}

String _$cartNotifierHash() => r'c1604004e9c2380485ebdfa7f039e0264fef2ca5';

/// See also [CartNotifier].
@ProviderFor(CartNotifier)
final cartNotifierProvider =
    AutoDisposeNotifierProvider<CartNotifier, AsyncValue<CartModel>>.internal(
  CartNotifier.new,
  name: r'cartNotifierProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product') ? null : _$cartNotifierHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$CartNotifier = AutoDisposeNotifier<AsyncValue<CartModel>>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
