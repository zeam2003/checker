import 'package:checker/features/checks/domain/models/check_model.dart';

abstract class CheckRepository {
  Future<CheckModel> createCheck(
    String ticketId, {
    required String type,
    required int glpiID,
    required int createdBy,
  });
}