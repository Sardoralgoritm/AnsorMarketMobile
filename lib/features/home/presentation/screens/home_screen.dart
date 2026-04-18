import 'package:ansor_market_mobile/core/theme/app_colors.dart';
import 'package:ansor_market_mobile/core/theme/app_dimensions.dart';
import 'package:ansor_market_mobile/features/catalog/presentation/providers/category_provider.dart';
import 'package:ansor_market_mobile/features/catalog/presentation/providers/product_provider.dart';
import 'package:ansor_market_mobile/features/cart/presentation/providers/cart_provider.dart';
import 'package:ansor_market_mobile/shared/widgets/category_chip.dart';
import 'package:ansor_market_mobile/shared/widgets/error_view.dart';
import 'package:ansor_market_mobile/shared/widgets/product_card.dart';
import 'package:ansor_market_mobile/shared/widgets/shimmer_box.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  String? _selectedCategoryId;
  final _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(productListNotifierProvider.notifier).load(reset: true);
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
    final categories = ref.watch(categoryTreeProvider);
    final products = ref.watch(productListNotifierProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('AnsorMarket'),
        actions: [
          IconButton(
            icon: const Icon(Icons.search_rounded),
            onPressed: () {},
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          ref.invalidate(categoryTreeProvider);
          await ref
              .read(productListNotifierProvider.notifier)
              .load(reset: true);
        },
        child: CustomScrollView(
          controller: _scrollController,
          slivers: [
            // Category chips
            SliverToBoxAdapter(
              child: SizedBox(
                height: 52,
                child: categories.when(
                  data: (cats) => ListView.separated(
                    scrollDirection: Axis.horizontal,
                    padding: const EdgeInsets.symmetric(
                      horizontal: AppDimensions.paddingM,
                      vertical: AppDimensions.paddingS,
                    ),
                    itemCount: cats.length + 1,
                    separatorBuilder: (_, __) =>
                        const SizedBox(width: AppDimensions.paddingS),
                    itemBuilder: (_, i) {
                      if (i == 0) {
                        return CategoryChip(
                          label: 'All',
                          isSelected: _selectedCategoryId == null,
                          onTap: () {
                            setState(() => _selectedCategoryId = null);
                            ref
                                .read(productListNotifierProvider.notifier)
                                .applyFilters(categoryId: null);
                          },
                        )
                            .animate()
                            .fadeIn(duration: 300.ms, delay: (i * 30).ms);
                      }
                      final cat = cats[i - 1];
                      return CategoryChip(
                        label: cat.name,
                        isSelected: _selectedCategoryId == cat.id,
                        onTap: () {
                          setState(() => _selectedCategoryId = cat.id);
                          ref
                              .read(productListNotifierProvider.notifier)
                              .applyFilters(categoryId: cat.id);
                        },
                      )
                          .animate()
                          .fadeIn(duration: 300.ms, delay: (i * 30).ms);
                    },
                  ),
                  loading: () => _shimmerChips(),
                  error: (_, __) => const SizedBox.shrink(),
                ),
              ),
            ),
            // Products grid
            products.when(
              data: (items) {
                if (items.isEmpty) {
                  return const SliverFillRemaining(
                    child: Center(
                      child: Text('No products found'),
                    ),
                  );
                }
                return SliverPadding(
                  padding: const EdgeInsets.all(AppDimensions.paddingM),
                  sliver: SliverGrid(
                    delegate: SliverChildBuilderDelegate(
                      (context, i) {
                        final product = items[i];
                        return ProductCard(
                          product: product,
                          onTap: () => context.push(
                            '/products/${product.id}',
                          ),
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
                      childCount: items.length,
                    ),
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      childAspectRatio: 0.72,
                      mainAxisSpacing: AppDimensions.paddingM,
                      crossAxisSpacing: AppDimensions.paddingM,
                    ),
                  ),
                );
              },
              loading: () => SliverPadding(
                padding: const EdgeInsets.all(AppDimensions.paddingM),
                sliver: SliverGrid(
                  delegate: SliverChildBuilderDelegate(
                    (_, __) => const ShimmerBox(width: double.infinity, height: double.infinity),
                    childCount: 6,
                  ),
                  gridDelegate:
                      const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    childAspectRatio: 0.72,
                    mainAxisSpacing: AppDimensions.paddingM,
                    crossAxisSpacing: AppDimensions.paddingM,
                  ),
                ),
              ),
              error: (e, _) => SliverFillRemaining(
                child: ErrorView(
                  message: e.toString(),
                  onRetry: () => ref
                      .read(productListNotifierProvider.notifier)
                      .load(reset: true),
                ),
              ),
            ),
            // Load more indicator
            SliverToBoxAdapter(
              child: products.maybeWhen(
                data: (_) =>
                    ref.watch(productListNotifierProvider.notifier).hasMore
                        ? const Padding(
                            padding: EdgeInsets.all(AppDimensions.paddingM),
                            child: Center(
                              child: CircularProgressIndicator(
                                color: AppColors.primary,
                              ),
                            ),
                          )
                        : const SizedBox(height: AppDimensions.paddingL),
                orElse: () => const SizedBox.shrink(),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _shimmerChips() {
    return ListView.separated(
      scrollDirection: Axis.horizontal,
      padding: const EdgeInsets.symmetric(
        horizontal: AppDimensions.paddingM,
        vertical: AppDimensions.paddingS,
      ),
      itemCount: 5,
      separatorBuilder: (_, __) => const SizedBox(width: AppDimensions.paddingS),
      itemBuilder: (_, __) => const ShimmerBox(width: 80, height: 36, borderRadius: AppDimensions.radiusXL),
    );
  }
}
