import 'package:result_dart/result_dart.dart';
import '../../domain/model/usuario.dart';
import '../services/api/model/usuario/usuario_created.dart';
import '../services/api/usuario/usuario_service.dart';

class UsuarioRepository {
  UsuarioRepository({
    required UsuarioService usuarioService,
  }) : _usuarioService = usuarioService;

  final UsuarioService _usuarioService;

  AsyncResult<Usuario> createUser(UsuarioCreated usuarioCreated) async {
    return _usuarioService.createUsuario(usuarioCreated);
  }
}
