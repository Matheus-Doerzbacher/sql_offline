import 'package:flutter/material.dart';
import 'package:result_command/result_command.dart';
import 'package:result_dart/result_dart.dart';
import 'package:sql_offline/data/repository/auth_repository.dart';
import 'package:sql_offline/data/repository/usuario_repository.dart';
import 'package:sql_offline/domain/model/usuario.dart';

class UsuarioViewModel extends ChangeNotifier {
  final UsuarioRepository _usuarioRepository;
  final AuthRepository _authRepository;

  UsuarioViewModel({
    required UsuarioRepository usuarioRepository,
    required AuthRepository authRepository,
  })  : _usuarioRepository = usuarioRepository,
        _authRepository = authRepository {
    _authRepository.addListener(_onAuthChanged);
    buscarUsuario.execute();
  }

  @override
  void dispose() {
    _authRepository.removeListener(_onAuthChanged);
    super.dispose();
  }

  Future<void> _onAuthChanged() async {
    final isAuthenticated = await _authRepository.isAuthenticated;
    if (isAuthenticated) {
      await buscarUsuario.execute();
    } else {
      _usuario = null;
      notifyListeners();
    }
  }

  Usuario? _usuario;
  Usuario? get usuario => _usuario;

  late final buscarUsuario = Command0(_buscarUsuario);

  AsyncResult<Unit> _buscarUsuario() async {
    final usuario = await _usuarioRepository.getUsuarioLogado().getOrNull();

    if (usuario == null) {
      return Failure(Exception('Usuário não encontrado'));
    }
    _usuario = usuario;
    notifyListeners();
    return const Success(unit);
  }

  void resetarDados() {
    _usuario = null;
    notifyListeners();
  }
}
