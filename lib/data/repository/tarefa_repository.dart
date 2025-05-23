import 'package:result_dart/result_dart.dart';
import 'package:sql_offline/data/services/api/model/tarefa/tarefa_created.dart';
import 'package:sql_offline/data/services/api/tarefa_service.dart';
import 'package:sql_offline/domain/model/tarefa.dart';

class TarefaRepository {
  final TarefaService _tarefaService;

  TarefaRepository({required TarefaService tarefaService})
      : _tarefaService = tarefaService;

  AsyncResult<List<Tarefa>> getTarefas() async {
    return _tarefaService.getTarefas();
  }

  AsyncResult<Tarefa> getTarefa(int id) async {
    return _tarefaService.getTarefa(id);
  }

  AsyncResult<Tarefa> createTarefa(TarefaCreated tarefa) async {
    return _tarefaService.createTarefa(tarefa);
  }

  AsyncResult<Tarefa> updateTarefa(Tarefa tarefa) async {
    return _tarefaService.updateTarefa(tarefa);
  }

  AsyncResult<void> deleteTarefa(int id) async {
    return _tarefaService.deleteTarefa(id);
  }
}
