import '../dao/tarefa_dao.dart';
import '../models/tarefa.dart';

class TarefaService {
  final TarefaDAO _dao = TarefaDAO();

  Future<List<Tarefa>> getTarefas() => _dao.findAll();

  Future<void> addTarefa(Tarefa tarefa) async {
    await _dao.insert(tarefa);
  }

  Future<void> updateTarefa(Tarefa tarefa) async {
    await _dao.update(tarefa);
  }

  Future<void> deleteTarefa(int id) async {
    await _dao.delete(id);
  }

  Future<void> cloneTarefa(Tarefa tarefa) async {
    await _dao.clone(tarefa);
  }
}
