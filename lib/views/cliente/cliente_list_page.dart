import 'package:bpotarefas/views/cliente/cliente_list_form.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../stores/cliente_store.dart';
import '../../models/cliente.dart';


class ClienteListPage extends StatefulWidget {
  const ClienteListPage({super.key});

  @override
  State<ClienteListPage> createState() => _ClienteListPageState();
}

class _ClienteListPageState extends State<ClienteListPage> {
  @override
  void initState() {
    super.initState();
    context.read<ClienteStore>().loadClientes();
  }

  @override
  Widget build(BuildContext context) {
    final store = context.watch<ClienteStore>();

    return Scaffold(
      appBar: AppBar(title: const Text("Clientes")),
      body: ListView.builder(
        itemCount: store.clientes.length,
        itemBuilder: (_, index) {
          Cliente c = store.clientes[index];
          return ListTile(
            title: Text(c.nome),
            subtitle: Text(c.email ?? ""),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add),
        onPressed: () => Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => const ClienteFormPage()),
        ),
      ),
    );
  }
}
