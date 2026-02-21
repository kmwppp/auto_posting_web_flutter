import '../../data/repositories/main_repository.dart';

class GetBlogCredentialsUseCase {
  final MainRepository _repository;

  GetBlogCredentialsUseCase(this._repository);

  Future<dynamic> execute(int userId) {
    return _repository.fetchCredentials(userId);
  }
}
