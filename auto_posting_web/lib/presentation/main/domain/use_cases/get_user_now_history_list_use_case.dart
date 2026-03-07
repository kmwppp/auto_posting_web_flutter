import 'package:auto_posting_web/presentation/main/data/repositories/main_repository.dart';

class GetUserNowHistoryListUseCase {
  final MainRepository _repository;

  GetUserNowHistoryListUseCase(this._repository);

  Future<dynamic> execute(String userId) {
    return _repository.getNowUserHistory(userId);
  }
}
