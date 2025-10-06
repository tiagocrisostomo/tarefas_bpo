import 'package:flutter/material.dart';
import '../models/cliente.dart';
import '../services/cliente_services.dart';

class ClienteStore extends ChangeNotifier {
  final ClienteService _service = ClienteService();
  List<Cliente> clientes = [];

  Future<void> loadClientes() async {
    clientes = await _service.getClientes();
    notifyListeners();
  }

  Future<void> addCliente(Cliente cliente) async {
    await _service.addCliente(cliente);
    await loadClientes();
  }
}
