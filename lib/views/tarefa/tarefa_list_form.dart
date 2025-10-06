import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../models/cliente.dart';
import '../../models/tarefa.dart';
import '../../stores/cliente_store.dart';
import '../../stores/tarefa_store.dart';

class TarefaFormPage extends StatefulWidget {
  final Tarefa? tarefa;

  const TarefaFormPage({super.key, this.tarefa});

  @override
  State<TarefaFormPage> createState() => _TarefaFormPageState();
}

class _TarefaFormPageState extends State<TarefaFormPage> {
  final _formKey = GlobalKey<FormState>();
  final _tituloController = TextEditingController();
  final _descricaoController = TextEditingController();
  DateTime? _prazo;
  String _status = "Pendente";
  Cliente? _clienteSelecionado;
  int? _clienteIdSelecionado;

  @override
  void initState() {
    super.initState();
    context.read<ClienteStore>().loadClientes();

    if (widget.tarefa != null) {
      _tituloController.text = widget.tarefa!.titulo;
      _descricaoController.text = widget.tarefa!.descricao ?? "";
      _status = widget.tarefa!.status;
      if (widget.tarefa!.prazo != null && widget.tarefa!.prazo!.isNotEmpty) {
        _prazo = DateTime.tryParse(widget.tarefa!.prazo!);
      }
      _clienteIdSelecionado = widget.tarefa!.clienteId;
    }
  }

  Future<void> _selecionarPrazo(BuildContext context) async {
    final data = await showDatePicker(
      context: context,
      initialDate: _prazo ?? DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );
    if (data != null) {
      setState(() => _prazo = data);
    }
  }

  @override
  Widget build(BuildContext context) {
    final clienteStore = context.watch<ClienteStore>();

    final clientes = clienteStore.clientes;

    // se ainda não tem cliente selecionado, tenta achar pelo id salvo
    if (_clienteSelecionado == null && _clienteIdSelecionado != null) {
      _clienteSelecionado = clientes.firstWhere(
        (c) => c.id == _clienteIdSelecionado,
        orElse: () =>
            Cliente(id: _clienteIdSelecionado!, nome: "Cliente não encontrado"),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.tarefa == null ? "Nova Tarefa" : "Editar Tarefa"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                controller: _tituloController,
                decoration: const InputDecoration(labelText: "Título"),
                validator: (value) =>
                    value == null || value.isEmpty ? "Informe o título" : null,
              ),
              TextFormField(
                controller: _descricaoController,
                decoration: const InputDecoration(labelText: "Descrição"),
              ),
              const SizedBox(height: 12),
              InkWell(
                onTap: () => _selecionarPrazo(context),
                child: InputDecorator(
                  decoration: const InputDecoration(
                    labelText: "Prazo",
                    border: OutlineInputBorder(),
                  ),
                  child: Text(
                    _prazo != null
                        ? "${_prazo!.day}/${_prazo!.month}/${_prazo!.year}"
                        : "Selecione uma data",
                  ),
                ),
              ),
              const SizedBox(height: 12),
              DropdownButtonFormField<String>(
                value: _status,
                decoration: const InputDecoration(labelText: "Status"),
                items: const [
                  DropdownMenuItem(value: "Pendente", child: Text("Pendente")),
                  DropdownMenuItem(
                    value: "Em Andamento",
                    child: Text("Em Andamento"),
                  ),
                  DropdownMenuItem(
                    value: "Concluído",
                    child: Text("Concluído"),
                  ),
                ],
                onChanged: (value) => setState(() => _status = value!),
              ),
              const SizedBox(height: 12),
              DropdownButtonFormField<Cliente>(
                value: clientes.any((c) => c.id == _clienteSelecionado?.id)
                    ? clientes.firstWhere(
                        (c) => c.id == _clienteSelecionado!.id,
                      )
                    : null,
                decoration: const InputDecoration(labelText: "Cliente"),
                items: clientes
                    .map((c) => DropdownMenuItem(value: c, child: Text(c.nome)))
                    .toList(),
                onChanged: (value) =>
                    setState(() => _clienteSelecionado = value),
              ),

              const SizedBox(height: 20),
              ElevatedButton(
                child: const Text("Salvar"),
                onPressed: () async {
                  if (_formKey.currentState!.validate()) {
                    final tarefa = Tarefa(
                      id: widget.tarefa?.id,
                      titulo: _tituloController.text,
                      descricao: _descricaoController.text,
                      prazo: _prazo?.toIso8601String().split("T").first,
                      status: _status,
                      clienteId: _clienteSelecionado?.id,
                    );

                    if (widget.tarefa == null) {
                      await context.read<TarefaStore>().addTarefa(tarefa);
                    } else {
                      await context.read<TarefaStore>().updateTarefa(tarefa);
                    }

                    if (context.mounted) Navigator.pop(context);
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
