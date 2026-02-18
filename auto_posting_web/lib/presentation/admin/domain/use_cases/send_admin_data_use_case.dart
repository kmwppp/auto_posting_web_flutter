import 'package:auto_posting_web/presentation/admin/data/repositories/admin_repository.dart';

class SendAdminDataUseCase {
  final AdminRepository _repository;

  SendAdminDataUseCase(this._repository);

  Future<dynamic> execute(Map<String, dynamic> data) async {
    return await _repository.postUserStatusData(data);
  }

  Future<dynamic> getUserList() async {
    return await _repository.getUserList();
  }

  Future<dynamic> getUserSuccessLogs(Map<String, dynamic> data) async {
    return await _repository.postUserSuccessLogs(data);
  }
}
