import '../../data/repositories/main_repository.dart';

class DeleteCredentialUseCase {
  final MainRepository repository;

  DeleteCredentialUseCase(this.repository);

  Future<bool> execute({required int ownerId, required String loginId}) async {
    return await repository.deleteCredential(
      ownerId: ownerId,
      loginId: loginId,
    );
  }
}
