import 'dart:io';

import 'package:ansor_market_mobile/core/theme/app_colors.dart';
import 'package:ansor_market_mobile/core/theme/app_dimensions.dart';
import 'package:ansor_market_mobile/features/branches/domain/models/branch_model.dart';
import 'package:ansor_market_mobile/features/branches/presentation/providers/branches_provider.dart';
import 'package:ansor_market_mobile/shared/widgets/error_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:latlong2/latlong.dart';
import 'package:url_launcher/url_launcher.dart';

class BranchMapView extends ConsumerStatefulWidget {
  const BranchMapView({super.key, this.focusedBranch});

  final BranchModel? focusedBranch;

  @override
  ConsumerState<BranchMapView> createState() => _BranchMapViewState();
}

class _BranchMapViewState extends ConsumerState<BranchMapView> {
  final _mapController = MapController();
  BranchModel? _selected;

  @override
  void initState() {
    super.initState();
    if (widget.focusedBranch != null) {
      _selected = widget.focusedBranch;
    }
  }

  void _openDirections(BranchModel branch) async {
    final lat = branch.latitude;
    final lng = branch.longitude;
    final uri = Platform.isIOS
        ? Uri.parse('maps:?daddr=$lat,$lng')
        : Uri.parse('geo:$lat,$lng?q=$lat,$lng');
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
    } else {
      await launchUrl(
        Uri.parse('https://maps.google.com/?daddr=$lat,$lng'),
        mode: LaunchMode.externalApplication,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final branchesAsync = ref.watch(allBranchesProvider);
    final nearby = ref.watch(nearbyBranchesNotifierProvider);

    return branchesAsync.when(
      data: (branches) {
        final nearbyIds = nearby.maybeWhen(
          data: (list) => list.map((b) => b.id).toSet(),
          orElse: () => <String>{},
        );

        return Stack(
          children: [
            FlutterMap(
              mapController: _mapController,
              options: MapOptions(
                initialCenter: branches.isNotEmpty
                    ? LatLng(branches.first.latitude,
                        branches.first.longitude)
                    : const LatLng(41.2995, 69.2401),
                initialZoom: 12,
                onTap: (_, __) => setState(() => _selected = null),
              ),
              children: [
                TileLayer(
                  urlTemplate:
                      'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                  userAgentPackageName: 'uz.ansormarket.mobile',
                ),
                MarkerLayer(
                  markers: branches.map((branch) {
                    final isSelected = _selected?.id == branch.id;
                    final isNearby = nearbyIds.contains(branch.id);
                    return Marker(
                      point: LatLng(branch.latitude, branch.longitude),
                      width: isSelected ? 48 : 36,
                      height: isSelected ? 48 : 36,
                      child: GestureDetector(
                        onTap: () {
                          setState(() => _selected = branch);
                          _mapController.move(
                            LatLng(branch.latitude, branch.longitude),
                            14,
                          );
                        },
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 200),
                          decoration: BoxDecoration(
                            color: isNearby
                                ? AppColors.secondary
                                : AppColors.primary,
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: Colors.white,
                              width: isSelected ? 3 : 2,
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withAlpha(60),
                                blurRadius: 6,
                                offset: const Offset(0, 3),
                              ),
                            ],
                          ),
                          child: const Icon(
                            Icons.store_rounded,
                            color: Colors.white,
                            size: 18,
                          ),
                        ),
                      ),
                    );
                  }).toList(),
                ),
              ],
            ),
            // FAB center on user
            Positioned(
              bottom: _selected != null ? 200 : 24,
              right: 16,
              child: FloatingActionButton.small(
                onPressed: () =>
                    ref.read(nearbyBranchesNotifierProvider.notifier).loadNearby(),
                backgroundColor: AppColors.surface,
                foregroundColor: AppColors.primary,
                child: const Icon(Icons.my_location_rounded),
              ),
            ),
            // Branch detail card
            if (_selected != null)
              Positioned(
                bottom: 0,
                left: 0,
                right: 0,
                child: _BranchDetailCard(
                  branch: _selected!,
                  onDirections: () => _openDirections(_selected!),
                  onDismiss: () => setState(() => _selected = null),
                )
                    .animate()
                    .slideY(begin: 1, duration: 300.ms, curve: Curves.easeOut),
              ),
          ],
        );
      },
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (e, _) => ErrorView(
        message: e.toString(),
        onRetry: () => ref.invalidate(allBranchesProvider),
      ),
    );
  }
}

class _BranchDetailCard extends StatelessWidget {
  const _BranchDetailCard({
    required this.branch,
    required this.onDirections,
    required this.onDismiss,
  });

  final BranchModel branch;
  final VoidCallback onDirections;
  final VoidCallback onDismiss;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(AppDimensions.paddingM),
      padding: const EdgeInsets.all(AppDimensions.paddingM),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(AppDimensions.radiusL),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha(30),
            blurRadius: 16,
            offset: const Offset(0, -4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  branch.name,
                  style: Theme.of(context).textTheme.titleMedium,
                ),
              ),
              IconButton(
                icon: const Icon(Icons.close_rounded),
                onPressed: onDismiss,
                visualDensity: VisualDensity.compact,
              ),
            ],
          ),
          Text(
            '${branch.city}, ${branch.address}',
            style: Theme.of(context)
                .textTheme
                .bodyMedium
                ?.copyWith(color: AppColors.textSecondary),
          ),
          if (branch.workingHours != null)
            Padding(
              padding: const EdgeInsets.only(top: AppDimensions.paddingXS),
              child: Row(
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
            ),
          const SizedBox(height: AppDimensions.paddingS),
          Row(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(
                    horizontal: AppDimensions.paddingS, vertical: 3),
                decoration: BoxDecoration(
                  color: AppColors.primary.withAlpha(20),
                  borderRadius:
                      BorderRadius.circular(AppDimensions.radiusS),
                ),
                child: Text(
                  'Within ${branch.deliveryRadiusKm.toStringAsFixed(0)} km',
                  style: const TextStyle(
                    color: AppColors.primary,
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              const Spacer(),
              ElevatedButton.icon(
                onPressed: onDirections,
                icon: const Icon(Icons.directions_rounded, size: 16),
                label: const Text('Directions'),
                style: ElevatedButton.styleFrom(
                  minimumSize: const Size(0, 36),
                  padding: const EdgeInsets.symmetric(
                      horizontal: AppDimensions.paddingM),
                ),
              ),
            ],
          ),
          SizedBox(height: MediaQuery.of(context).padding.bottom),
        ],
      ),
    );
  }
}
