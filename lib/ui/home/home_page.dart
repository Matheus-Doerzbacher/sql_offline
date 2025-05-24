import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:result_command/result_command.dart';
import 'package:sql_offline/routing/routes.dart';
import 'package:sql_offline/ui/home/nova_tarefa_modal.dart';
import '../auth/logout/logout_button.dart';
import 'home_viewmodel.dart';

class HomePage extends StatefulWidget {
  final HomeViewModel viewModel;
  const HomePage({super.key, required this.viewModel});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  void initState() {
    super.initState();
    widget.viewModel.buscarTarefas.addListener(_listener);
    widget.viewModel.atualizarTarefa.addListener(_listener);
    widget.viewModel.buscarTarefas.execute();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Tarefas'),
        leading: LogoutButton(viewModel: context.read()),
        actions: [
          IconButton(
            onPressed: () {
              context.go(Routes.usuarioRoute);
            },
            icon: const Icon(Icons.person),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showModalBottomSheet(
            context: context,
            builder: (context) {
              return NovaTarefaModal(viewModel: widget.viewModel);
            },
          );
        },
        child: const Icon(Icons.add),
      ),
      body: ListenableBuilder(
        listenable: Listenable.merge([
          widget.viewModel,
          widget.viewModel.buscarTarefas,
        ]),
        builder: (context, _) {
          if (widget.viewModel.buscarTarefas.isRunning) {
            return const Center(child: CircularProgressIndicator());
          }

          final tarefas = widget.viewModel.tarefas;
          if (tarefas.isEmpty) {
            return const Center(child: Text('Nenhuma tarefa encontrada'));
          }

          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Column(
              children: [
                Expanded(
                  child: ListView.builder(
                    itemCount: tarefas.length,
                    itemBuilder: (context, index) {
                      final tarefa = tarefas[index];
                      return Dismissible(
                        key: Key(tarefa.idTarefa.toString()),
                        direction: DismissDirection.startToEnd,
                        onDismissed: (direction) {
                          widget.viewModel.deletarTarefa.execute(tarefa);
                        },
                        background: Card(
                          child: Container(
                            decoration: BoxDecoration(
                              color: Colors.red,
                              borderRadius: BorderRadius.circular(10),
                            ),
                            alignment: Alignment.centerLeft,
                            padding: const EdgeInsets.only(left: 20),
                            child: const Icon(
                              Icons.delete,
                              color: Colors.white,
                              size: 30,
                            ),
                          ),
                        ),
                        child: Card(
                          child: ListTile(
                            title: Text(tarefa.titulo),
                            subtitle: Text(tarefa.descricao),
                            leading: IconButton(
                              iconSize: 30,
                              onPressed: () async {
                                await widget.viewModel.atualizarTarefa
                                    .execute(tarefa);
                              },
                              icon: tarefa.isConcluida
                                  ? const Icon(
                                      Icons.check_circle,
                                      color: Colors.green,
                                    )
                                  : const Icon(
                                      Icons.remove_circle_outline_rounded,
                                      color: Colors.blueGrey,
                                    ),
                            ),
                            trailing: Text(
                              DateFormat('dd/MM/yyyy')
                                  .format(tarefa.dataCriacao),
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  void _listener() {
    FailureCommand? failure;

    if (widget.viewModel.buscarTarefas.isFailure) {
      failure = widget.viewModel.buscarTarefas.value as FailureCommand;
    } else if (widget.viewModel.atualizarTarefa.isFailure) {
      failure = widget.viewModel.atualizarTarefa.value as FailureCommand;
    }

    if (failure != null) {
      final msg = failure.error.toString().replaceAll('Exception: ', '');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(msg),
          backgroundColor: Colors.red,
        ),
      );
    }
  }
}
