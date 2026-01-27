import '../data_source/main_remote_data_source.dart';
import 'main_repository.dart';

class MainRepositoryImpl implements MainRepository {
  final MainRemoteDataSource _dataSource;

  MainRepositoryImpl(this._dataSource);

  @override
  Future<void> sendPostingData(Map<String, dynamic> data) async {
    await _dataSource.postPostingData(data);
  }
}
