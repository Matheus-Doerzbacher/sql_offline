import 'package:logging/logging.dart';
import 'package:result_dart/result_dart.dart';
import '../../../../domain/model/usuario.dart';
import '../api_client.dart';
import '../model/usuario/usuario_created.dart';
import '../model/usuario/usuario_update.dart';

const String _path = '/usuarios';

class UsuarioService {
  UsuarioService({required ApiClient apiClient}) : _apiClient = apiClient;

  final ApiClient _apiClient;

  final _log = Logger('UsuarioService');

  AsyncResult<Usuario> getUsuario(String id) async {
    try {
      final result = await _apiClient.get('$_path/$id');
      return result.fold(
        (value) => Success(Usuario.fromMap(value)),
        Failure.new,
      );
    } on Exception catch (e) {
      _log.severe('Falha ao buscar usuário: $e');
      return Failure(e);
    }
  }

  AsyncResult<Usuario> createUsuario(UsuarioCreated usuario) async {
    try {
      final result = await _apiClient.post(_path, usuario.toJson());
      return result.fold(
        (success) => Success(Usuario.fromMap(success)),
        Failure.new,
      );
    } on Exception catch (e) {
      _log.severe('Falha ao criar usuário: $e');
      return Failure(e);
    }
  }

  AsyncResult<Usuario> updateUsuario(String id, UsuarioUpdate usuario) async {
    try {
      final result = await _apiClient.put('$_path/$id', usuario.toJson());
      return result.fold(
        (success) => Success(Usuario.fromMap(success)),
        Failure.new,
      );
    } on Exception catch (e) {
      _log.severe('Falha ao atualizar usuário: $e');
      return Failure(e);
    }
  }

  AsyncResult<Unit> deleteUsuario(String id) async {
    return _apiClient.delete('$_path/$id');
  }
}
