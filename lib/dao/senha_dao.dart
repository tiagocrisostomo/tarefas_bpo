import 'package:bpotarefas/core/database.dart';

import '../../models/senha.dart';

class SenhaDao {
  Future<int> insert(Senha senha) async {
    final db = await AppDatabase.instance.database;
    return await db.insert('senha', senha.toMap());
  }

  Future<int> update(Senha senha) async {
    final db = await AppDatabase.instance.database;
    return await db.update(
      'senha',
      senha.toMap(),
      where: 'id = ?',
      whereArgs: [senha.id],
    );
  }

  Future<int> delete(int id) async {
    final db = await AppDatabase.instance.database;
    return await db.delete('senha', where: 'id = ?', whereArgs: [id]);
  }

  Future<List<Senha>> getAll() async {
    final db = await AppDatabase.instance.database;
    final result = await db.query('senha', orderBy: 'id DESC');
    return result.map((map) => Senha.fromMap(map)).toList();
  }

  Future<List<Senha>> getByCliente(int clienteId) async {
    final db = await AppDatabase.instance.database;
    final result = await db.query(
      'senha',
      where: 'clienteId = ?',
      whereArgs: [clienteId],
      orderBy: 'id DESC',
    );
    return result.map((map) => Senha.fromMap(map)).toList();
  }
}
