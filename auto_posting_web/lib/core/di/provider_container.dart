// 1. Dio
import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../presentation/main/data/data_source/main_remote_data_source.dart';
import '../../presentation/main/data/repositories/main_repository.dart';
import '../../presentation/main/data/repositories/main_repository_impl.dart';
import '../../presentation/main/domain/use_cases/send_posting_data_use_case.dart';

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
