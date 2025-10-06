import 'package:bpotarefas/core/database.dart';

import '../models/senha.dart';

class SenhaService {

  Future<List<Senha>> getSenhas() async {
    final db = await AppDatabase.instance.database;
    final result = await db.query('senhas');
    return result.map((map) => Senha.fromMap(map)).toList();
  }

  Future<void> addSenha(Senha senha) async {
    final db = await AppDatabase.instance.database;
    await db.insert('senhas', senha.toMap());
  }

  Future<void> updateSenha(Senha senha) async {
    final db = await AppDatabase.instance.database;
    await db.update(
      'senhas',
      senha.toMap(),
      where: 'id = ?',
      whereArgs: [senha.id],
    );
  }

  Future<void> deleteSenha(int id) async {
    final db = await AppDatabase.instance.database;
    await db.delete('senhas', where: 'id = ?', whereArgs: [id]);
  }
}
