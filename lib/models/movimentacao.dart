class Movimentacao {
  final int? id;
  final int produtoId;
  final String tipo;
  final int quantidade;
  final String data;

  Movimentacao({
    this.id,
    required this.produtoId,
    required this.tipo,
    required this.quantidade,
    required this.data,
  });


  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'produto_id': produtoId,
      'tipo': tipo,
      'quantidade': quantidade,
      'data': data,
    };
  }


  factory Movimentacao.fromMap(Map<String, dynamic> map) {
    return Movimentacao(
      id: map['id'] as int?,
      produtoId: map['produto_id'] as int,
      tipo: map['tipo'] as String,
      quantidade: map['quantidade'] as int,
      data: map['data'] as String,
    );
  }
}
