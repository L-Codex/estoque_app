import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class AppDatabase {

  static Database? _db;


  static Future<Database> get instance async {
    _db ??= await _abrir();
    return _db!;
  }

  static Future<Database> _abrir() async {
    final caminho = join(await getDatabasesPath(), 'estoque.db');

    return openDatabase(
      caminho,
      version: 2,
      onCreate: (db, versao) async {
        // Banco novo: cria as DUAS tabelas.
        await _criarProdutos(db);
        await _criarMovimentacoes(db);
      },
      onUpgrade: (db, anterior, atual) async {

        if (anterior < 2) {
          await _criarMovimentacoes(db);
        }
      },
    );
  }

  static Future<void> _criarProdutos(Database db) async {
    await db.execute('''
      CREATE TABLE produtos (
        id         INTEGER PRIMARY KEY AUTOINCREMENT,
        nome       TEXT    NOT NULL,
        categoria  TEXT    NOT NULL,
        preco      REAL    NOT NULL,
        quantidade INTEGER NOT NULL
      )
    ''');
  }

  static Future<void> _criarMovimentacoes(Database db) async {
    await db.execute('''
      CREATE TABLE movimentacoes (
        id         INTEGER PRIMARY KEY AUTOINCREMENT,
        produto_id INTEGER NOT NULL,
        tipo       TEXT    NOT NULL,
        quantidade INTEGER NOT NULL,
        data       TEXT    NOT NULL
      )
    ''');
  }
}
