import 'package:auto_posting_web/presentation/admin/data/data_source/admin_remote_data_source.dart';
import 'package:auto_posting_web/presentation/admin/data/repositories/admin_repository.dart';

class AdminRepositoryImpl implements AdminRepository {
  final AdminRemoteDataSource _dataSource;

  AdminRepositoryImpl(this._dataSource);

  @override
  Future<dynamic> postUserStatusData(Map<String, dynamic> data) async {
    return await _dataSource.postUserStatusData(data);
  }

  @override
  Future<dynamic> getUserList() async {
    return await _dataSource.postUserList();
  }

  @override
  Future<dynamic> postUserSuccessLogs(Map<String, dynamic> data) async {
    return await _dataSource.postUserSuccessLogs(data);
  }
}
