import 'package:auto_posting_web/presentation/register/data/repositories/regist_repository.dart';

class SendRegistDataUseCase {
  final RegistRepository _repository;

  SendRegistDataUseCase(this._repository);

  Future<dynamic> execute(Map<String, dynamic> data) async {
    return await _repository.sendPostRegist(data);
  }
}
