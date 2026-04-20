import 'package:ansor_market_mobile/core/theme/app_colors.dart';
import 'package:ansor_market_mobile/core/theme/app_dimensions.dart';
import 'package:ansor_market_mobile/features/cart/presentation/providers/cart_provider.dart';
import 'package:ansor_market_mobile/features/catalog/presentation/providers/product_provider.dart';
import 'package:ansor_market_mobile/shared/widgets/error_view.dart';
import 'package:ansor_market_mobile/shared/widgets/product_card.dart';
import 'package:ansor_market_mobile/shared/widgets/shimmer_box.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class ProductListScreen extends ConsumerStatefulWidget {
  const ProductListScreen({
    super.key,
    this.categoryId,
    this.categoryName,
  });

  final String? categoryId;
  final String? categoryName;

  @override
  ConsumerState<ProductListScreen> createState() => _ProductListScreenState();
}

class _ProductListScreenState extends ConsumerState<ProductListScreen> {
  final _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(productListNotifierProvider.notifier).applyFilters(
            categoryId: widget.categoryId,
          );
    });
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent * 0.8) {
      ref.read(productListNotifierProvider.notifier).loadMore();
    }
  }

  @override
  Widget build(BuildContext context) {
    final products = ref.watch(productListNotifierProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.categoryName ?? 'Products'),
        actions: [
          IconButton(
            icon: const Icon(Icons.filter_list_rounded),
            onPressed: () => _showFilterSheet(context),
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: () async => ref
            .read(productListNotifierProvider.notifier)
            .load(reset: true),
        child: products.when(
          data: (items) {
            if (items.isEmpty) {
              return const Center(child: Text('No products found'));
            }
            return GridView.builder(
              controller: _scrollController,
              padding: const EdgeInsets.all(AppDimensions.paddingM),
              itemCount: items.length,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                childAspectRatio: 0.72,
                mainAxisSpacing: AppDimensions.paddingM,
                crossAxisSpacing: AppDimensions.paddingM,
              ),
              itemBuilder: (context, i) {
                final product = items[i];
                return ProductCard(
                  product: product,
                  onTap: () => context.push('/product/${product.id}'),
                  onAddToCart: () => ref
                      .read(cartNotifierProvider.notifier)
                      .addItem(product.id),
                )
                    .animate()
                    .fadeIn(
                        duration: 300.ms,
                        delay: Duration(milliseconds: (i * 30).clamp(0, 300)))
                    .slideY(begin: 0.1);
              },
            );
          },
          loading: () => GridView.builder(
            padding: const EdgeInsets.all(AppDimensions.paddingM),
            itemCount: 6,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              childAspectRatio: 0.72,
              mainAxisSpacing: AppDimensions.paddingM,
              crossAxisSpacing: AppDimensions.paddingM,
            ),
            itemBuilder: (_, __) =>
                const ShimmerBox(width: double.infinity, height: double.infinity),
          ),
          error: (e, _) => ErrorView(
            message: e.toString(),
            onRetry: () => ref
                .read(productListNotifierProvider.notifier)
                .load(reset: true),
          ),
        ),
      ),
    );
  }

  void _showFilterSheet(BuildContext context) {
    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(AppDimensions.radiusL),
        ),
      ),
      builder: (_) => const _FilterSheet(),
    );
  }
}

class _FilterSheet extends ConsumerStatefulWidget {
  const _FilterSheet();

  @override
  ConsumerState<_FilterSheet> createState() => _FilterSheetState();
}

class _FilterSheetState extends ConsumerState<_FilterSheet> {
  RangeValues _priceRange = const RangeValues(0, 10000000);
  String _sortBy = 'default';

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        left: AppDimensions.paddingL,
        right: AppDimensions.paddingL,
        top: AppDimensions.paddingL,
        bottom: MediaQuery.of(context).viewInsets.bottom +
            AppDimensions.paddingL,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Filters', style: Theme.of(context).textTheme.titleMedium),
              TextButton(
                onPressed: () {
                  setState(() {
                    _priceRange = const RangeValues(0, 10000000);
                    _sortBy = 'default';
                  });
                },
                child: const Text('Reset'),
              ),
            ],
          ),
          const SizedBox(height: AppDimensions.paddingM),
          Text('Price Range', style: Theme.of(context).textTheme.bodyLarge),
          RangeSlider(
            values: _priceRange,
            min: 0,
            max: 10000000,
            divisions: 100,
            activeColor: AppColors.primary,
            labels: RangeLabels(
              '${(_priceRange.start / 1000).toStringAsFixed(0)}K',
              '${(_priceRange.end / 1000).toStringAsFixed(0)}K',
            ),
            onChanged: (v) => setState(() => _priceRange = v),
          ),
          const SizedBox(height: AppDimensions.paddingM),
          Text('Sort By', style: Theme.of(context).textTheme.bodyLarge),
          const SizedBox(height: AppDimensions.paddingS),
          Wrap(
            spacing: AppDimensions.paddingS,
            children: [
              for (final option in [
                ('default', 'Default'),
                ('price_asc', 'Price ↑'),
                ('price_desc', 'Price ↓'),
                ('newest', 'Newest'),
              ])
                ChoiceChip(
                  label: Text(option.$2),
                  selected: _sortBy == option.$1,
                  selectedColor: AppColors.primary,
                  labelStyle: TextStyle(
                    color: _sortBy == option.$1
                        ? Colors.white
                        : AppColors.textPrimary,
                  ),
                  onSelected: (_) => setState(() => _sortBy = option.$1),
                ),
            ],
          ),
          const SizedBox(height: AppDimensions.paddingL),
          ElevatedButton(
            onPressed: () {
              ref.read(productListNotifierProvider.notifier).applyFilters(
                    minPrice: _priceRange.start > 0 ? _priceRange.start : null,
                    maxPrice: _priceRange.end < 10000000
                        ? _priceRange.end
                        : null,
                    sortBy: _sortBy == 'default' ? null : _sortBy,
                  );
              Navigator.of(context).pop();
            },
            child: const Text('Apply Filters'),
          ),
        ],
      ),
    );
  }
}
