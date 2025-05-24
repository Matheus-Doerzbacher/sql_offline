import 'package:flutter/material.dart';
import 'package:sql_offline/ui/usuario/usuario_viewmodel.dart';

class UsuarioPage extends StatefulWidget {
  final UsuarioViewModel viewModel;
  const UsuarioPage({super.key, required this.viewModel});

  @override
  State<UsuarioPage> createState() => _UsuarioPageState();
}

class _UsuarioPageState extends State<UsuarioPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Usuário'),
      ),
      body: ListenableBuilder(
        listenable: widget.viewModel.buscarUsuario,
        builder: (context, _) {
          if (widget.viewModel.buscarUsuario.isRunning) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          return Center(
            child: Text(widget.viewModel.usuario!.nome),
          );
        },
      ),
    );
  }
}
