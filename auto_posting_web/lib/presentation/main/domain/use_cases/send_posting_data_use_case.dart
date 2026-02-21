import '../../data/repositories/main_repository.dart';

class SendPostingDataUseCase {
  final MainRepository _repository;

  SendPostingDataUseCase(this._repository);

  Future<dynamic> execute(Map<String, dynamic> data) async {
    return await _repository.sendPostingData(data);
  }

  Future<dynamic> executeIsWorking(String userId) async {
    return await _repository.sendIsWorking(userId);
  }

  Future<dynamic> executeStopWorking(String userId) async {
    return await _repository.sendStopWorking(userId);
  }
}
