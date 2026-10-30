import 'package:flutter/material.dart';
import '../../core/rotas.dart';
import '../../data/repositories/produto_repository.dart';
import '../../models/produto.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final _repo = ProdutoRepository.instance;
  late Future<List<Produto>> _futuroProdutos;

  @override
  void initState() {
    super.initState();
    _futuroProdutos = _repo.listar(); // dispara a busca uma vez
  }

  void _recarregar() {
    setState(() {
      _futuroProdutos = _repo.listar(); // busca de novo e redesenha
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('EstoqueApp'),
        actions: [
          IconButton(
            tooltip: 'Catálogo (API)',
            onPressed: () async {
              await Navigator.pushNamed(context, Rotas.catalogo);
              _recarregar(); // ao voltar, relê o banco (pode ter importado)
            },
            icon: const Icon(Icons.cloud_download_outlined),
          ),
          IconButton(
            tooltip: 'Sair',
            onPressed: () =>
                Navigator.pushReplacementNamed(context, Rotas.login),
            icon: const Icon(Icons.logout),
          ),
        ],
      ),
      body: FutureBuilder<List<Produto>>(
        future: _futuroProdutos,
        builder: (context, snapshot) {
          // 1) ainda carregando
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          // 2) já chegou
          final produtos = snapshot.data ?? [];
          if (produtos.isEmpty) {
            return const Center(child: Text('Nenhum produto cadastrado.'));
          }
          return ListView.builder(
            itemCount: produtos.length,
            itemBuilder: (context, i) {
              final p = produtos[i];
              return Card(
                child: ListTile(
                  leading: const Icon(Icons.inventory_2_outlined),
                  title: Text(p.nome),
                  subtitle: Text('${p.categoria}  -  Qtd: ${p.quantidade}'),
                  trailing: Text('R\$ ${p.preco.toStringAsFixed(2)}'),
                  // Toque no produto -> abre a tela de movimentação.
                  onTap: () async {
                    await Navigator.pushNamed(
                      context,
                      Rotas.movimentacao,
                      arguments: p, // envia o produto escolhido
                    );
                    _recarregar(); // ao voltar, o saldo pode ter mudado
                  },
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          await Navigator.pushNamed(context, Rotas.cadastro);
          _recarregar(); // ao voltar, relê o banco
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
