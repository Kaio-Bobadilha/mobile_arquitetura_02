import '../../core/errors/failure.dart';
import '../../core/network/http_client.dart';
import '../../core/network/http_headers.dart';
import '../models/user_model.dart';

/// Fonte de dados remota para autenticação via DummyJSON API.
/// Responsável por comunicação com endpoints de autenticação.
class AuthRemoteDatasource {
  final HttpClient _httpClient;

  /// URL base para a API DummyJSON.
  static const String _baseUrl = 'https://dummyjson.com';

  /// Cria um AuthRemoteDatasource com o HttpClient informado.
  AuthRemoteDatasource({required HttpClient httpClient})
    : _httpClient = httpClient;

  /// Realiza login via POST para /auth/login.
  /// Envia username e password, recebe usuário com token.
  ///
  /// Exemplo de requisição:
  /// ```
  /// POST https://dummyjson.com/auth/login
  /// Content-Type: application/json
  ///
  /// {
  ///   "username": "emilys",
  ///   "password": "emilyspass"
  /// }
  /// ```
  ///
  /// Lança [Failure] se as credenciais são inválidas ou erro de rede.
  Future<UserModel> login(String username, String password) async {
    try {
      final response = await _httpClient.post('$_baseUrl/auth/login', {
        'username': username,
        'password': password,
      });

      if (response is Map<String, dynamic>) {
        return UserModel.fromJson(response);
      } else {
        throw Failure('Invalid login response format');
      }
    } on Failure {
      rethrow;
    } catch (e) {
      throw Failure('Login failed: ${e.toString()}');
    }
  }

  /// Recupera dados do usuário autenticado via GET para /auth/me.
  /// Requer token de autenticação.
  ///
  /// Exemplo de requisição:
  /// ```
  /// GET https://dummyjson.com/auth/me
  /// Authorization: Bearer <token>
  /// Content-Type: application/json
  /// ```
  ///
  /// Lança [Failure] se token inválido ou erro de rede.
  Future<UserModel> getCurrentUser(String token) async {
    try {
      final response = await _httpClient.get(
        '$_baseUrl/auth/me',
        headers: HttpHeaders.withBearerToken(token),
      );

      if (response is Map<String, dynamic>) {
        return UserModel.fromAuthMe(response, token);
      } else {
        throw Failure('Invalid response format from /auth/me');
      }
    } on Failure {
      rethrow;
    } catch (e) {
      throw Failure('Failed to get current user: ${e.toString()}');
    }
  }
}
