import 'package:ansor_market_mobile/core/theme/app_colors.dart';
import 'package:ansor_market_mobile/core/theme/app_dimensions.dart';
import 'package:ansor_market_mobile/core/utils/currency_formatter.dart';
import 'package:ansor_market_mobile/core/utils/image_url_helper.dart';
import 'package:ansor_market_mobile/features/catalog/domain/models/product_model.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animate/flutter_animate.dart';

class ProductCard extends StatefulWidget {
  const ProductCard({
    super.key,
    required this.product,
    this.onTap,
    this.onAddToCart,
  });

  final ProductModel product;
  final VoidCallback? onTap;
  final VoidCallback? onAddToCart;

  @override
  State<ProductCard> createState() => _ProductCardState();
}

class _ProductCardState extends State<ProductCard> {
  bool _addedFeedback = false;

  String? get _mainImageKey {
    final main = widget.product.images
        .where((i) => i.isMain)
        .firstOrNull;
    return main?.imageKey ?? widget.product.images.firstOrNull?.imageKey;
  }

  void _handleAddToCart() {
    HapticFeedback.mediumImpact();
    setState(() => _addedFeedback = true);
    widget.onAddToCart?.call();
    Future<void>.delayed(const Duration(milliseconds: 1200), () {
      if (mounted) setState(() => _addedFeedback = false);
    });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: widget.onTap,
      child: Card(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Hero(
                tag: 'product_${widget.product.id}',
                child: ClipRRect(
                  borderRadius: const BorderRadius.vertical(
                    top: Radius.circular(AppDimensions.radiusM),
                  ),
                  child: _mainImageKey != null
                      ? CachedNetworkImage(
                          imageUrl: ImageUrlHelper.build(_mainImageKey!),
                          fit: BoxFit.cover,
                          width: double.infinity,
                          placeholder: (_, __) => Container(
                            color: AppColors.shimmerBase,
                          ),
                          errorWidget: (_, __, ___) => const _ImagePlaceholder(),
                        )
                      : const _ImagePlaceholder(),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(AppDimensions.paddingS),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.product.name,
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          CurrencyFormatter.format(widget.product.price),
                          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                color: AppColors.primary,
                                fontWeight: FontWeight.w700,
                              ),
                        ),
                      ),
                      GestureDetector(
                        onTap: widget.onAddToCart != null ? _handleAddToCart : null,
                        child: AnimatedSwitcher(
                          duration: const Duration(milliseconds: 300),
                          child: _addedFeedback
                              ? const Icon(
                                  Icons.check_circle,
                                  color: AppColors.success,
                                  size: 28,
                                  key: ValueKey('check'),
                                ).animate().scale(begin: const Offset(0.5, 0.5))
                              : Container(
                                  key: const ValueKey('add'),
                                  width: 28,
                                  height: 28,
                                  decoration: BoxDecoration(
                                    color: AppColors.primary,
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: const Icon(
                                    Icons.add,
                                    color: Colors.white,
                                    size: 18,
                                  ),
                                ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ImagePlaceholder extends StatelessWidget {
  const _ImagePlaceholder();

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColors.background,
      child: const Center(
        child: Icon(
          Icons.image_outlined,
          color: AppColors.textSecondary,
          size: 48,
        ),
      ),
    );
  }
}
