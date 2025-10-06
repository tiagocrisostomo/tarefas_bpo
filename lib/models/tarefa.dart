class Tarefa {
  final int? id;
  final String titulo;
  final String? descricao;
  final int? clienteId; // relacionamento com Cliente
  final String? prazo;
  final String status;

  Tarefa({
    this.id,
    required this.titulo,
    this.descricao,
    this.clienteId,
    this.prazo,
    this.status = "Pendente",
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'titulo': titulo,
      'descricao': descricao,
      'clienteId': clienteId,
      'prazo': prazo,
      'status': status,
    };
  }

  factory Tarefa.fromMap(Map<String, dynamic> map) {
    return Tarefa(
      id: map['id'],
      titulo: map['titulo'],
      descricao: map['descricao'],
      clienteId: map['clienteId'],
      prazo: map['prazo'],
      status: map['status'],
    );
  }
}
