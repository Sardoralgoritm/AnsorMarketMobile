import 'package:freezed_annotation/freezed_annotation.dart';

part 'branch_model.freezed.dart';
part 'branch_model.g.dart';

@freezed
abstract class BranchModel with _$BranchModel {
  const factory BranchModel({
    required String id,
    required String name,
    required String address,
    required String city,
    required double latitude,
    required double longitude,
    required double deliveryRadiusKm,
    String? phone,
    String? workingHours,
  }) = _BranchModel;

  factory BranchModel.fromJson(Map<String, dynamic> json) =>
      _$BranchModelFromJson(json);
}
