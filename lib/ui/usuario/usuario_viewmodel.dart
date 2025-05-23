import 'package:flutter/material.dart';
import 'package:result_command/result_command.dart';
import 'package:result_dart/result_dart.dart';
import 'package:sql_offline/data/repository/usuario_repository.dart';
import 'package:sql_offline/domain/model/usuario.dart';

class UsuarioViewModel extends ChangeNotifier {
  final UsuarioRepository _usuarioRepository;

  UsuarioViewModel({
    required UsuarioRepository usuarioRepository,
  }) : _usuarioRepository = usuarioRepository {
    buscarUsuario.execute();
  }

  late final Usuario _usuario;
  Usuario get usuario => _usuario;

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
}
