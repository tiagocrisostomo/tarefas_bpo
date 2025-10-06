import 'package:bpotarefas/views/senha/senha_list_page.dart';
import 'package:flutter/material.dart';

import 'cliente/cliente_list_page.dart';
import 'tarefa/tarefa_list_page.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("PlayBPO Clone")),
      body: const Center(child: Text("Dashboard inicial")),
      drawer: Drawer(
        child: ListView(
          children: [
            const DrawerHeader(child: Text("Menu")),
            ListTile(
              title: const Text("Clientes"),
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const ClienteListPage()),
              ),
            ),
            ListTile(
              title: const Text("Tarefas"),
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const TarefaListPage()),
              ),
            ),
            ListTile(
              title: const Text("Senhas"),
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const SenhaListPage()),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
