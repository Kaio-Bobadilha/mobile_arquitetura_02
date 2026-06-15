import '../../domain/entities/user.dart';

/// Modelo de Usuário utilizado na comunicação com a API.
/// Contém os campos necessários para representar um usuário,
/// além dos métodos [fromJson] e [toJson] para serialização.
class UserModel extends User {
  /// Cria um [UserModel] com as propriedades informadas.
  const UserModel({
    required int id,
    required String firstName,
    required String lastName,
    required String email,
    required String username,
    String? image,
    required String token,
  }) : super(
         id: id,
         firstName: firstName,
         lastName: lastName,
         email: email,
         username: username,
         image: image,
         token: token,
       );

  /// Cria um [UserModel] a partir de um mapa JSON recebido da API.
  ///
  /// Exemplo de resposta da API DummyJSON /auth/login:
  /// ```json
  /// {
  ///   "id": 1,
  ///   "firstName": "Emily",
  ///   "lastName": "Johnson",
  ///   "email": "emily.johnson@x.dummyjson.com",
  ///   "username": "emilys",
  ///   "image": "https://dummyjson.com/icon/emilys/128",
  ///   "token": "eyJhbGc..."
  /// }
  /// ```
  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'] as int,
      firstName: json['firstName'] as String? ?? '',
      lastName: json['lastName'] as String? ?? '',
      email: json['email'] as String? ?? '',
      username: json['username'] as String? ?? '',
      image: json['image'] as String?,
      token: json['token'] as String? ?? '',
    );
  }

  /// Cria um [UserModel] a partir da resposta do endpoint /auth/me.
  /// Este endpoint retorna dados adicionais do usuário autenticado.
  factory UserModel.fromAuthMe(Map<String, dynamic> json, String token) {
    return UserModel(
      id: json['id'] as int,
      firstName: json['firstName'] as String? ?? '',
      lastName: json['lastName'] as String? ?? '',
      email: json['email'] as String? ?? '',
      username: json['username'] as String? ?? '',
      image: json['image'] as String?,
      token: token,
    );
  }

  /// Converte este [UserModel] para um mapa JSON.
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'firstName': firstName,
      'lastName': lastName,
      'email': email,
      'username': username,
      'image': image,
      'token': token,
    };
  }

  /// Converte para entidade User padrão
  User toEntity() => User(
    id: id,
    firstName: firstName,
    lastName: lastName,
    email: email,
    username: username,
    image: image,
    token: token,
  );
}
