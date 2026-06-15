import 'package:flutter/foundation.dart';
import 'package:collection/collection.dart';
import '../../core/errors/failure.dart';
import '../../domain/entities/product.dart';
import '../../domain/repositories/product_repository.dart';
import 'product_state.dart';

/// ViewModel que gerencia o estado de carregamento de produtos e lógica de negócio.
/// Usa ValueNotifier para notificar ouvintes sobre mudanças de estado.
class ProductViewModel {
  final ProductRepository _repository;

  /// StateNotifier que mantém o estado atual do produto.
  final ValueNotifier<ProductState> _state = ValueNotifier(
    const ProductState(),
  );

  /// Getter público para o estado a ser usado com ValueListenableBuilder.
  ValueNotifier<ProductState> get state => _state;

  /// Cria um ProductViewModel com o repositório informado.
  ProductViewModel({required ProductRepository repository})
    : _repository = repository;

  /// Carrega produtos do repositório.
  /// Atualiza o estado para carregando, então sucesso ou erro conforme o resultado.
  Future<void> loadProducts() async {
    _state.value = _state.value.copyWith(isLoading: true, error: null);

    try {
      final products = await _repository.getProducts();
      final favoriteIds = _repository.getFavorites();

      // Mescla os favoritos persistidos com os produtos da API
      final productsWithFavorites = products.map((p) {
        return p.copyWith(favorite: favoriteIds.contains(p.id));
      }).toList();

      _state.value = _state.value.copyWith(
        isLoading: false,
        products: productsWithFavorites,
        error: null,
      );
    } on Failure catch (e) {
      String friendlyMessage = e.message;
      if (e.message.contains('format')) {
        friendlyMessage = 'Erro ao processar os dados dos produtos';
      }
      _state.value = _state.value.copyWith(isLoading: false, error: friendlyMessage);
    } catch (e) {
      _state.value = _state.value.copyWith(
        isLoading: false,
        error: 'Não foi possível carregar os produtos no momento',
      );
    }
  }

  /// Busca um produto específico por ID.
  /// Tenta primeiro na lista local, senão busca no repositório.
  Future<Product?> getProduct(int id) async {
    // Tenta encontrar na lista local primeiro
    final localProduct = _state.value.products.firstWhereOrNull((p) => p.id == id);
    if (localProduct != null) return localProduct;

    try {
      return await _repository.getProductById(id);
    } catch (e) {
      return null;
    }
  }

  /// Adiciona um novo produto.
  /// Atualiza a lista local após sucesso na API.
  Future<void> addProduct(Product product) async {
    _state.value = _state.value.copyWith(isLoading: true, error: null);

    try {
      final newProduct = await _repository.addProduct(product);
      final updatedProducts = [..._state.value.products, newProduct];
      _state.value = _state.value.copyWith(
        isLoading: false,
        products: updatedProducts,
      );
    } on Failure catch (e) {
      _state.value = _state.value.copyWith(isLoading: false, error: e.message);
    } catch (e) {
      _state.value = _state.value.copyWith(
        isLoading: false,
        error: 'Não foi possível adicionar o produto',
      );
    }
  }

  /// Atualiza um produto existente.
  /// Atualiza a lista local após sucesso na API.
  Future<void> updateProduct(Product product) async {
    _state.value = _state.value.copyWith(isLoading: true, error: null);

    try {
      final updatedProduct = await _repository.updateProduct(product);
      final updatedProducts = _state.value.products.map((p) {
        return p.id == updatedProduct.id ? updatedProduct : p;
      }).toList();
      _state.value = _state.value.copyWith(
        isLoading: false,
        products: updatedProducts,
      );
    } on Failure catch (e) {
      _state.value = _state.value.copyWith(isLoading: false, error: e.message);
    } catch (e) {
      _state.value = _state.value.copyWith(
        isLoading: false,
        error: 'Não foi possível atualizar o produto',
      );
    }
  }

  /// Remove um produto pelo ID.
  /// Remove da lista local após sucesso na API.
  Future<void> deleteProduct(int id) async {
    _state.value = _state.value.copyWith(isLoading: true, error: null);

    try {
      await _repository.deleteProduct(id);
      final updatedProducts = _state.value.products
          .where((p) => p.id != id)
          .toList();
      _state.value = _state.value.copyWith(
        isLoading: false,
        products: updatedProducts,
      );
    } on Failure catch (e) {
      _state.value = _state.value.copyWith(isLoading: false, error: e.message);
    } catch (e) {
      _state.value = _state.value.copyWith(
        isLoading: false,
        error: 'Não foi possível remover o produto',
      );
    }
  }

  /// Alterna o status de favorito de um produto pelo ID.
  /// Atualiza a interface automaticamente através do ValueNotifier.
  void toggleFavorite(int productId) {
    final currentProducts = _state.value.products;

    // Atualiza a lista de produtos com o favorito alternado
    final updatedProducts = currentProducts.map((product) {
      if (product.id == productId) {
        return product.copyWith(favorite: !product.favorite);
      }
      return product;
    }).toList();

    // Persiste os IDs dos favoritos no SessionManager
    final favoriteIds = updatedProducts
        .where((p) => p.favorite)
        .map((p) => p.id)
        .toList();
    _repository.saveFavorites(favoriteIds);

    // Atualiza o estado com a nova lista de produtos
    _state.value = _state.value.copyWith(products: updatedProducts);
  }

  /// Alterna o filtro de favoritos.
  void toggleFavoritesFilter() {
    _state.value = _state.value.copyWith(
      showOnlyFavorites: !_state.value.showOnlyFavorites,
    );
  }

  /// Libera o ViewModel e seus recursos.
  void dispose() {
    _state.dispose();
  }
}

