import '../../core/session/session_manager.dart';
import '../../domain/entities/user.dart';
import '../../domain/repositories/auth_repository.dart';
import '../datasources/auth_remote_datasource.dart';
import '../models/user_model.dart';

/// Implementação do repositório de autenticação.
/// Coordena chamadas ao datasource remoto e gerenciamento de sessão.
class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDatasource _remoteDatasource;
  final SessionManager _sessionManager;

  /// Cria um AuthRepositoryImpl com as dependências informadas.
  AuthRepositoryImpl({
    required AuthRemoteDatasource remoteDatasource,
    required SessionManager sessionManager,
  }) : _remoteDatasource = remoteDatasource,
       _sessionManager = sessionManager;

  @override
  Future<User> login(String username, String password) async {
    try {
      final userModel = await _remoteDatasource.login(username, password);
      final user = userModel.toEntity();

      // Armazena usuário na sessão
      await _sessionManager.saveUserSession(userModel);

      return user;
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<User> getCurrentUser() async {
    final token = _sessionManager.getToken();
    if (token == null) {
      throw Exception('No active session');
    }

    try {
      final userModel = await _remoteDatasource.getCurrentUser(token);
      final user = userModel.toEntity();

      // Atualiza dados do usuário na sessão
      await _sessionManager.saveUserSession(userModel);

      return user;
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<void> logout() async {
    await _sessionManager.clearSession();
  }

  @override
  bool isAuthenticated() {
    return _sessionManager.getToken() != null;
  }

  @override
  User? getSessionUser() {
    return _sessionManager.getSessionUser();
  }

  @override
  String? getSessionToken() {
    return _sessionManager.getToken();
  }
}
