import '../../domain/entities/product.dart';
import '../../core/utils/translator.dart';

/// Modelo de dados para Product com serialização/deserialização JSON.
/// Estende a entidade de domínio [Product] com capacidades da camada de dados.
class ProductModel extends Product {
  /// Cria um ProductModel com as propriedades informadas.
  const ProductModel({
    required super.id,
    required super.title,
    required super.price,
    super.description = '',
    required super.image,
    super.favorite = false,
  });

  /// Cria um [ProductModel] a partir de um mapa JSON.
  /// Lança [FormatException] caso o JSON seja inválido ou ausente campos obrigatórios.
  factory ProductModel.fromJson(Map<String, dynamic> json) {
    if (json == null) {
      throw const FormatException('JSON cannot be null');
    }

    return ProductModel(
      id: json['id'] as int? ?? 0,
      title: Translator.translateProduct(json['title'] as String? ?? 'Produto sem título'),
      price: (json['price'] as num? ?? 0.0).toDouble(),
      description: Translator.translateProduct(json['description'] as String? ?? ''),
      image: json['image'] as String? ?? 'https://via.placeholder.com/150',
      favorite: json['favorite'] as bool? ?? false,
    );
  }

  /// Converte este [ProductModel] para um mapa JSON.
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'price': price,
      'description': description,
      'image': image,
      'favorite': favorite,
    };
  }

  /// Cria um [ProductModel] a partir de uma entidade de domínio [Product].
  factory ProductModel.fromEntity(Product product) {
    return ProductModel(
      id: product.id,
      title: product.title,
      price: product.price,
      description: product.description,
      image: product.image,
      favorite: product.favorite,
    );
  }

  /// Converte este modelo para uma entidade de domínio [Product].
  Product toEntity() {
    return Product(
      id: id,
      title: title,
      price: price,
      description: description,
      image: image,
      favorite: favorite,
    );
  }
}

