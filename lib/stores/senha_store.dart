import 'package:flutter/material.dart';
import '../models/senha.dart';
import '../services/senha_services.dart';

class SenhaStore extends ChangeNotifier {
  final SenhaService _service = SenhaService();

  List<Senha> senhas = [];
  bool loading = false;

  Future<void> loadSenhas() async {
    loading = true;
    notifyListeners();

    try {
      senhas = await _service.getSenhas();
    } catch (e) {
      debugPrint('❌ Erro ao carregar senhas: $e');
      senhas = [];
    } finally {
      loading = false;
      notifyListeners();
    }
  }

  Future<void> addSenha(Senha senha) async {
    try {
      await _service.addSenha(senha);
      await loadSenhas();
    } catch (e) {
      debugPrint('❌ Erro ao adicionar senha: $e');
    }
  }

  Future<void> updateSenha(Senha senha) async {
    try {
      await _service.updateSenha(senha);
      await loadSenhas();
    } catch (e) {
      debugPrint('❌ Erro ao atualizar senha: $e');
    }
  }

  Future<void> deleteSenha(int id) async {
    try {
      await _service.deleteSenha(id);
      await loadSenhas();
    } catch (e) {
      debugPrint('❌ Erro ao excluir senha: $e');
    }
  }

  List<Senha> getByCliente(int clienteId) {
    return senhas.where((s) => s.clienteId == clienteId).toList();
  }
}
