import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../../domain/entities/user.dart';
import '../../data/models/user_model.dart';

/// SessionManager é responsável por persistir a sessão do usuário localmente.
/// Utiliza shared_preferences para salvar o token e os dados do usuário.
class SessionManager {
  static const String _userKey = 'auth_user_data';
  static const String _tokenKey = 'auth_token';
  static const String _favoritesKey = 'product_favorites';

  late SharedPreferences _prefs;

  /// Inicializa o SharedPreferences. Deve ser chamado no main().
  Future<void> initialize() async {
    _prefs = await SharedPreferences.getInstance();
  }

  /// Salva os dados do usuário e o token na persistência local.
  Future<void> saveUserSession(UserModel user) async {
    final userJson = jsonEncode(user.toJson());
    await _prefs.setString(_userKey, userJson);
    await _prefs.setString(_tokenKey, user.token);
  }

  /// Recupera o usuário da sessão local.
  User? getSessionUser() {
    final userJson = _prefs.getString(_userKey);
    if (userJson == null) return null;

    try {
      final Map<String, dynamic> decoded = jsonDecode(userJson);
      final userModel = UserModel.fromJson(decoded);
      return userModel.toEntity();
    } catch (e) {
      return null;
    }
  }

  /// Recupera apenas o token de autenticação.
  String? getToken() {
    return _prefs.getString(_tokenKey);
  }

  /// Limpa todos os dados da sessão (Logout).
  Future<void> clearSession() async {
    await _prefs.remove(_userKey);
    await _prefs.remove(_tokenKey);
    await _prefs.remove(_favoritesKey);
  }

  /// Salva a lista de IDs de produtos favoritos.
  Future<void> saveFavorites(List<int> favoriteIds) async {
    await _prefs.setStringList(_favoritesKey, favoriteIds.map((id) => id.toString()).toList());
  }

  /// Recupera a lista de IDs de produtos favoritos.
  List<int> getFavorites() {
    final strings = _prefs.getStringList(_favoritesKey) ?? [];
    return strings.map((s) => int.parse(s)).toList();
  }
}
