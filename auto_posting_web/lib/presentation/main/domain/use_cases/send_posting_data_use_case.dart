import '../../data/repositories/main_repository.dart';

class SendPostingDataUseCase {
  final MainRepository _repository;

  SendPostingDataUseCase(this._repository);

  // [수정] void를 dynamic으로 바꿉니다.
  Future<dynamic> execute(Map<String, dynamic> data) async {
    return await _repository.sendPostingData(data);
  }
}
