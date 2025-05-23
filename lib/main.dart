import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'config/providers.dart';
import 'routing/router.dart';

void main() {
  runApp(
    MultiProvider(
      providers: providers,
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'Task Manager',
      routerConfig: router(context.read()),
    );
  }
}
