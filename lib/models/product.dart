/// Modelo de produto utilizado na comunicação com a API.
/// Contém os campos necessários para representar um produto,
/// além dos métodos [fromJson] e [toJson] para serialização.
class Product {
  /// Identificador único do produto.
  final int id;

  /// Nome ou título do produto.
  final String title;

  /// Preço do produto.
  final double price;

  /// Descrição detalhada do produto.
  final String description;

  /// Categoria à qual o produto pertence.
  final String category;

  /// URL da imagem do produto.
  final String image;

  /// Indica se o produto está marcado como favorito.
  final bool favorite;

  /// Cria um [Product] com as propriedades informadas.
  const Product({
    required this.id,
    required this.title,
    required this.price,
    required this.description,
    required this.category,
    required this.image,
    this.favorite = false,
  });

  /// Cria um [Product] a partir de um mapa JSON recebido da API.
  ///
  /// Exemplo de uso:
  /// ```dart
  /// final product = Product.fromJson(json.decode(response.body));
  /// ```
  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      id: json['id'] as int,
      title: json['title'] as String,
      price: (json['price'] as num).toDouble(),
      description: json['description'] as String? ?? '',
      category: json['category'] as String? ?? '',
      image: json['image'] as String? ?? '',
      favorite: json['favorite'] as bool? ?? false,
    );
  }

  /// Converte este [Product] para um mapa JSON a ser enviado à API.
  ///
  /// Exemplo de uso:
  /// ```dart
  /// final body = jsonEncode(product.toJson());
  /// ```
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'price': price,
      'description': description,
      'category': category,
      'image': image,
      'favorite': favorite,
    };
  }

  /// Cria uma cópia deste produto com os campos informados substituídos.
  Product copyWith({
    int? id,
    String? title,
    double? price,
    String? description,
    String? category,
    String? image,
    bool? favorite,
  }) {
    return Product(
      id: id ?? this.id,
      title: title ?? this.title,
      price: price ?? this.price,
      description: description ?? this.description,
      category: category ?? this.category,
      image: image ?? this.image,
      favorite: favorite ?? this.favorite,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Product &&
          runtimeType == other.runtimeType &&
          id == other.id &&
          title == other.title &&
          price == other.price &&
          description == other.description &&
          category == other.category &&
          image == other.image &&
          favorite == other.favorite;

  @override
  int get hashCode =>
      Object.hash(id, title, price, description, category, image, favorite);

  @override
  String toString() =>
      'Product(id: $id, title: $title, price: $price, '
      'description: $description, category: $category, '
      'image: $image, favorite: $favorite)';
}
