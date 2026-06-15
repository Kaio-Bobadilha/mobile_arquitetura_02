import '../../core/errors/failure.dart';
import '../../core/session/session_manager.dart';
import '../../domain/entities/product.dart';
import '../../domain/repositories/product_repository.dart';
import '../models/product_model.dart';
import '../datasources/product_remote_datasource.dart';
import '../datasources/product_cache_datasource.dart';

/// Implementação de [ProductRepository] que coordena entre
/// fontes de dados remota e cache com lógica de fallback.
class ProductRepositoryImpl implements ProductRepository {
  final ProductRemoteDatasource _remoteDatasource;
  final ProductCacheDatasource _cacheDatasource;
  final SessionManager _sessionManager;

  /// Cria um ProductRepositoryImpl com as fontes de dados informadas.
  ProductRepositoryImpl({
    required ProductRemoteDatasource remoteDatasource,
    required ProductCacheDatasource cacheDatasource,
    required SessionManager sessionManager,
  }) : _remoteDatasource = remoteDatasource,
       _cacheDatasource = cacheDatasource,
       _sessionManager = sessionManager;

  /// Busca produtos da fonte remota, com fallback de cache.
  /// Se a fonte remota falhar e existir cache, retorna os dados em cache.
  /// Lança [Failure] se a fonte remota falhar e o cache estiver vazio.
  @override
  Future<List<Product>> getProducts() async {
    try {
      final products = await _remoteDatasource.getProducts();
      _cacheDatasource.save(products);
      return products.map((model) => model.toEntity()).toList();
    } catch (e) {
      final cachedProducts = _cacheDatasource.get();
      if (cachedProducts != null && cachedProducts.isNotEmpty) {
        return cachedProducts.map((model) => model.toEntity()).toList();
      }
      if (e is Failure) rethrow;
      throw Failure('Failed to load products: ${e.toString()}');
    }
  }

  @override
  Future<Product> getProductById(int id) async {
    try {
      final model = await _remoteDatasource.getProductById(id);
      return model.toEntity();
    } catch (e) {
      if (e is Failure) rethrow;
      throw Failure('Erro ao buscar produto $id: ${e.toString()}');
    }
  }

  @override
  Future<Product> addProduct(Product product) async {
    try {
      final model = ProductModel.fromEntity(product);
      final result = await _remoteDatasource.addProduct(model);
      return result.toEntity();
    } on Failure {
      rethrow;
    } catch (e) {
      throw Failure('Falha ao adicionar produto: ${e.toString()}');
    }
  }

  @override
  Future<Product> updateProduct(Product product) async {
    try {
      final model = ProductModel.fromEntity(product);
      final result = await _remoteDatasource.updateProduct(model);
      return result.toEntity();
    } on Failure {
      rethrow;
    } catch (e) {
      throw Failure('Falha ao atualizar produto: ${e.toString()}');
    }
  }

  @override
  Future<void> deleteProduct(int id) async {
    try {
      await _remoteDatasource.deleteProduct(id);
    } on Failure {
      rethrow;
    } catch (e) {
      throw Failure('Falha ao remover produto: ${e.toString()}');
    }
  }

  @override
  Future<void> saveFavorites(List<int> favoriteIds) async {
    await _sessionManager.saveFavorites(favoriteIds);
  }

  @override
  List<int> getFavorites() {
    return _sessionManager.getFavorites();
  }
}

