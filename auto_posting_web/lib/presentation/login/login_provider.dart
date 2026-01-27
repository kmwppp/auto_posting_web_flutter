import 'package:auto_posting_web/presentation/login/login_state.dart';
import 'package:auto_posting_web/presentation/login/login_viewmodel.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final loginViewModelProvider = NotifierProvider<LoginViewModel, LoginState>(
  LoginViewModel.new,
);
