import 'package:bpotarefas/stores/senha_store.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'stores/cliente_store.dart';
import 'stores/tarefa_store.dart';
import 'views/home_page.dart';

void main() {

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => ClienteStore()),
        ChangeNotifierProvider(create: (_) => TarefaStore()),
        ChangeNotifierProvider(create: (_) => SenhaStore()),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'PlayBPO Clone',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: const HomePage(),
    );
  }
}
