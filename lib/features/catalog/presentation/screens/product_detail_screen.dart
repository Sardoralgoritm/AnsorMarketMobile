import 'package:ansor_market_mobile/core/router/route_names.dart';
import 'package:ansor_market_mobile/core/theme/app_colors.dart';
import 'package:ansor_market_mobile/core/theme/app_dimensions.dart';
import 'package:ansor_market_mobile/core/utils/currency_formatter.dart';
import 'package:ansor_market_mobile/core/utils/image_url_helper.dart';
import 'package:ansor_market_mobile/features/cart/domain/models/cart_model.dart';
import 'package:ansor_market_mobile/features/cart/presentation/providers/cart_provider.dart';
import 'package:ansor_market_mobile/features/catalog/domain/models/product_model.dart';
import 'package:ansor_market_mobile/features/catalog/presentation/providers/product_provider.dart';
import 'package:ansor_market_mobile/shared/widgets/error_view.dart';
import 'package:ansor_market_mobile/shared/widgets/shimmer_box.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class ProductDetailScreen extends ConsumerStatefulWidget {
  const ProductDetailScreen({super.key, required this.productId});
  final String productId;

  @override
  ConsumerState<ProductDetailScreen> createState() =>
      _ProductDetailScreenState();
}

class _ProductDetailScreenState extends ConsumerState<ProductDetailScreen> {
  int _quantity = 1;
  String? _selectedVariantId;
  bool _addingToCart = false;
  bool _addedFeedback = false;
  final _pageController = PageController();
  int _currentImageIndex = 0;

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  double _effectivePrice(ProductModel product) {
    if (_selectedVariantId != null) {
      final variant = product.variants
          .where((v) => v.id == _selectedVariantId)
          .firstOrNull;
      if (variant != null) return variant.price;
    }
    return product.price;
  }

