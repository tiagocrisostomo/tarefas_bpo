import 'package:bpotarefas/views/tarefa/tarefa_list_form.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../models/cliente.dart';
import '../../models/tarefa.dart';
import '../../stores/cliente_store.dart';
import '../../stores/tarefa_store.dart';

class TarefaListPage extends StatefulWidget {
  const TarefaListPage({super.key});

  @override
  State<TarefaListPage> createState() => _TarefaListPageState();
}

class _TarefaListPageState extends State<TarefaListPage> {
  @override
  void initState() {
    super.initState();
    // Carregar tarefas e clientes
    context.read<TarefaStore>().loadTarefas();
    context.read<ClienteStore>().loadClientes();
  }

  @override
  Widget build(BuildContext context) {
    final tarefaStore = context.watch<TarefaStore>();
    final clienteStore = context.watch<ClienteStore>();

    // Organiza as tarefas por status
    final Map<String, List<Tarefa>> statusMap = {
      "Pendente": tarefaStore.tarefas
          .where((t) => t.status == "Pendente")
          .toList(),
      "Em Andamento": tarefaStore.tarefas
          .where((t) => t.status == "Em Andamento")
          .toList(),
      "Concluído": tarefaStore.tarefas
          .where((t) => t.status == "Concluído")
          .toList(),
    };

    final Map<String, Color> statusColor = {
      "Pendente": Colors.red[100]!,
      "Em Andamento": Colors.blue[100]!,
      "Concluído": Colors.green[100]!,
    };

    return Scaffold(
      appBar: AppBar(title: const Text("Tarefas")),
      body: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: statusMap.keys.map((status) {
            final tarefas = statusMap[status]!;

            return Container(
              width: 300,
              margin: const EdgeInsets.all(8),
              child: DragTarget<Tarefa>(
                onWillAcceptWithDetails: (details) =>
                    details.data.status != status,
                onAcceptWithDetails: (details) async {
                  final tarefa = details.data;
                  final updated = Tarefa(
                    id: tarefa.id,
                    titulo: tarefa.titulo,
                    descricao: tarefa.descricao,
                    prazo: tarefa.prazo,
                    clienteId: tarefa.clienteId,
                    status: status, // atualiza o status da coluna
                  );
                  await tarefaStore.updateTarefa(updated);
                },
                builder: (context, candidateData, rejectedData) {
                  return Container(
                    decoration: BoxDecoration(
                      color: statusColor[status]!.withValues(alpha: 0.2),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Column(
                      children: [
                        // Cabeçalho da coluna
                        Container(
                          width: double.infinity,
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: statusColor[status],
                            borderRadius: const BorderRadius.vertical(
                              top: Radius.circular(8),
                            ),
                          ),
                          child: Text(
                            status,
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                        // Lista de cards
                        Expanded(
                          child: ListView(
                            padding: const EdgeInsets.all(8),
                            children: tarefas.map((tarefa) {
                              return Padding(
                                padding: const EdgeInsets.symmetric(
                                  vertical: 4,
                                ),
                                child: Draggable<Tarefa>(
                                  data: tarefa,
                                  feedback: Material(
                                    child: SizedBox(
                                      width: 280,
                                      child: _buildCard(
                                        tarefa,
                                        clienteStore.clientes,
                                      ),
                                    ),
                                  ),
                                  childWhenDragging: Opacity(
                                    opacity: 0.5,
                                    child: _buildCard(
                                      tarefa,
                                      clienteStore.clientes,
                                    ),
                                  ),
                                  child: _buildCard(
                                    tarefa,
                                    clienteStore.clientes,
                                  ),
                                ),
                              );
                            }).toList(),
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            );
          }).toList(),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add),
        onPressed: () => Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => const TarefaFormPage()),
        ),
      ),
    );
  }

  // Função para criar o card da tarefa
  Widget _buildCard(Tarefa tarefa, List<Cliente> clientes) {
    final cliente = clientes.firstWhere(
      (c) => c.id == tarefa.clienteId,
      orElse: () => Cliente(id: 0, nome: "Sem cliente"),
    );

    final tarefaStore = context.read<TarefaStore>();

    return Card(
      child: ListTile(
        title: Text(tarefa.titulo),
        subtitle: Text("${tarefa.descricao ?? ''}\nCliente: ${cliente.nome}"),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(tarefa.prazo ?? ""),
            PopupMenuButton<String>(
              onSelected: (value) async {
                if (value == 'editar') {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => TarefaFormPage(tarefa: tarefa),
                    ),
                  );
                } else if (value == 'clonar') {
                  final novaTarefa = Tarefa(
                    titulo: tarefa.titulo,
                    descricao: tarefa.descricao,
                    prazo: tarefa.prazo,
                    clienteId: tarefa.clienteId,
                    status: tarefa.status, // ou "Pendente" se quiser
                  );
                  await tarefaStore.addTarefa(novaTarefa);
                } else if (value == 'excluir') {
                  final confirmar = await showDialog<bool>(
                    context: context,
                    builder: (context) => AlertDialog(
                      title: const Text('Confirmar exclusão'),
                      content: const Text(
                        'Deseja realmente excluir esta tarefa?',
                      ),
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
                    await tarefaStore.deleteTarefa(tarefa.id!);
                  }
                }
              },
              itemBuilder: (_) => [
                const PopupMenuItem(value: 'editar', child: Text('Editar')),
                const PopupMenuItem(value: 'clonar', child: Text('Clonar')),
                const PopupMenuItem(value: 'excluir', child: Text('Excluir')),
              ],
            ),
          ],
        ),
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => TarefaFormPage(tarefa: tarefa)),
          );
        },
      ),
    );
  }
}
