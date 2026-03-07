import 'package:auto_posting_web/presentation/main/data/repositories/main_repository.dart';

class GetUserHistoryDateListUseCase {
  final MainRepository _repository;

  GetUserHistoryDateListUseCase(this._repository);

  Future<dynamic> execute(String userId) {
    return _repository.getUserHistoryDateList(userId);
  }
}
