import 'package:auto_posting_web/presentation/main/data/repositories/main_repository.dart';

class GetUserHistoryListUseCase {
  final MainRepository _repository;

  GetUserHistoryListUseCase(this._repository);

  Future<dynamic> execute(String userId, String date) {
    return _repository.getUserHistory(userId, date);
  }
}
