import 'package:flutter/material.dart';
import 'package:result_command/result_command.dart';
import 'package:sql_offline/data/services/api/model/tarefa/tarefa_created.dart';
import 'package:sql_offline/ui/home/home_viewmodel.dart';

class NovaTarefaModal extends StatefulWidget {
  final HomeViewModel viewModel;
  const NovaTarefaModal({super.key, required this.viewModel});

  @override
  State<NovaTarefaModal> createState() => _NovaTarefaModalState();
}

class _NovaTarefaModalState extends State<NovaTarefaModal> {
  final _formKey = GlobalKey<FormState>();
  final _nomeController = TextEditingController();
  final _descricaoController = TextEditingController();

  @override
  void initState() {
    super.initState();
    widget.viewModel.criarTarefa.addListener(_onCriarTarefaChanged);
  }

  void _onCriarTarefaChanged() {
    if (widget.viewModel.criarTarefa.isSuccess) {
      if (mounted) {
        Navigator.pop(context);
      }
    }

    if (widget.viewModel.criarTarefa.isFailure) {
      final failure = widget.viewModel.criarTarefa.value as FailureCommand;
      final error = failure.error.toString().replaceAll('Exception: ', '');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(error),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  void dispose() {
    widget.viewModel.criarTarefa.removeListener(_onCriarTarefaChanged);
    _nomeController.dispose();
    _descricaoController.dispose();
    super.dispose();
  }

  Future<void> _createTarefa() async {
    if (_formKey.currentState!.validate()) {
      final tarefa = TarefaCreated(
        titulo: _nomeController.text,
        descricao: _descricaoController.text,
      );

      await widget.viewModel.criarTarefa.execute(tarefa);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(24),
        color: Theme.of(context).colorScheme.surface,
      ),
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Nova Tarefa'),
        ),
        body: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: _nomeController,
                decoration: const InputDecoration(labelText: 'Nome'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Nome é obrigatório';
                  }
                  if (value.length < 3) {
                    return 'Nome deve ter pelo menos 3 caracteres';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _descricaoController,
                decoration: const InputDecoration(labelText: 'Descrição'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Descrição é obrigatória';
                  }
                  return null;
                },
              ),
              const Spacer(),
              ListenableBuilder(
                listenable: widget.viewModel.criarTarefa,
                builder: (context, _) {
                  final isRunning = widget.viewModel.criarTarefa.isRunning;
                  return FilledButton(
                    onPressed: isRunning ? null : _createTarefa,
                    child: isRunning
                        ? const CircularProgressIndicator.adaptive()
                        : const Text('Salvar'),
                  );
                },
              ),
              const SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }
}
