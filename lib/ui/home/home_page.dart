import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:sql_offline/routing/routes.dart';
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
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Home'),
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
      body: const Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('Home'),
          ],
        ),
      ),
    );
  }
}
