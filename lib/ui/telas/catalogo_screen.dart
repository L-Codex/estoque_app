import 'package:flutter/material.dart';
import '../../data/api/produto_api.dart';
import '../../data/repositories/produto_repository.dart';
import '../../models/produto.dart';

class CatalogoScreen extends StatefulWidget {
  const CatalogoScreen({super.key});

  @override
  State<CatalogoScreen> createState() => _CatalogoScreenState();
}

class _CatalogoScreenState extends State<CatalogoScreen> {

  late Future<List<Produto>> _futuroCatalogo;

  @override
  void initState() {
    super.initState();
    _futuroCatalogo = ProdutoApi().buscarCatalogo();
  }


  Future<void> _importar(Produto p) async {
    await ProdutoRepository.instance.adicionar(p);
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('${p.nome} importado!')),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Catálogo (API)')),
      body: FutureBuilder<List<Produto>>(
        future: _futuroCatalogo,
        builder: (context, snapshot) {

          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(child: Text('Falhou: ${snapshot.error}'));
          }

          final produtos = snapshot.data ?? [];
          return ListView.builder(
            itemCount: produtos.length,
            itemBuilder: (context, i) {
              final p = produtos[i];
              return Card(
                child: ListTile(
                  title: Text(p.nome),
                  subtitle: Text(
                    '${p.categoria}  -  R\$ ${p.preco.toStringAsFixed(2)}',
                  ),
                  trailing: IconButton(
                    tooltip: 'Importar',
                    icon: const Icon(Icons.add_circle_outline),
                    onPressed: () => _importar(p),
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
