class Senha {
  int? id;
  String descricao;
  String valor;
  String sistema;
  int clienteId;

  Senha({
    this.id,
    required this.descricao,
    required this.valor,
    required this.sistema,
    required this.clienteId,
  });

  factory Senha.fromMap(Map<String, dynamic> map) {
    return Senha(
      id: map['id'],
      descricao: map['descricao'],
      valor: map['valor'],
      sistema: map['sistema'],
      clienteId: map['clienteId'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'descricao': descricao,
      'valor': valor,
      'sistema': sistema,
      'clienteId': clienteId,
    };
  }
}
