import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/data_source/wordpress_remote_data_source.dart';

final dioProvider = Provider((ref) => Dio());

final wordpressRemoteDataSourceProvider = Provider((ref) {
  final dio = ref.read(dioProvider);
  return WordpressRemoteDataSource(dio);
});
