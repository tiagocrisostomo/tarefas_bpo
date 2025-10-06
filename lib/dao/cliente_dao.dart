import '../core/database.dart';
import '../models/cliente.dart';

class ClienteDAO {
  Future<int> insert(Cliente cliente) async {
    final db = await AppDatabase.instance.database;
    return await db.insert('clientes', cliente.toMap());
  }

  Future<List<Cliente>> findAll() async {
    final db = await AppDatabase.instance.database;
    final result = await db.query('clientes');
    return result.map((e) => Cliente.fromMap(e)).toList();
  }
}
