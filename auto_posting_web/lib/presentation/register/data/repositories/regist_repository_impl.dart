import 'package:auto_posting_web/presentation/register/data/data_source/regist_remote_data_source.dart';
import 'package:auto_posting_web/presentation/register/data/repositories/regist_repository.dart';

class RegistRepositoryImpl implements RegistRepository {
  final RegistRemoteDataSource _dataSource;

  RegistRepositoryImpl(this._dataSource);

  @override
  Future<dynamic> sendPostRegist(Map<String, dynamic> data) async {
    return await _dataSource.postRegistData(data);
  }
}
