import '../core/database.dart';
import '../models/tarefa.dart';

class TarefaDAO {
  Future<int> insert(Tarefa tarefa) async {
    final db = await AppDatabase.instance.database;
    return await db.insert('tarefas', tarefa.toMap());
  }

  Future<List<Tarefa>> findAll() async {
    final db = await AppDatabase.instance.database;
    final result = await db.query('tarefas');
    return result.map((e) => Tarefa.fromMap(e)).toList();
  }

  Future<void> update(Tarefa tarefa) async {
    final db = await AppDatabase.instance.database;
    await db.update(
      'tarefas',
      tarefa.toMap(),
      where: 'id = ?',
      whereArgs: [tarefa.id],
    );
  }

  Future<int> delete(int id) async {
    final db = await AppDatabase.instance.database;
    return await db.delete('tarefas', where: 'id = ?', whereArgs: [id]);
  }

  Future<int> clone(Tarefa tarefa) async {
    final db = await AppDatabase.instance.database;
    final novaTarefa = tarefa.toMap();
    novaTarefa.remove('id'); // força novo registro
    return await db.insert('tarefas', novaTarefa);
  }
}
