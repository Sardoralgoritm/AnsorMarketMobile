import 'package:ansor_market_mobile/features/branches/domain/models/branch_model.dart';
import 'package:ansor_market_mobile/features/branches/presentation/providers/branches_provider.dart';
import 'package:ansor_market_mobile/features/branches/presentation/screens/branch_list_screen.dart';
import 'package:ansor_market_mobile/features/branches/presentation/screens/branch_map_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class BranchesScreen extends ConsumerStatefulWidget {
  const BranchesScreen({super.key});

  @override
  ConsumerState<BranchesScreen> createState() => _BranchesScreenState();
}

class _BranchesScreenState extends ConsumerState<BranchesScreen> {
  BranchModel? _focusedBranch;

  @override
  Widget build(BuildContext context) {
    final viewMode = ref.watch(branchViewModeNotifierProvider);
    final isMap = viewMode == BranchViewMode.map;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Branches'),
        actions: [
          IconButton(
            icon: const Icon(Icons.near_me_rounded),
            tooltip: 'Near Me',
            onPressed: () {
              ref
                  .read(nearbyBranchesNotifierProvider.notifier)
                  .loadNearby();
              if (!isMap) {
                ref.read(branchViewModeNotifierProvider.notifier).setMode(
                      BranchViewMode.list,
                    );
              }
            },
          ),
          Padding(
            padding: const EdgeInsets.only(right: 8),
            child: SegmentedButton<BranchViewMode>(
              segments: const [
                ButtonSegment(
                  value: BranchViewMode.list,
                  icon: Icon(Icons.list_rounded, size: 18),
                ),
                ButtonSegment(
                  value: BranchViewMode.map,
                  icon: Icon(Icons.map_rounded, size: 18),
                ),
              ],
              selected: {viewMode},
              onSelectionChanged: (s) => ref
                  .read(branchViewModeNotifierProvider.notifier)
                  .setMode(s.first),
              style: const ButtonStyle(
                visualDensity: VisualDensity.compact,
              ),
            ),
          ),
        ],
      ),
      body: AnimatedSwitcher(
        duration: const Duration(milliseconds: 300),
        child: isMap
            ? BranchMapView(
                key: const ValueKey('map'),
                focusedBranch: _focusedBranch,
              )
            : BranchListView(
                key: const ValueKey('list'),
                onViewOnMap: (branch) {
                  setState(() => _focusedBranch = branch);
                  ref
                      .read(branchViewModeNotifierProvider.notifier)
                      .setMode(BranchViewMode.map);
                },
              ),
      ),
    );
  }
}
