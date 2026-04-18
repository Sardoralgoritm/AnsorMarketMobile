import 'package:ansor_market_mobile/features/branches/data/branches_remote_datasource.dart';
import 'package:ansor_market_mobile/features/branches/domain/models/branch_model.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'branches_repository.g.dart';

class BranchesRepository {
  BranchesRepository(this._dataSource);

  final BranchesRemoteDataSource _dataSource;

  Future<List<BranchModel>> getAllBranches() async {
    final result = await _dataSource.getBranchList(page: 1, pageSize: 50);
    return result.items;
  }

  Future<BranchModel> getBranchById(String id) =>
      _dataSource.getBranchById(id);

  Future<List<BranchModel>> getBranchesInRange({
    required double lat,
    required double lng,
  }) =>
      _dataSource.getBranchesInRange(lat: lat, lng: lng);
}

@riverpod
BranchesRepository branchesRepository(Ref ref) {
  return BranchesRepository(ref.watch(branchesRemoteDataSourceProvider));
}
