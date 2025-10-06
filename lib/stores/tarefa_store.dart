import 'package:bpotarefas/services/tarefa_services.dart';
import 'package:flutter/material.dart';
import '../models/tarefa.dart';


class TarefaStore extends ChangeNotifier {
  final TarefaService _service = TarefaService();
  List<Tarefa> tarefas = [];

  Future<void> loadTarefas() async {
    tarefas = await _service.getTarefas();
    notifyListeners();
  }

  Future<void> addTarefa(Tarefa tarefa) async {
    await _service.addTarefa(tarefa);
    await loadTarefas();
  }

  Future<void> updateTarefa(Tarefa tarefa) async {
    await _service.updateTarefa(tarefa);
    await loadTarefas();
  }

  Future<void> deleteTarefa(int id) async {
    await _service.deleteTarefa(id);
    await loadTarefas();
  }

  Future<void> cloneTarefa(Tarefa tarefa) async {
  await _service.cloneTarefa(tarefa);
  await loadTarefas();
}

}
