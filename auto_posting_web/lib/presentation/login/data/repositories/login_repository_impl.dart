import 'package:auto_posting_web/presentation/login/data/data_source/login_remote_data_source.dart';
import 'package:auto_posting_web/presentation/login/data/repositories/login_repository.dart';

class LoginRepositoryImpl implements LoginRepository {
  final LoginRemoteDataSource _dataSource;

  LoginRepositoryImpl(this._dataSource);

  @override
  Future<dynamic> sendPostLogin(Map<String, dynamic> data) async {
    return await _dataSource.postLoginData(data);
  }
}
