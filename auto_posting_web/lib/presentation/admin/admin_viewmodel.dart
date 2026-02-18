import 'dart:convert';

import 'package:auto_posting_web/presentation/admin/admin_provider.dart';
import 'package:auto_posting_web/presentation/admin/admin_state.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'data/models/admin_user_info.dart';
import 'data/models/user_success_log.dart';

class AdminViewModel extends Notifier<AdminState> {
  @override
  AdminState build() {
    // return AdminState.initial();
    // 2. 초기 데이터(더미)를 담아서 상태 생성

    Future.microtask(() => getUserList());

    return AdminState.initial();
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

  Future<void> getUserList() async {
    try {
      final userCase = ref.read(adminDataUseCaseProvider);
      final result = await userCase.getUserList();

      // 1. 응답 처리 (String인 경우 decode)
      final Map<String, dynamic> response = (result is String)
          ? jsonDecode(result)
          : Map<String, dynamic>.from(result);

      // 2. 상태가 성공(success)인지 확인
      if (response['status'] == 'success') {
        // 3. 'data' 필드에서 리스트 추출 및 모델 변환
        final List<dynamic> dataList = response['data'];

        final List<AdminUserInfo> users = dataList
            .map((json) => AdminUserInfo.fromJson(json))
            .toList();

        // 4. ViewModel의 상태 업데이트
        state = state.copyWith(userList: users);

        print("불러오기 성공: ${users.length}명");
      } else {
        print("서버 에러: ${response['message']}");
      }
    } catch (e) {
      print("getUserList 중 예외 발생: $e");
      // 필요시 에러 상태 처리
    }
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

  Future<void> getUserSuccessLogs({required int id}) async {
    // 서버가 요구하는 파라미터가 user_id(문자열)라면 String으로,
    // id(숫자)라면 int로 보내도록 UseCase와 맞추세요.
    final Map<String, dynamic> requestData = {"id": id};

    try {
      final useCase = ref.read(adminDataUseCaseProvider);
      final result = await useCase.getUserSuccessLogs(requestData);

      // 1. 응답 데이터 타입 정규화
      final Map<String, dynamic> response = (result is String)
          ? jsonDecode(result)
          : Map<String, dynamic>.from(result);

      // 2. 응답 결과가 성공인 경우
      if (response['status'] == 'success') {
        // 3. 'data' 필드의 리스트를 추출하여 모델 리스트로 변환
        final List<dynamic> logData = response['data'];

        final List<UserSuccessLog> fetchedLogs = logData
            .map((item) => UserSuccessLog.fromJson(item))
            .toList();

        // 4. 상태(State) 업데이트
        // 현재 상태를 유지하면서 successLogs 리스트만 교체합니다.
        state = state.copyWith(userSuccessLogs: fetchedLogs);

        print("통계 불러오기 성공: ${fetchedLogs.length}일치 데이터");
      } else {
        print("통계 불러오기 실패: ${response['message']}");
      }
    } catch (e) {
      print("getUserSuccessLogs 에러: $e");
    }
  }
}
