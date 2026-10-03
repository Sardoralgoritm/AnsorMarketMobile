import 'package:ansor_market_mobile/core/router/route_names.dart';
import 'package:ansor_market_mobile/core/theme/app_colors.dart';
import 'package:ansor_market_mobile/core/theme/app_dimensions.dart';
import 'package:ansor_market_mobile/core/utils/currency_formatter.dart';
import 'package:ansor_market_mobile/core/utils/image_url_helper.dart';
import 'package:ansor_market_mobile/features/cart/domain/models/cart_model.dart';
import 'package:ansor_market_mobile/features/cart/presentation/providers/cart_provider.dart';
import 'package:ansor_market_mobile/shared/widgets/empty_view.dart';
import 'package:ansor_market_mobile/shared/widgets/error_view.dart';
import 'package:ansor_market_mobile/shared/widgets/shimmer_box.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class CartScreen extends ConsumerWidget {
  const CartScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final cartAsync = ref.watch(cartNotifierProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('My Cart'),
        actions: [
          cartAsync.maybeWhen(
            data: (cart) => cart.items.isNotEmpty
                ? IconButton(
                    icon: const Icon(Icons.delete_outline_rounded),
                    onPressed: () => _confirmClear(context, ref),
                  )
                : const SizedBox.shrink(),
            orElse: () => const SizedBox.shrink(),
          ),
        ],
      ),
      body: cartAsync.when(
        data: (cart) => cart.items.isEmpty
            ? EmptyView(
                message: 'Your cart is empty',
                subtitle: 'Browse our products and add something you like',
                icon: Icons.shopping_cart_outlined,
                actionLabel: 'Browse Products',
                onAction: () => context.go(RouteNames.home),
              )
            : _CartContent(cart: cart),
        loading: () => _CartSkeleton(),
        error: (e, _) => ErrorView(
          message: e.toString(),
          onRetry: () => ref.read(cartNotifierProvider.notifier).loadCart(),
        ),
      ),
    );
  }

  void _confirmClear(BuildContext context, WidgetRef ref) {
    showDialog<void>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Clear Cart'),
        content: const Text(
            'Are you sure you want to remove all items from your cart?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(ctx).pop();
              ref.read(cartNotifierProvider.notifier).clearCart();
            },
            child: const Text('Clear', style: TextStyle(color: AppColors.error)),
          ),
        ],
      ),
    );
  }
}

class _CartContent extends ConsumerWidget {
  const _CartContent({required this.cart});
  final CartModel cart;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Column(
      children: [
        Expanded(
          child: ListView.builder(
            padding: const EdgeInsets.all(AppDimensions.paddingM),
            itemCount: cart.items.length,
            itemBuilder: (context, i) {
              final item = cart.items[i];
              return Dismissible(
                key: ValueKey(item.id),
                direction: DismissDirection.endToStart,
                background: Container(
                  alignment: Alignment.centerRight,
                  padding: const EdgeInsets.only(right: AppDimensions.paddingL),
                  decoration: BoxDecoration(
                    color: AppColors.error,
                    borderRadius: BorderRadius.circular(AppDimensions.radiusM),
                  ),
                  child: const Icon(Icons.delete_outline, color: Colors.white),
                ),
                onDismissed: (_) {
                  HapticFeedback.mediumImpact();
                  ref.read(cartNotifierProvider.notifier).removeItem(item.id);
                },
                child: _CartItemTile(item: item)
                    .animate()
                    .fadeIn(duration: 300.ms, delay: Duration(milliseconds: i * 40))
                    .slideX(begin: 0.05),
              );
            },
          ),
        ),
        _CartSummary(cart: cart),
      ],
    );
  }
}

