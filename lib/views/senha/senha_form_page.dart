// lib/views/senha/senha_form_page.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../models/cliente.dart';
import '../../models/senha.dart';
import '../../stores/cliente_store.dart';
import '../../stores/senha_store.dart';

class SenhaFormPage extends StatefulWidget {
  final Senha? senha;

  const SenhaFormPage({super.key, this.senha});

  @override
  State<SenhaFormPage> createState() => _SenhaFormPageState();
}

class _SenhaFormPageState extends State<SenhaFormPage> {
  final _formKey = GlobalKey<FormState>();
  final _sistemaController = TextEditingController();
  final _descricaoController = TextEditingController();
  final _valorController = TextEditingController();
  Cliente? _clienteSelecionado;

  @override
  void initState() {
    super.initState();
    // Preenche campos caso seja edição
    if (widget.senha != null) {
      _sistemaController.text = widget.senha!.sistema;
      _descricaoController.text = widget.senha!.descricao;
      _valorController.text = widget.senha!.valor;
      // não tentamos buscar cliente aqui — deixamos o build resolver a instância correta
    }
  }

  @override
  void dispose() {
    _sistemaController.dispose();
    _descricaoController.dispose();
    _valorController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final clienteStore = context.watch<ClienteStore>();
    final senhaStore = context.read<SenhaStore>();

    // Se vier em edição, e ainda não atribuimos _clienteSelecionado,
    // tentamos casar o cliente pela lista atual (se já tiver sido carregada)
    if (_clienteSelecionado == null &&
        widget.senha != null &&
        clienteStore.clientes.isNotEmpty) {
      final match = clienteStore.clientes
          .where((c) => c.id == widget.senha!.clienteId)
          .toList();
      if (match.isNotEmpty) _clienteSelecionado = match.first;
    }

    // Se não há clientes cadastrados, orientar o usuário
    final hasClients = clienteStore.clientes.isNotEmpty;

    return Scaffold(
      appBar: AppBar(title: Text(widget.senha == null ? 'Nova Senha' : 'Editar Senha')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              if (!hasClients)
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: const [
                    Text('Nenhum cliente cadastrado. Cadastre um cliente antes de criar uma senha.'),
                    SizedBox(height: 12),
                  ],
                ),
              DropdownButtonFormField<Cliente>(
                value: _clienteSelecionado,
                items: clienteStore.clientes
                    .map((c) => DropdownMenuItem(value: c, child: Text(c.nome)))
                    .toList(),
                onChanged: (c) => setState(() => _clienteSelecionado = c),
                decoration: const InputDecoration(labelText: 'Cliente'),
                validator: (c) => c == null ? 'Selecione um cliente' : null,
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _sistemaController,
                decoration: const InputDecoration(labelText: 'Sistema / Serviço'),
                validator: (v) => v == null || v.isEmpty ? 'Informe o sistema' : null,
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _descricaoController,
                decoration: const InputDecoration(labelText: 'Descrição / Finalidade'),
                validator: (v) => v == null || v.isEmpty ? 'Informe a descrição' : null,
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _valorController,
                decoration: const InputDecoration(labelText: 'Senha'),
                validator: (v) => v == null || v.isEmpty ? 'Informe a senha' : null,
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                child: Text(widget.senha == null ? 'Salvar' : 'Atualizar'),
                onPressed: () async {
                  if (!_formKey.currentState!.validate()) return;
                  if (_clienteSelecionado == null) return;

                  final novaSenha = Senha(
                    id: widget.senha?.id,
                    clienteId: _clienteSelecionado!.id!, // assume id não nulo
                    sistema: _sistemaController.text,
                    descricao: _descricaoController.text,
                    valor: _valorController.text,
                  );

                  debugPrint('Salvando senha: ${novaSenha.toMap()}');

                  // Mesmo padrão simples do ClienteFormPage:
                  if (widget.senha == null) {
                    await context.read<SenhaStore>().addSenha(novaSenha);
                  } else {
                    await context.read<SenhaStore>().updateSenha(novaSenha);
                  }

                  if (context.mounted) Navigator.pop(context);
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
