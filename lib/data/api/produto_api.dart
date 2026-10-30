import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../models/produto.dart';


class ProdutoApi {
  Future<List<Produto>> buscarCatalogo() async {
    final url = Uri.parse('https://fakestoreapi.com/products');

    final resposta = await http.get(url);

    if (resposta.statusCode != 200) {
      // Qualquer coisa diferente de 200 = deu problema.
      throw Exception('Erro ao buscar o catalogo (${resposta.statusCode})');
    }


    final List lista = jsonDecode(resposta.body);


    return lista.map((item) {
      return Produto(
        nome: item['title'] as String,
        categoria: item['category'] as String,
        preco: (item['price'] as num).toDouble(),
        quantidade: 0, // chega da API sem saldo; entra no estoque zerado
      );
    }).toList();
  }
}
