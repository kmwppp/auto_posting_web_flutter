import '../../data/repositories/main_repository.dart';

class SendPostingDataUseCase {
  final MainRepository _repository;

  SendPostingDataUseCase(this._repository);

  Future<void> execute(Map<String, dynamic> data) async {
    return await _repository.sendPostingData(data);
  }
}
