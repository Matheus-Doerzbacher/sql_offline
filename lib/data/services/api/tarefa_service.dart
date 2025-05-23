import 'package:result_dart/result_dart.dart';
import 'package:sql_offline/data/services/api/client/api_client.dart';
import 'package:sql_offline/data/services/api/model/tarefa/tarefa_created.dart';
import 'package:sql_offline/domain/model/tarefa.dart';

class TarefaService {
  final ApiClient _apiClient;

  TarefaService({required ApiClient apiClient}) : _apiClient = apiClient;

  String get _path => '/tarefas';

  AsyncResult<List<Tarefa>> getTarefas() async {
    final result = await _apiClient.get(_path);
    return result.fold(
      (value) => Success(
        (value as List)
            .map((e) => Tarefa.fromMap(e as Map<String, dynamic>))
            .toList(),
      ),
      Failure.new,
    );
  }

  AsyncResult<Tarefa> getTarefa(int id) async {
    final result = await _apiClient.get('$_path$id');
    return result.fold(
      (value) => Success(Tarefa.fromMap(value)),
      Failure.new,
    );
  }

  AsyncResult<Tarefa> createTarefa(TarefaCreated tarefa) async {
    final result = await _apiClient.post(_path, tarefa.toJson());
    return result.fold(
      (value) => Success(Tarefa.fromMap(value)),
      Failure.new,
    );
  }

  AsyncResult<Tarefa> updateTarefa(Tarefa tarefa) async {
    final result = await _apiClient.put(_path, tarefa.toMap(), tarefa.idTarefa);
    return result.fold(
      (value) => Success(Tarefa.fromMap(value)),
      Failure.new,
    );
  }

  AsyncResult<void> deleteTarefa(int id) async {
    return _apiClient.delete(_path, id);
  }
}
