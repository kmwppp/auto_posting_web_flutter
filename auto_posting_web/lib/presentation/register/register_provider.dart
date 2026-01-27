import 'package:auto_posting_web/presentation/register/register_state.dart';
import 'package:auto_posting_web/presentation/register/register_viewmodel.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final registerViewModelProvider =
    NotifierProvider<RegisterViewModel, RegisterState>(RegisterViewModel.new);
