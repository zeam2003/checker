import '../../domain/models/check_model.dart';
import '../../domain/repositories/check_repository.dart';
import '../datasources/check_datasource.dart';

class CheckRepositoryImpl implements CheckRepository {
  final CheckDatasource _datasource;
  final String _token;

  CheckRepositoryImpl(this._datasource, this._token);

  @override
  Future<CheckModel> createCheck(
    String ticketId, {
    required String type,
    required int glpiID,
    required int createdBy,
  }) async {
    final response = await _datasource.createCheck(
      ticketId,
      type: type,
      glpiID: glpiID,
      createdBy: createdBy,
      token: _token,
    );
    return CheckModel.fromJson(response);
  }
}