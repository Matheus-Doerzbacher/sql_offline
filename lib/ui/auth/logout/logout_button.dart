import 'package:flutter/material.dart';
import 'logout_viewmodel.dart';

class LogoutButton extends StatefulWidget {
  final LogoutViewModel viewModel;
  const LogoutButton({super.key, required this.viewModel});

  @override
  State<LogoutButton> createState() => _LogoutButtonState();
}

class _LogoutButtonState extends State<LogoutButton> {
  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: widget.viewModel.logout,
      builder: (context, _) {
        final isRunning = widget.viewModel.logout.isRunning;
        return IconButton(
          onPressed: isRunning ? null : () => widget.viewModel.logout.execute(),
          icon: isRunning
              ? const CircularProgressIndicator.adaptive()
              : const Icon(Icons.logout),
        );
      },
    );
  }
}
