import 'package:auto_posting_web/presentation/admin/admin_state.dart';
import 'package:auto_posting_web/presentation/admin/admin_viewmodel.dart';
import 'package:auto_posting_web/presentation/admin/data/data_source/admin_remote_data_source.dart';
import 'package:auto_posting_web/presentation/admin/data/repositories/admin_repository.dart';
import 'package:auto_posting_web/presentation/admin/data/repositories/admin_repository_impl.dart';
import 'package:auto_posting_web/presentation/admin/domain/use_cases/send_admin_data_use_case.dart';
import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final adminViewModelProvider = NotifierProvider<AdminViewModel, AdminState>(
  AdminViewModel.new,
);

final dioProvider = Provider((ref) => Dio());

final adminRemoteDataSourceProvider = Provider(
  (ref) => AdminRemoteDataSource(ref.read(dioProvider)),
);

final adminRepositoryProvider = Provider<AdminRepository>(
  (ref) => AdminRepositoryImpl(ref.read(adminRemoteDataSourceProvider)),
);

final adminDataUseCaseProvider = Provider(
  (ref) => SendAdminDataUseCase(ref.read(adminRepositoryProvider)),
);
