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
}
