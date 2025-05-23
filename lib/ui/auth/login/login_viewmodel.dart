import 'package:flutter/material.dart';
import 'package:result_command/result_command.dart';
import 'package:result_dart/result_dart.dart';
import '../../../data/repository/auth_repository.dart';
import '../../../data/repository/usuario_repository.dart';
import '../../../data/services/api/model/login/login_request.dart';
import '../../../data/services/api/model/usuario/usuario_created.dart';
import '../../../domain/model/usuario.dart';

class LoginViewModel extends ChangeNotifier {
  LoginViewModel({
    required AuthRepository authRepository,
    required UsuarioRepository usuarioRepository,
  })  : _authRepository = authRepository,
        _usuarioRepository = usuarioRepository;

  final AuthRepository _authRepository;
  final UsuarioRepository _usuarioRepository;

  late final login = Command1(_login);
  late final createUser = Command1(_createUser);

  AsyncResult<Unit> _login(LoginRequest loginRequest) async {
    return _authRepository.login(loginRequest: loginRequest);
  }

  AsyncResult<Usuario> _createUser(UsuarioCreated usuarioCreated) async {
    return _usuarioRepository.createUser(usuarioCreated);
  }
}
