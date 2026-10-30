import '../db/app_database.dart';
import '../../models/movimentacao.dart';
import '../../models/produto.dart';

class MovimentacaoRepository {
  static final MovimentacaoRepository instance =
  MovimentacaoRepository._interno();
  MovimentacaoRepository._interno();

  Future<void> registrar(Produto produto, String tipo, int quantidade) async {
    final db = await AppDatabase.instance;


    final mov = Movimentacao(
      produtoId: produto.id!,
      tipo: tipo,
      quantidade: quantidade,
      data: DateTime.now().toIso8601String(),
    );
    await db.insert('movimentacoes', mov.toMap());


    final novoSaldo = tipo == 'ENTRADA'
        ? produto.quantidade + quantidade
        : produto.quantidade - quantidade;


    await db.update(
      'produtos',
      {'quantidade': novoSaldo},
      where: 'id = ?',
      whereArgs: [produto.id],
    );
  }
}
