import '../data_source/main_remote_data_source.dart';
import 'main_repository.dart';

class MainRepositoryImpl implements MainRepository {
  final MainRemoteDataSource _dataSource;

  MainRepositoryImpl(this._dataSource);

  @override
  Future<dynamic> sendPostingData(Map<String, dynamic> data) async {
    // 반드시 return이 있어야 DataSource에서 받은 값을 뷰모델까지 전달합니다.
    return await _dataSource.postPostingData(data);
  }

  @override
  Stream<String> getLogStream(String userId) {
    return _dataSource.subscribeLogStream(userId); // 스트림 연결
  }

  @override
  Future<dynamic> sendStopWorking(String userId) async {
    return await _dataSource.postStopWorking(userId);
  }

  @override
  Future<dynamic> sendIsWorking(String userId) async {
    return await _dataSource.postIsWorking(userId);
  }

  @override
  Future<dynamic> fetchCredentials(int userId) {
    return _dataSource.getCredentials(userId);
  }

  @override
  Future<bool> deleteCredential({
    required int ownerId,
    required String loginId,
  }) async {
    return await _dataSource.deleteCredential(
      ownerId: ownerId,
      loginId: loginId,
    );
  }

  @override
  Future<dynamic> getNowUserHistory(String userId) {
    return _dataSource.postNowUserHistory(userId);
  }

  @override
  Future<dynamic> getUserHistory(String userId, String date) {
    return _dataSource.postUserHistory(userId, date);
  }

  @override
  Future<dynamic> getUserHistoryDateList(String userId) {
    return _dataSource.postUserHistoryDateList(userId);
  }
}
