import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
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
      ),
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text('Home'),
            LogoutButton(viewModel: context.read()),
          ],
        ),
      ),
    );
  }
}
