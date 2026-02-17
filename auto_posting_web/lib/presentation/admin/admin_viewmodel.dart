import 'dart:convert';

import 'package:auto_posting_web/presentation/admin/admin_provider.dart';
import 'package:auto_posting_web/presentation/admin/admin_state.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'data/models/admin_user_info.dart';

class AdminViewModel extends Notifier<AdminState> {
  @override
  AdminState build() {
    // return AdminState.initial();
    // 2. 초기 데이터(더미)를 담아서 상태 생성
    final List<Map<String, dynamic>> dummyData = [
      {"id": 1, "user_id": "user01", "full_name": "홍길동", "status": 1},
      {"id": 2, "user_id": "user02", "full_name": "김철수", "status": 0},
      {"id": 3, "user_id": "user03", "full_name": "이영희", "status": 2},
      {"id": 1, "user_id": "user01", "full_name": "홍길동", "status": 1},
      {"id": 2, "user_id": "user02", "full_name": "김철수", "status": 0},
      {"id": 3, "user_id": "user03", "full_name": "이영희", "status": 2},
      {"id": 1, "user_id": "user01", "full_name": "홍길동", "status": 1},
      {"id": 2, "user_id": "user02", "full_name": "김철수", "status": 0},
      {"id": 3, "user_id": "user03", "full_name": "이영희", "status": 2},
      {"id": 1, "user_id": "user01", "full_name": "홍길동", "status": 1},
      {"id": 2, "user_id": "user02", "full_name": "김철수", "status": 0},
      {"id": 3, "user_id": "user03", "full_name": "이영희", "status": 2},
      {"id": 1, "user_id": "user01", "full_name": "홍길동", "status": 1},
      {"id": 2, "user_id": "user02", "full_name": "김철수", "status": 0},
      {"id": 3, "user_id": "user03", "full_name": "이영희", "status": 2},
      {"id": 1, "user_id": "user01", "full_name": "홍길동", "status": 1},
      {"id": 2, "user_id": "user02", "full_name": "김철수", "status": 0},
      {"id": 3, "user_id": "user03", "full_name": "이영희", "status": 2},
      {"id": 1, "user_id": "user01", "full_name": "홍길동", "status": 1},
      {"id": 2, "user_id": "user02", "full_name": "김철수", "status": 0},
      {"id": 3, "user_id": "user03", "full_name": "이영희", "status": 2},
      {"id": 1, "user_id": "user01", "full_name": "홍길동", "status": 1},
      {"id": 2, "user_id": "user02", "full_name": "김철수", "status": 0},
      {"id": 3, "user_id": "user03", "full_name": "이영희", "status": 2},
      {"id": 1, "user_id": "user01", "full_name": "홍길동", "status": 1},
      {"id": 2, "user_id": "user02", "full_name": "김철수", "status": 0},
      {"id": 3, "user_id": "user03", "full_name": "이영희", "status": 2},
      {"id": 1, "user_id": "user01", "full_name": "홍길동", "status": 1},
      {"id": 2, "user_id": "user02", "full_name": "김철수", "status": 0},
      {"id": 3, "user_id": "user03", "full_name": "이영희", "status": 2},
      {"id": 1, "user_id": "user01", "full_name": "홍길동", "status": 1},
      {"id": 2, "user_id": "user02", "full_name": "김철수", "status": 0},
      {"id": 3, "user_id": "user03", "full_name": "이영희", "status": 2},
      {"id": 1, "user_id": "user01", "full_name": "홍길동", "status": 1},
      {"id": 2, "user_id": "user02", "full_name": "김철수", "status": 0},
      {"id": 3, "user_id": "user03", "full_name": "이영희", "status": 2},
      {"id": 1, "user_id": "user01", "full_name": "홍길동", "status": 1},
      {"id": 2, "user_id": "user02", "full_name": "김철수", "status": 0},
      {"id": 3, "user_id": "user03", "full_name": "이영희", "status": 2},
      {"id": 1, "user_id": "user01", "full_name": "홍길동", "status": 1},
      {"id": 2, "user_id": "user02", "full_name": "김철수", "status": 0},
      {"id": 3, "user_id": "user03", "full_name": "이영희", "status": 2},
      {"id": 1, "user_id": "user01", "full_name": "홍길동", "status": 1},
      {"id": 2, "user_id": "user02", "full_name": "김철수", "status": 0},
      {"id": 3, "user_id": "user03", "full_name": "이영희", "status": 2},
      {"id": 1, "user_id": "user01", "full_name": "홍길동", "status": 1},
      {"id": 2, "user_id": "user02", "full_name": "김철수", "status": 0},
      {"id": 3, "user_id": "user03", "full_name": "이영희", "status": 2},
      {"id": 1, "user_id": "user01", "full_name": "홍길동", "status": 1},
      {"id": 2, "user_id": "user02", "full_name": "김철수", "status": 0},
      {"id": 3, "user_id": "user03", "full_name": "이영희", "status": 2},
      {"id": 1, "user_id": "user01", "full_name": "홍길동", "status": 1},
      {"id": 2, "user_id": "user02", "full_name": "김철수", "status": 0},
      {"id": 3, "user_id": "user03", "full_name": "이영희", "status": 2},
    ];

    final userList = dummyData.map((e) => AdminUserInfo.fromJson(e)).toList();

    return AdminState(userList: userList);
  }

  // 3. 상태 변경 로직
  Future<void> updateUserStatus(int id, int newStatus) async {
    // 서버 API 호출 로직 (생략 가능)
    // await dio.post(...);

    // 4. 로컬 상태 업데이트 (AdminState의 copyWith 사용)
    final updatedList = state.userList.map((user) {
      if (user.id == id) {
        return AdminUserInfo(
          id: user.id,
          userId: user.userId, // 모델의 필드명에 맞춰주세요
          fullName: user.fullName,
          status: newStatus,
        );
      }
      return user;
    }).toList();

    state = state.copyWith(userList: updatedList);
  }

  Future<bool> sendToServer({required int id, required int status}) async {
    final Map<String, dynamic> requestData = {"id": id, "status": status};

    try {
      final useCase = ref.read(adminDataUseCaseProvider);
      final result = await useCase.execute(requestData);

      Map<String, dynamic> response;
      if (result is String) {
        response = jsonDecode(result);
      } else {
        response = Map<String, dynamic>.from(result);
      }

      if (response['status'] == 'success') {
        print("유저 상태 업데이트 성공!");
        return true;
      }
      return false;
    } on Exception catch (e) {
      print("유저 상태 업데이트 실패: $e");
      return false;
    }
  }
}
