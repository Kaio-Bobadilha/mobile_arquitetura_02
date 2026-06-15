import '../entities/product.dart';

/// Interface abstrata do repositório para operações CRUD de produtos.
/// Define o contrato para manipular produtos nas fontes de dados.
abstract class ProductRepository {
  /// Busca a lista de todos os produtos.
  Future<List<Product>> getProducts();

  /// Busca um produto específico pelo [id].
  Future<Product> getProductById(int id);

  /// Adiciona um novo produto.
  /// Retorna o [Product] criado.
  Future<Product> addProduct(Product product);

  /// Atualiza um produto existente.
  /// Retorna o [Product] atualizado.
  Future<Product> updateProduct(Product product);

  /// Remove um produto pelo [id].
  Future<void> deleteProduct(int id);

  /// Salva a lista de IDs de produtos favoritos.
  Future<void> saveFavorites(List<int> favoriteIds);

  /// Recupera a lista de IDs de produtos favoritos.
  List<int> getFavorites();
}

