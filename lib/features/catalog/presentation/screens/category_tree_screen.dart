import 'package:ansor_market_mobile/core/theme/app_colors.dart';
import 'package:ansor_market_mobile/core/theme/app_dimensions.dart';
import 'package:ansor_market_mobile/core/utils/image_url_helper.dart';
import 'package:ansor_market_mobile/features/catalog/domain/models/category_model.dart';
import 'package:ansor_market_mobile/features/catalog/presentation/providers/category_provider.dart';
import 'package:ansor_market_mobile/features/catalog/presentation/screens/product_list_screen.dart';
import 'package:ansor_market_mobile/shared/widgets/error_view.dart';
import 'package:ansor_market_mobile/shared/widgets/shimmer_box.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class CategoryTreeScreen extends ConsumerWidget {
  const CategoryTreeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final categories = ref.watch(categoryTreeProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Categories')),
      body: categories.when(
        data: (cats) => RefreshIndicator(
          onRefresh: () async => ref.invalidate(categoryTreeProvider),
          child: ListView.builder(
            padding: const EdgeInsets.all(AppDimensions.paddingM),
            itemCount: cats.length,
            itemBuilder: (context, i) => _CategoryTile(category: cats[i])
                .animate()
                .fadeIn(duration: 300.ms, delay: (i * 40).ms)
                .slideX(begin: 0.05),
          ),
        ),
        loading: () => _ShimmerList(),
        error: (e, _) => ErrorView(
          message: e.toString(),
          onRetry: () => ref.invalidate(categoryTreeProvider),
        ),
      ),
    );
  }
}

class _CategoryTile extends StatefulWidget {
  const _CategoryTile({required this.category});
  final CategoryModel category;

  @override
  State<_CategoryTile> createState() => _CategoryTileState();
}

class _CategoryTileState extends State<_CategoryTile> {
  bool _expanded = false;

  @override
  Widget build(BuildContext context) {
    final hasChildren = widget.category.children.isNotEmpty;

    return Card(
      margin: const EdgeInsets.only(bottom: AppDimensions.paddingS),
      child: Column(
        children: [
          ListTile(
            leading: widget.category.imageKey != null
                ? ClipRRect(
                    borderRadius:
                        BorderRadius.circular(AppDimensions.radiusS),
                    child: CachedNetworkImage(
                      imageUrl:
                          ImageUrlHelper.buildThumbnail(widget.category.imageKey!),
                      width: 48,
                      height: 48,
                      fit: BoxFit.cover,
                      errorWidget: (_, __, ___) => const Icon(
                        Icons.category_outlined,
                        color: AppColors.textSecondary,
                      ),
                    ),
                  )
                : const Icon(Icons.category_outlined,
                    color: AppColors.primary),
            title: Text(
              widget.category.name,
              style: Theme.of(context).textTheme.titleMedium,
            ),
            trailing: hasChildren
                ? AnimatedRotation(
                    turns: _expanded ? 0.5 : 0,
                    duration: const Duration(milliseconds: 200),
                    child: const Icon(Icons.expand_more_rounded),
                  )
                : const Icon(Icons.chevron_right_rounded,
                    color: AppColors.textSecondary),
            onTap: () {
              if (hasChildren) {
                setState(() => _expanded = !_expanded);
              } else {
                Navigator.of(context).push(
                  MaterialPageRoute<void>(
                    builder: (_) => ProductListScreen(
                      categoryId: widget.category.id,
                      categoryName: widget.category.name,
                    ),
                  ),
                );
              }
            },
          ),
          AnimatedSize(
            duration: const Duration(milliseconds: 250),
            curve: Curves.easeInOut,
            child: _expanded
                ? Column(
                    children: widget.category.children
                        .map(
                          (sub) => ListTile(
                            contentPadding: const EdgeInsets.only(
                              left: 72,
                              right: AppDimensions.paddingM,
                            ),
                            title: Text(sub.name),
                            trailing: const Icon(Icons.chevron_right_rounded,
                                color: AppColors.textSecondary),
                            onTap: () => Navigator.of(context).push(
                              MaterialPageRoute<void>(
                                builder: (_) => ProductListScreen(
                                  categoryId: sub.id,
                                  categoryName: sub.name,
                                ),
                              ),
                            ),
                          ),
                        )
                        .toList(),
                  )
                : const SizedBox.shrink(),
          ),
        ],
      ),
    );
  }
}

class _ShimmerList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      padding: const EdgeInsets.all(AppDimensions.paddingM),
      itemCount: 8,
      separatorBuilder: (_, __) =>
          const SizedBox(height: AppDimensions.paddingS),
      itemBuilder: (_, __) =>
          const ShimmerBox(width: double.infinity, height: 64),
    );
  }
}
