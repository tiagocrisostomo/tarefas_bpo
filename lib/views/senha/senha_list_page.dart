import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../models/cliente.dart';
import '../../models/senha.dart';
import '../../stores/cliente_store.dart';
import '../../stores/senha_store.dart';
import 'senha_form_page.dart';

class SenhaListPage extends StatefulWidget {
  const SenhaListPage({super.key});

  @override
  State<SenhaListPage> createState() => _SenhaListPageState();
}

class _SenhaListPageState extends State<SenhaListPage> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      final senhaStore = context.read<SenhaStore>();
      final clienteStore = context.read<ClienteStore>();
      await clienteStore.loadClientes();
      await senhaStore.loadSenhas();
    });
  }

  @override
  Widget build(BuildContext context) {
    final senhaStore = context.watch<SenhaStore>();
    final clienteStore = context.watch<ClienteStore>();

    return Scaffold(
      appBar: AppBar(title: const Text("Senhas")),
      body: senhaStore.loading
          ? const Center(child: CircularProgressIndicator())
          : senhaStore.senhas.isEmpty
          ? const Center(child: Text("Nenhuma senha cadastrada"))
          : ListView.builder(
              padding: const EdgeInsets.all(8),
              itemCount: senhaStore.senhas.length,
              itemBuilder: (context, index) {
                final senha = senhaStore.senhas[index];
                final cliente = clienteStore.clientes.firstWhere(
                  (c) => c.id == senha.clienteId,
                  orElse: () => Cliente(id: 0, nome: "Sem cliente"),
                );
                return _buildCard(senha, cliente, senhaStore);
              },
            ),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add),
        onPressed: () async {
          await Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const SenhaFormPage()),
          );
          if (mounted) context.read<SenhaStore>().loadSenhas();
        },
      ),
    );
  }

  Widget _buildCard(Senha senha, Cliente cliente, SenhaStore store) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 4),
      child: ListTile(
        title: Text(
          "Descrição: ${senha.descricao}\nCliente: ${cliente.nome}\nSenha: ${senha.valor}\nSistema: ${senha.sistema}",
        ),
        trailing: PopupMenuButton<String>(
          onSelected: (value) async {
            if (value == 'editar') {
              await Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => SenhaFormPage(senha: senha)),
              );
              if (mounted) store.loadSenhas();
            } else if (value == 'clonar') {
              final novaSenha = Senha(
                clienteId: senha.clienteId,
                descricao: senha.descricao,
                valor: senha.valor,
                sistema: senha.sistema,
              );
              await store.addSenha(novaSenha);
            } else if (value == 'excluir') {
              final confirmar = await showDialog<bool>(
                context: context,
                builder: (context) => AlertDialog(
                  title: const Text('Confirmar exclusão'),
                  content: const Text('Deseja realmente excluir esta senha?'),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.pop(context, false),
                      child: const Text('Cancelar'),
                    ),
                    TextButton(
                      onPressed: () => Navigator.pop(context, true),
                      child: const Text('Excluir'),
                    ),
                  ],
                ),
              );
              if (confirmar == true) {
                await store.deleteSenha(senha.id!);
              }
            }
          },
          itemBuilder: (_) => const [
            PopupMenuItem(value: 'editar', child: Text('Editar')),
            PopupMenuItem(value: 'clonar', child: Text('Clonar')),
            PopupMenuItem(value: 'excluir', child: Text('Excluir')),
          ],
        ),
      ),
    );
  }
}
