import '../../domain/entities/user.dart';

/// Interface abstrata para o repositório de autenticação.
/// Define as operações que podem ser realizadas com autenticação.
abstract class AuthRepository {
  /// Realiza login com username e password.
  /// Retorna o usuário autenticado com token.
  /// Lança exceção em caso de credenciais inválidas.
  Future<User> login(String username, String password);

  /// Recupera os dados do usuário autenticado a partir do token.
  /// Requer que o usuário já esteja autenticado.
  Future<User> getCurrentUser();

  /// Realiza logout do usuário autenticado.
  Future<void> logout();

  /// Verifica se existe uma sessão ativa.
  bool isAuthenticated();

  /// Recupera o usuário da sessão local (sem chamada à API).
  User? getSessionUser();

  /// Recupera o token da sessão local.
  String? getSessionToken();
}
