import 'package:ansor_market_mobile/features/cart/data/cart_repository.dart';
import 'package:ansor_market_mobile/features/cart/domain/models/cart_model.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'cart_provider.g.dart';

@riverpod
class CartNotifier extends _$CartNotifier {
  @override
  AsyncValue<CartModel> build() => AsyncData(CartModel.empty());

  Future<void> loadCart() async {
    state = const AsyncLoading();
    try {
      final cart = await ref.read(cartRepositoryProvider).getCart();
      state = AsyncData(cart);
    } catch (e, st) {
      state = AsyncError(e, st);
    }
  }

  Future<void> addItem(
    String productId, {
    String? variantId,
    int quantity = 1,
  }) async {
    final previous = state;
    // Optimistic: add a temporary item
    final current = state.valueOrNull;
    if (current != null) {
      final existing = current.items
          .where((i) => i.productId == productId && i.variantId == variantId)
          .firstOrNull;
      if (existing != null) {
        final updated = current.items
            .map((i) => i.productId == productId && i.variantId == variantId
                ? i.copyWith(quantity: i.quantity + quantity)
                : i)
            .toList();
        state = AsyncData(
          current.copyWith(items: updated),
        );
      }
    }
    try {
      final cart = await ref.read(cartRepositoryProvider).addItem(
            productId: productId,
            variantId: variantId,
            quantity: quantity,
          );
      state = AsyncData(cart);
    } catch (e, st) {
      state = previous;
      state = AsyncError(e, st);
    }
  }

  Future<void> updateQuantity(String itemId, int quantity) async {
    if (quantity <= 0) {
      await removeItem(itemId);
      return;
    }
    final previous = state;
    final current = state.valueOrNull;
    if (current != null) {
      final updated =
          current.items.map((i) => i.id == itemId ? i.copyWith(quantity: quantity) : i).toList();
      state = AsyncData(current.copyWith(items: updated));
    }
    try {
      final cart = await ref
          .read(cartRepositoryProvider)
          .updateItem(itemId: itemId, quantity: quantity);
      state = AsyncData(cart);
    } catch (e, st) {
      state = previous;
      state = AsyncError(e, st);
    }
  }

  Future<void> removeItem(String itemId) async {
    final previous = state;
    final current = state.valueOrNull;
    if (current != null) {
      final updated = current.items.where((i) => i.id != itemId).toList();
      final newTotal = updated.fold(
          0.0, (sum, i) => sum + i.price * i.quantity);
      state = AsyncData(
        current.copyWith(items: updated, totalAmount: newTotal),
      );
    }
    try {
      final cart =
          await ref.read(cartRepositoryProvider).removeItem(itemId: itemId);
      state = AsyncData(cart);
    } catch (e, st) {
      state = previous;
      state = AsyncError(e, st);
    }
  }

  Future<void> clearCart() async {
    try {
      await ref.read(cartRepositoryProvider).clearCart();
      state = AsyncData(CartModel.empty());
    } catch (e, st) {
      state = AsyncError(e, st);
    }
  }
}

@riverpod
int cartItemCount(Ref ref) {
  return ref.watch(cartNotifierProvider).maybeWhen(
        data: (cart) => cart.items.fold(0, (s, i) => s + i.quantity),
        orElse: () => 0,
      );
}

@riverpod
CartItemModel? cartItemForProduct(Ref ref, String productId) {
  return ref.watch(cartNotifierProvider).maybeWhen(
        data: (cart) =>
            cart.items.where((i) => i.productId == productId).firstOrNull,
        orElse: () => null,
      );
}
