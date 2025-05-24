import 'package:flutter/material.dart';
import 'package:result_command/result_command.dart';
import 'package:result_dart/result_dart.dart';
import 'package:sql_offline/data/repository/auth_repository.dart';
import 'package:sql_offline/data/repository/tarefa_repository.dart';
import 'package:sql_offline/data/services/api/model/tarefa/tarefa_created.dart';
import 'package:sql_offline/domain/model/tarefa.dart';

class HomeViewModel extends ChangeNotifier {
  final TarefaRepository _tarefaRepository;
  final AuthRepository _authRepository;

  HomeViewModel({
    required TarefaRepository tarefaRepository,
    required AuthRepository authRepository,
  })  : _tarefaRepository = tarefaRepository,
        _authRepository = authRepository {
    _authRepository.addListener(_onAuthChanged);
    buscarTarefas.execute();
  }

  @override
  void dispose() {
    _authRepository.removeListener(_onAuthChanged);
    super.dispose();
  }

  Future<void> _onAuthChanged() async {
    final isAuthenticated = await _authRepository.isAuthenticated;
    if (isAuthenticated) {
      await buscarTarefas.execute();
    } else {
      _tarefas.clear();
      notifyListeners();
    }
  }

  final _tarefas = <Tarefa>[];
  List<Tarefa> get tarefas => _tarefas;

  void _sortTarefas() {
    _tarefas.sort((a, b) => a.titulo.compareTo(b.titulo));
    notifyListeners();
  }

  late final buscarTarefas = Command0(_buscarTarefas);
  late final criarTarefa = Command1(_criarTarefa);
  late final atualizarTarefa = Command1(_atualizarTarefa);
  late final deletarTarefa = Command1(_deletarTarefa);

  AsyncResult<Unit> _buscarTarefas() async {
    final result = await _tarefaRepository.getTarefas();
    return result.fold(
      (value) {
        _tarefas
          ..clear()
          ..addAll(value);
        _sortTarefas();
        return const Success(unit);
      },
      Failure.new,
    );
  }

  AsyncResult<Unit> _criarTarefa(TarefaCreated tarefa) async {
    final result = await _tarefaRepository.createTarefa(tarefa);
    return result.fold(
      (value) {
        _tarefas.add(value);
        _sortTarefas();
        return const Success(unit);
      },
      Failure.new,
    );
  }

  AsyncResult<Unit> _atualizarTarefa(Tarefa tarefa) async {
    final tarefaAtualizada = tarefa.copyWith(isConcluida: !tarefa.isConcluida);
    final result = await _tarefaRepository.updateTarefa(tarefaAtualizada);
    return result.fold(
      (value) {
        final index = _tarefas.indexWhere((t) => t.idTarefa == tarefa.idTarefa);
        _tarefas[index] = value;
        _sortTarefas();
        return const Success(unit);
      },
      Failure.new,
    );
  }

  AsyncResult<Unit> _deletarTarefa(Tarefa tarefa) async {
    final result = await _tarefaRepository.deleteTarefa(tarefa.idTarefa);
    return result.fold(
      (value) {
        _tarefas.remove(tarefa);
        _sortTarefas();
        return const Success(unit);
      },
      Failure.new,
    );
  }
}
