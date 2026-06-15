import '../../core/network/http_client.dart';
import '../models/product_model.dart';

/// Fonte de dados remota para buscar produtos da API DummyJSON.
class ProductRemoteDatasource {
  final HttpClient _httpClient;

  /// URL base para a API DummyJSON.
  static const String _baseUrl = 'https://dummyjson.com';

  /// Cria um ProductRemoteDatasource com o HttpClient informado.
  ProductRemoteDatasource({required HttpClient httpClient})
    : _httpClient = httpClient;

  /// Busca todos os produtos da API remota.
  /// Retorna uma lista de [ProductModel].
  /// A API DummyJSON retorna um objeto com a chave 'products' contendo a lista.
  Future<List<ProductModel>> getProducts() async {
    final response = await _httpClient.get('$_baseUrl/products?limit=0');

    if (response is Map<String, dynamic>) {
      final products = response['products'] as List?;
      if (products != null) {
        return products
            .map((json) => ProductModel.fromJson(json as Map<String, dynamic>))
            .toList();
      }
    }
    throw Exception('Invalid response format');
  }

  /// Busca um produto específico pelo ID.
  /// Retorna um [ProductModel].
  Future<ProductModel> getProductById(int id) async {
    final response = await _httpClient.get('$_baseUrl/products/$id');

    if (response is Map<String, dynamic>) {
      return ProductModel.fromJson(response);
    } else {
      throw Exception('Invalid response format');
    }
  }

  /// Adiciona um novo produto via POST.
  /// Retorna o [ProductModel] criado pela API.
  Future<ProductModel> addProduct(ProductModel product) async {
    final response = await _httpClient.post(
      '$_baseUrl/products/add',
      product.toJson(),
    );

    return ProductModel.fromJson(response as Map<String, dynamic>);
  }

  /// Atualiza um produto existente via PUT.
  /// Retorna o [ProductModel] atualizado pela API.
  Future<ProductModel> updateProduct(ProductModel product) async {
    final response = await _httpClient.put(
      '$_baseUrl/products/${product.id}',
      product.toJson(),
    );

    return ProductModel.fromJson(response as Map<String, dynamic>);
  }

  /// Remove um produto via DELETE.
  Future<void> deleteProduct(int id) async {
    await _httpClient.delete('$_baseUrl/products/$id');
  }
}
