import 'package:auto_posting_web/presentation/login/data/repositories/login_repository.dart';

class SendLoginDataUseCase {
  final LoginRepository _repository;

  SendLoginDataUseCase(this._repository);

  Future<dynamic> execute(Map<String, dynamic> data) async {
    return await _repository.sendPostLogin(data);
  }
}
