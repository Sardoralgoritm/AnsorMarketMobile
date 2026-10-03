import 'package:ansor_market_mobile/core/theme/app_colors.dart';
import 'package:ansor_market_mobile/core/theme/app_dimensions.dart';
import 'package:ansor_market_mobile/features/branches/domain/models/branch_model.dart';
import 'package:ansor_market_mobile/features/branches/presentation/providers/branches_provider.dart';
import 'package:ansor_market_mobile/shared/widgets/error_view.dart';
import 'package:ansor_market_mobile/shared/widgets/shimmer_box.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class BranchListView extends ConsumerWidget {
  const BranchListView({super.key, this.onViewOnMap});

  final void Function(BranchModel branch)? onViewOnMap;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final branchesAsync = ref.watch(allBranchesProvider);
    final nearby = ref.watch(nearbyBranchesNotifierProvider);

    return branchesAsync.when(
      data: (branches) => RefreshIndicator(
        onRefresh: () async => ref.invalidate(allBranchesProvider),
        child: ListView.builder(
          padding: const EdgeInsets.all(AppDimensions.paddingM),
          itemCount: branches.length,
          itemBuilder: (context, i) {
            final branch = branches[i];
            final isNearby = nearby.maybeWhen(
              data: (list) => list.any((b) => b.id == branch.id),
              orElse: () => false,
            );
            return _BranchCard(
              branch: branch,
              isNearby: isNearby,
              onViewOnMap: () => onViewOnMap?.call(branch),
            )
                .animate()
                .fadeIn(duration: 300.ms, delay: Duration(milliseconds: i * 40))
                .slideY(begin: 0.05);
          },
        ),
      ),
      loading: () => _BranchListSkeleton(),
      error: (e, _) => ErrorView(
        message: e.toString(),
        onRetry: () => ref.invalidate(allBranchesProvider),
      ),
    );
  }
}

class _BranchCard extends StatelessWidget {
  const _BranchCard({
    required this.branch,
    required this.isNearby,
    required this.onViewOnMap,
  });

  final BranchModel branch;
  final bool isNearby;
  final VoidCallback onViewOnMap;

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: AppDimensions.paddingS),
      child: Padding(
        padding: const EdgeInsets.all(AppDimensions.paddingM),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(
                    branch.name,
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                ),
                if (isNearby)
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: AppDimensions.paddingS,
                      vertical: 2,
                    ),
                    decoration: BoxDecoration(
                      color: AppColors.success.withAlpha(30),
                      borderRadius:
                          BorderRadius.circular(AppDimensions.radiusS),
                    ),
                    child: const Text(
                      'Nearby',
                      style: TextStyle(
                        color: AppColors.success,
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
              ],
            ),
            const SizedBox(height: AppDimensions.paddingXS),
            Text(
              '${branch.city}, ${branch.address}',
              style: Theme.of(context)
                  .textTheme
                  .bodyMedium
                  ?.copyWith(color: AppColors.textSecondary),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
            if (branch.workingHours != null) ...[
              const SizedBox(height: AppDimensions.paddingXS),
              Row(
                children: [
                  const Icon(Icons.access_time_rounded,
                      size: 14, color: AppColors.textSecondary),
                  const SizedBox(width: 4),
                  Text(
                    branch.workingHours!,
                    style: Theme.of(context)
                        .textTheme
                        .labelSmall
                        ?.copyWith(color: AppColors.textSecondary),
                  ),
                ],
              ),
            ],
            const SizedBox(height: AppDimensions.paddingS),
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppDimensions.paddingS,
                    vertical: 3,
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.primary.withAlpha(20),
                    borderRadius:
                        BorderRadius.circular(AppDimensions.radiusS),
                  ),
                  child: Text(
                    'Delivers within ${branch.deliveryRadiusKm.toStringAsFixed(0)} km',
                    style: const TextStyle(
                      color: AppColors.primary,
                      fontSize: 11,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                const Spacer(),
                TextButton(
                  onPressed: onViewOnMap,
                  child: const Text('View on Map'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _BranchListSkeleton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      padding: const EdgeInsets.all(AppDimensions.paddingM),
      itemCount: 5,
      separatorBuilder: (_, __) =>
          const SizedBox(height: AppDimensions.paddingS),
      itemBuilder: (_, __) =>
          const ShimmerBox(width: double.infinity, height: 120),
    );
  }
}