  Future<void> _addToCart(ProductModel product) async {
    setState(() => _addingToCart = true);
    HapticFeedback.mediumImpact();
    try {
      await ref.read(cartNotifierProvider.notifier).addItem(
            product.id,
            variantId: _selectedVariantId,
            quantity: _quantity,
          );
      if (!mounted) return;
      setState(() => _addedFeedback = true);
      await Future<void>.delayed(const Duration(milliseconds: 1200));
      if (mounted) setState(() => _addedFeedback = false);
    } catch (e) {
      if (!mounted) return;
      HapticFeedback.vibrate();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(e.toString()),
          backgroundColor: AppColors.error,
        ),
      );
    } finally {
      if (mounted) setState(() => _addingToCart = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final productAsync = ref.watch(productDetailProvider(widget.productId));
    final cartItem =
        ref.watch(cartItemForProductProvider(widget.productId));

    return Scaffold(
      body: productAsync.when(
        data: (product) => _buildContent(product, cartItem),
        loading: () => _buildSkeleton(),
        error: (e, _) => ErrorView(
          message: e.toString(),
          onRetry: () =>
              ref.invalidate(productDetailProvider(widget.productId)),
        ),
      ),
    );
  }

  Widget _buildContent(ProductModel product, CartItemModel? cartItem) {
    final price = _effectivePrice(product);

    return Stack(
      children: [
        CustomScrollView(
          slivers: [
            // Image gallery
            SliverToBoxAdapter(
              child: SizedBox(
                height: 320,
                child: Stack(
                  children: [
                    product.images.isEmpty
                        ? Container(
                            color: AppColors.background,
                            child: const Center(
                              child: Icon(Icons.image_outlined,
                                  size: 80, color: AppColors.textSecondary),
                            ),
                          )
                        : Hero(
                            tag: 'product_${product.id}',
                            child: PageView.builder(
                              controller: _pageController,
                              physics: const BouncingScrollPhysics(),
                              onPageChanged: (i) =>
                                  setState(() => _currentImageIndex = i),
                              itemCount: product.images.length,
                              itemBuilder: (_, i) => CachedNetworkImage(
                                imageUrl: ImageUrlHelper.build(
                                    product.images[i].imageKey),
                                fit: BoxFit.cover,
                                placeholder: (_, __) => Container(
                                    color: AppColors.shimmerBase),
                                errorWidget: (_, __, ___) => const Icon(
                                  Icons.image_outlined,
                                  color: AppColors.textSecondary,
                                ),
                              ),
                            ),
                          ),
                    // Back button
                    Positioned(
                      top: MediaQuery.of(context).padding.top + 8,
                      left: 12,
                      child: CircleAvatar(
                        backgroundColor:
                            Colors.black.withAlpha(120),
                        child: IconButton(
                          icon: const Icon(Icons.arrow_back,
                              color: Colors.white),
                          onPressed: () => context.pop(),
                        ),
                      ),
                    ),
                    // Dot indicators
                    if (product.images.length > 1)
                      Positioned(
                        bottom: 12,
                        left: 0,
                        right: 0,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: List.generate(
                            product.images.length,
                            (i) => AnimatedContainer(
                              duration: const Duration(milliseconds: 200),
                              margin:
                                  const EdgeInsets.symmetric(horizontal: 3),
                              width: _currentImageIndex == i ? 16 : 6,
                              height: 6,
                              decoration: BoxDecoration(
                                color: _currentImageIndex == i
                                    ? AppColors.primary
                                    : Colors.white.withAlpha(180),
                                borderRadius: BorderRadius.circular(3),
                              ),
                            ),
                          ),
                        ),
                      ),
                  ],
                ),
              ),
            ),
            // Content
            SliverPadding(
              padding: const EdgeInsets.all(AppDimensions.paddingM),
              sliver: SliverList(
                delegate: SliverChildListDelegate([
                  Text(product.name,
                          style: Theme.of(context).textTheme.titleLarge)
                      .animate()
                      .fadeIn(duration: 300.ms),
                  const SizedBox(height: AppDimensions.paddingS),
                  AnimatedSwitcher(
                    duration: const Duration(milliseconds: 200),
                    child: Text(
                      CurrencyFormatter.format(price),
                      key: ValueKey(price),
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            color: AppColors.primary,
                            fontSize: 22,
                          ),
                    ),
                  ),
                  if (product.description != null) ...[
                    const SizedBox(height: AppDimensions.paddingM),
                    Text(product.description!,
                        style: Theme.of(context).textTheme.bodyMedium),
                  ],
                  // Variants
                  if (product.variants.isNotEmpty) ...[
                    const SizedBox(height: AppDimensions.paddingM),
                    Text('Options',
                        style: Theme.of(context).textTheme.titleMedium),
                    const SizedBox(height: AppDimensions.paddingS),
                    Wrap(
                      spacing: AppDimensions.paddingS,
                      children: product.variants.map((v) {
                        final selected = _selectedVariantId == v.id;
                        return GestureDetector(
                          onTap: v.isAvailable
                              ? () => setState(
                                  () => _selectedVariantId = v.id)
                              : null,
                          child: AnimatedContainer(
                            duration: const Duration(milliseconds: 200),
                            padding: const EdgeInsets.symmetric(
                              horizontal: AppDimensions.paddingM,
                              vertical: AppDimensions.paddingS,
                            ),
                            decoration: BoxDecoration(
                              color: selected
                                  ? AppColors.primary
                                  : AppColors.surface,
                              borderRadius: BorderRadius.circular(
                                  AppDimensions.radiusM),
                              border: Border.all(
                                color: selected
                                    ? AppColors.primary
                                    : AppColors.cardBorder,
                              ),
                            ),
                            child: Text(
                              v.name,
                              style: TextStyle(
                                color: selected
                                    ? Colors.white
                                    : (v.isAvailable
                                        ? AppColors.textPrimary
                                        : AppColors.textSecondary),
                              ),
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                  ],
                  // Attributes
                  if (product.attributes.isNotEmpty) ...[
                    const SizedBox(height: AppDimensions.paddingM),
                    Text('Details',
                        style: Theme.of(context).textTheme.titleMedium),
                    const SizedBox(height: AppDimensions.paddingS),
                    ...product.attributes.map(
                      (a) => Padding(
                        padding: const EdgeInsets.only(
                            bottom: AppDimensions.paddingXS),
                        child: Row(
                          children: [
                            Text('${a.name}: ',
                                style: const TextStyle(
                                    fontWeight: FontWeight.w600)),
                            Text(a.value),
                          ],
                        ),
                      ),
                    ),
                  ],
                  // Quantity selector
                  const SizedBox(height: AppDimensions.paddingM),
                  Text('Quantity',
                      style: Theme.of(context).textTheme.titleMedium),
                  const SizedBox(height: AppDimensions.paddingS),
                  Row(
                    children: [
                      _QtyButton(
                        icon: Icons.remove,
                        onTap: _quantity > 1
                            ? () {
                                HapticFeedback.selectionClick();
                                setState(() => _quantity--);
                              }
                            : null,
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: AppDimensions.paddingM),
                        child: Text(
                          '$_quantity',
                          style:
                              Theme.of(context).textTheme.titleMedium,
                        ),
                      ),
                      _QtyButton(
                        icon: Icons.add,
                        onTap: () {
                          HapticFeedback.selectionClick();
                          setState(() => _quantity++);
                        },
                      ),
                    ],
                  ),
                  // Bottom padding for sticky bar
                  const SizedBox(height: 100),
                ]),
              ),
            ),
          ],
        ),
        // Sticky bottom bar
        Positioned(
          bottom: 0,
          left: 0,
          right: 0,
          child: Container(
            padding: EdgeInsets.only(
              left: AppDimensions.paddingM,
              right: AppDimensions.paddingM,
              top: AppDimensions.paddingM,
              bottom: MediaQuery.of(context).padding.bottom +
                  AppDimensions.paddingM,
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
            child: Row(
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Text('Total',
                        style:
                            TextStyle(color: AppColors.textSecondary)),
                    Text(
                      CurrencyFormatter.format(price * _quantity),
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w700,
                        color: AppColors.primary,
                      ),
                    ),
                  ],
                ),
                const SizedBox(width: AppDimensions.paddingM),
                Expanded(
                  child: cartItem != null
                      ? OutlinedButton.icon(
                          onPressed: () =>
                              context.push(RouteNames.cart),
                          icon: const Icon(Icons.shopping_cart),
                          label: Text(
                              'In Cart (${cartItem.quantity})'),
                        )
                      : ElevatedButton(
                          onPressed: _addingToCart
                              ? null
                              : () => _addToCart(product),
                          child: _addedFeedback
                              ? const Icon(Icons.check,
                                  color: Colors.white)
                              : _addingToCart
                                  ? const SizedBox(
                                      width: 20,
                                      height: 20,
                                      child: CircularProgressIndicator(
                                        strokeWidth: 2,
                                        color: Colors.white,
                                      ),
                                    )
                                  : const Text('Add to Cart'),
                        ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildSkeleton() {
    return const Column(
      children: [
        ShimmerBox(width: double.infinity, height: 320),
        Padding(
          padding: EdgeInsets.all(AppDimensions.paddingM),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ShimmerBox(width: double.infinity, height: 28),
              SizedBox(height: AppDimensions.paddingS),
              ShimmerBox(width: 120, height: 24),
              SizedBox(height: AppDimensions.paddingM),
              ShimmerBox(width: double.infinity, height: 16),
              SizedBox(height: 8),
              ShimmerBox(width: double.infinity, height: 16),
              SizedBox(height: 8),
              ShimmerBox(width: 200, height: 16),
            ],
          ),
        ),
      ],
    );
  }
}

class _QtyButton extends StatelessWidget {
  const _QtyButton({required this.icon, required this.onTap});
  final IconData icon;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(AppDimensions.radiusS),
      child: Container(
        width: 36,
        height: 36,
        decoration: BoxDecoration(
          border: Border.all(
            color: onTap != null ? AppColors.primary : AppColors.cardBorder,
          ),
          borderRadius: BorderRadius.circular(AppDimensions.radiusS),
        ),
        child: Icon(
          icon,
          size: 18,
          color: onTap != null ? AppColors.primary : AppColors.textSecondary,
        ),
      ),
    );
  }
}
