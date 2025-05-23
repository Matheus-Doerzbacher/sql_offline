import 'package:flutter/widgets.dart';
import 'package:result_command/result_command.dart';
import 'package:result_dart/result_dart.dart';
import '../../../data/repository/auth_repository.dart';

class LogoutViewModel extends ChangeNotifier {
  final AuthRepository _authRepository;

  LogoutViewModel({required AuthRepository authRepository})
      : _authRepository = authRepository;

  late final logout = Command0(_logout);

  AsyncResult<Unit> _logout() async {
    return _authRepository.logout();
  }
}
