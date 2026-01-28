import 'package:auto_posting_web/presentation/main/data/repositories/main_repository.dart';

class SubscribeLogUseCase {
  final MainRepository _repository;

  SubscribeLogUseCase(this._repository);

  Stream<String> execute(String userId) {
    return _repository.getLogStream(userId);
  }
}