class _CartItemTile extends ConsumerWidget {
  const _CartItemTile({required this.item});
  final CartItemModel item;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Card(
      margin: const EdgeInsets.only(bottom: AppDimensions.paddingS),
      child: Padding(
        padding: const EdgeInsets.all(AppDimensions.paddingS),
        child: Row(
          children: [
            // Image
            ClipRRect(
              borderRadius: BorderRadius.circular(AppDimensions.radiusS),
              child: item.imageKey != null
                  ? CachedNetworkImage(
                      imageUrl: ImageUrlHelper.buildThumbnail(item.imageKey!),
                      width: 60,
                      height: 60,
                      fit: BoxFit.cover,
                      errorWidget: (_, __, ___) => Container(
                        width: 60,
                        height: 60,
                        color: AppColors.background,
                        child: const Icon(Icons.image_outlined,
                            color: AppColors.textSecondary),
                      ),
                    )
                  : Container(
                      width: 60,
                      height: 60,
                      color: AppColors.background,
                      child: const Icon(Icons.image_outlined,
                          color: AppColors.textSecondary),
                    ),
            ),
            const SizedBox(width: AppDimensions.paddingS),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    item.productName,
                    style: Theme.of(context)
                        .textTheme
                        .bodyMedium
                        ?.copyWith(fontWeight: FontWeight.w600),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  if (item.variantName != null)
                    Text(
                      item.variantName!,
                      style: Theme.of(context)
                          .textTheme
                          .labelSmall
                          ?.copyWith(color: AppColors.textSecondary),
                    ),
                  const SizedBox(height: 4),
                  Text(
                    CurrencyFormatter.format(item.price),
                    style: const TextStyle(
                      color: AppColors.primary,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
            // Quantity controls
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  CurrencyFormatter.format(item.price * item.quantity),
                  style: const TextStyle(fontWeight: FontWeight.w700),
                ),
                const SizedBox(height: 4),
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    _QtyBtn(
                      icon: Icons.remove,
                      onTap: () {
                        HapticFeedback.selectionClick();
                        ref.read(cartNotifierProvider.notifier).updateQuantity(
                              item.id,
                              item.quantity - 1,
                            );
                      },
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: AppDimensions.paddingS),
                      child: Text('${item.quantity}',
                          style: const TextStyle(fontWeight: FontWeight.w600)),
                    ),
                    _QtyBtn(
                      icon: Icons.add,
                      onTap: () {
                        HapticFeedback.selectionClick();
                        ref.read(cartNotifierProvider.notifier).updateQuantity(
                              item.id,
                              item.quantity + 1,
                            );
                      },
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _QtyBtn extends StatelessWidget {
  const _QtyBtn({required this.icon, required this.onTap});
  final IconData icon;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(6),
      child: Container(
        width: 28,
        height: 28,
        decoration: BoxDecoration(
          border: Border.all(color: AppColors.cardBorder),
          borderRadius: BorderRadius.circular(6),
        ),
        child: Icon(icon, size: 14),
      ),
    );
  }
}

class _CartSummary extends ConsumerWidget {
  const _CartSummary({required this.cart});
  final CartModel cart;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Container(
      padding: EdgeInsets.only(
        left: AppDimensions.paddingL,
        right: AppDimensions.paddingL,
        top: AppDimensions.paddingM,
        bottom: MediaQuery.of(context).padding.bottom + AppDimensions.paddingM,
      ),
      decoration: BoxDecoration(
        color: AppColors.surface,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha(20),
            blurRadius: 12,
            offset: const Offset(0, -4),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('${cart.totalItems} items',
                  style: Theme.of(context).textTheme.bodyMedium),
              AnimatedSwitcher(
                duration: const Duration(milliseconds: 300),
                child: Text(
                  CurrencyFormatter.format(cart.totalAmount),
                  key: ValueKey(cart.totalAmount),
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w700,
                    color: AppColors.primary,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: AppDimensions.paddingM),
          ElevatedButton(
            onPressed: () {},
            child: const Text('Proceed to Checkout'),
          ),
        ],
      ),
    );
  }
}

class _CartSkeleton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      padding: const EdgeInsets.all(AppDimensions.paddingM),
      itemCount: 4,
      separatorBuilder: (_, __) =>
          const SizedBox(height: AppDimensions.paddingS),
      itemBuilder: (_, __) => const ShimmerBox(width: double.infinity, height: 88),
    );
  }
}
