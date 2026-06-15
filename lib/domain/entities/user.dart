/// Entidade imutável representando um usuário autenticado.
class User {
  /// Identificador único do usuário
  final int id;

  /// Nome do usuário
  final String firstName;

  /// Sobrenome do usuário
  final String lastName;

  /// Email do usuário
  final String email;

  /// Username do usuário
  final String username;

  /// URL da foto do usuário
  final String? image;

  /// Token JWT para autenticação
  final String token;

  /// Cria um User imutável com as propriedades informadas.
  const User({
    required this.id,
    required this.firstName,
    required this.lastName,
    required this.email,
    required this.username,
    this.image,
    required this.token,
  });

  /// Retorna o nome completo do usuário
  String get fullName => '$firstName $lastName';

  /// Cria uma cópia deste usuário com os campos informados substituídos.
  User copyWith({
    int? id,
    String? firstName,
    String? lastName,
    String? email,
    String? username,
    String? image,
    String? token,
  }) {
    return User(
      id: id ?? this.id,
      firstName: firstName ?? this.firstName,
      lastName: lastName ?? this.lastName,
      email: email ?? this.email,
      username: username ?? this.username,
      image: image ?? this.image,
      token: token ?? this.token,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is User &&
          runtimeType == other.runtimeType &&
          id == other.id &&
          token == other.token;

  @override
  int get hashCode => id.hashCode ^ token.hashCode;
}
