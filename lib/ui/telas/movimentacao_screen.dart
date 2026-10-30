import 'package:flutter/material.dart';
import '../../data/repositories/movimentacao_repository.dart';
import '../../models/produto.dart';

class MovimentacaoScreen extends StatefulWidget {
  const MovimentacaoScreen({super.key});

  @override
  State<MovimentacaoScreen> createState() => _MovimentacaoScreenState();
}

class _MovimentacaoScreenState extends State<MovimentacaoScreen> {
  final _qtdController = TextEditingController();
  String _tipo = 'ENTRADA';

  @override
  void dispose() {
    _qtdController.dispose();
    super.dispose();
  }

  Future<void> _registrar(Produto produto) async {
    final qtd = int.tryParse(_qtdController.text) ?? 0;

    if (qtd <= 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Informe uma quantidade válida.')),
      );
      return;
    }

    if (_tipo == 'SAIDA' && qtd > produto.quantidade) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Saldo insuficiente para a saída.')),
      );
      return;
    }

    await MovimentacaoRepository.instance.registrar(produto, _tipo, qtd);
    if (!mounted) return; // a tela ainda existe?
    Navigator.pop(context); // volta para a Home (que vai recarregar)
  }

  @override
  Widget build(BuildContext context) {
    // Recebe o produto que a Home enviou ao abrir esta tela.
    final produto = ModalRoute.of(context)!.settings.arguments as Produto;

    return Scaffold(
      appBar: AppBar(title: const Text('Movimentação')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              produto.nome,
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 4),
            Text('Saldo atual: ${produto.quantidade}'),
            const SizedBox(height: 20),


            SegmentedButton<String>(
              segments: const [
                ButtonSegment(
                  value: 'ENTRADA',
                  label: Text('Entrada'),
                  icon: Icon(Icons.add),
                ),
                ButtonSegment(
                  value: 'SAIDA',
                  label: Text('Saída'),
                  icon: Icon(Icons.remove),
                ),
              ],
              selected: {_tipo},
              onSelectionChanged: (selecao) {
                setState(() => _tipo = selecao.first);
              },
            ),
            const SizedBox(height: 20),

            TextField(
              controller: _qtdController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(labelText: 'Quantidade'),
            ),
            const SizedBox(height: 24),

            FilledButton.icon(
              onPressed: () => _registrar(produto),
              icon: const Icon(Icons.check),
              label: const Text('Registrar'),
            ),
          ],
        ),
      ),
    );
  }
}
