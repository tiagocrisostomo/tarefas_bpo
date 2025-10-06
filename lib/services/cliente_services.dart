import '../dao/cliente_dao.dart';
import '../models/cliente.dart';

class ClienteService {
  final ClienteDAO _dao = ClienteDAO();

  Future<List<Cliente>> getClientes() => _dao.findAll();

  Future<void> addCliente(Cliente cliente) async {
    await _dao.insert(cliente);
  }
}
