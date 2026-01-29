// 1. Dio
import 'package:auto_posting_web/presentation/login/data/data_source/login_remote_data_source.dart';
import 'package:auto_posting_web/presentation/login/data/repositories/login_repository.dart';
import 'package:auto_posting_web/presentation/login/data/repositories/login_repository_impl.dart';
import 'package:auto_posting_web/presentation/login/domain/use_cases/send_login_data_use_case.dart';
import 'package:auto_posting_web/presentation/register/data/repositories/regist_repository.dart';
import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../presentation/main/data/data_source/main_remote_data_source.dart';
import '../../presentation/main/data/repositories/main_repository.dart';
import '../../presentation/main/data/repositories/main_repository_impl.dart';
import '../../presentation/main/domain/use_cases/send_posting_data_use_case.dart';
import '../../presentation/main/domain/use_cases/subscribe_log_use_case.dart';
import '../../presentation/register/data/data_source/regist_remote_data_source.dart';
import '../../presentation/register/data/repositories/regist_repository_impl.dart';
import '../../presentation/register/domain/use_cases/send_regist_data_use_case.dart';

// 1. Dio
final dioProvider = Provider((ref) => Dio());

// 2. Data Source
final mainRemoteDataSourceProvider = Provider(
  (ref) => MainRemoteDataSource(ref.read(dioProvider)),
);

// 3. Repository
final mainRepositoryProvider = Provider<MainRepository>(
  (ref) => MainRepositoryImpl(ref.read(mainRemoteDataSourceProvider)),
);

// 4. UseCase
final sendPostingDataUseCaseProvider = Provider(
  (ref) => SendPostingDataUseCase(ref.read(mainRepositoryProvider)),
);

// 5. [추가] UseCase (신규: 실시간 로그 구독)
final subscribeLogUseCaseProvider = Provider(
  (ref) => SubscribeLogUseCase(ref.read(mainRepositoryProvider)),
);

/// Login
// 1. Login Data Source
final loginRemoteDataSourceProvider = Provider(
  (ref) => LoginRemoteDataSource(ref.read(dioProvider)),
);

// 2. Repository
final loginRepositoryProvider = Provider<LoginRepository>(
  (ref) => LoginRepositoryImpl(ref.read(loginRemoteDataSourceProvider)),
);

// 3. UseCase
final loginDataUseCaseProvider = Provider(
  (ref) => SendLoginDataUseCase(ref.read(loginRepositoryProvider)),
);

/// Regist
// 1. Login Data Source
final registRemoteDataSourceProvider = Provider(
  (ref) => RegistRemoteDataSource(ref.read(dioProvider)),
);

// 2. Repository
final registRepositoryProvider = Provider<RegistRepository>(
  (ref) => RegistRepositoryImpl(ref.read(registRemoteDataSourceProvider)),
);

// 3. UseCase
final registDataUseCaseProvider = Provider(
  (ref) => SendRegistDataUseCase(ref.read(registRepositoryProvider)),
);
