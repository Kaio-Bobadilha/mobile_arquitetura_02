import '../entities/product.dart';

/// Interface abstrata do repositório para operações CRUD de produtos.
/// Define o contrato para manipular produtos nas fontes de dados.
abstract class ProductRepository {
  /// Busca a lista de todos os produtos.
  Future<List<Product>> getProducts();

  /// Adiciona um novo produto.
  /// Retorna o [Product] criado.
  Future<Product> addProduct(Product product);

  /// Atualiza um produto existente.
  /// Retorna o [Product] atualizado.
  Future<Product> updateProduct(Product product);

  /// Remove um produto pelo [id].
  Future<void> deleteProduct(int id);
}

