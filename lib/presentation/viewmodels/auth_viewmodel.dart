import 'package:flutter/foundation.dart';
import '../../core/errors/failure.dart';
import '../../domain/repositories/auth_repository.dart';
import 'auth_state.dart';

/// ViewModel que gerencia o estado e lógica de autenticação.
/// Usa ValueNotifier para notificar ouvintes sobre mudanças de estado.
class AuthViewModel {
  final AuthRepository _repository;

  /// StateNotifier que mantém o estado atual de autenticação.
  final ValueNotifier<AuthState> _state = ValueNotifier(
    const AuthState.initial(),
  );

  /// Getter público para o estado a ser usado com ValueListenableBuilder.
  ValueNotifier<AuthState> get state => _state;

  /// Cria um AuthViewModel com o repositório informado.
  AuthViewModel({required AuthRepository repository})
    : _repository = repository;

  /// Realiza login com username e password.
  /// Atualiza o estado para sucesso ou erro conforme o resultado.
  Future<void> login(String username, String password) async {
    // Valida campos
    if (username.isEmpty || password.isEmpty) {
      _state.value = _state.value.copyWith(
        error: 'Usuário e senha são obrigatórios',
        isLoading: false,
      );
      return;
    }

    // Define estado de carregamento
    _state.value = _state.value.copyWith(isLoading: true, error: null);

    try {
      final user = await _repository.login(username, password);

      // Define estado de sucesso
      _state.value = _state.value.copyWith(
        isLoading: false,
        user: user,
        error: null,
      );
    } on Failure catch (e) {
      // Traduz mensagens de falha para algo mais humano
      String friendlyMessage = e.message;
      if (e.message.contains('Invalid credentials') || e.message.contains('400')) {
        friendlyMessage = 'Usuário ou senha incorretos';
      } else if (e.message.contains('Network')) {
        friendlyMessage = 'Problema de conexão. Verifique sua internet';
      }

      _state.value = _state.value.copyWith(isLoading: false, error: friendlyMessage);
    } catch (e) {
      _state.value = _state.value.copyWith(
        isLoading: false,
        error: 'Ocorreu um erro inesperado. Tente novamente',
      );
    }
  }

  /// Carrega dados do usuário autenticado a partir do token.
  /// Útil para sincronizar dados após desligamento.
  Future<void> loadCurrentUser() async {
    _state.value = _state.value.copyWith(isLoading: true, error: null);

    try {
      final user = await _repository.getCurrentUser();

      _state.value = _state.value.copyWith(
        isLoading: false,
        user: user,
        error: null,
      );
    } on Failure catch (e) {
      String friendlyMessage = e.message;
      if (e.message.contains('401')) {
        friendlyMessage = 'Sessão expirada. Por favor, faça login novamente.';
        await logout();
      }
      _state.value = _state.value.copyWith(isLoading: false, error: friendlyMessage);
    } catch (e) {
      _state.value = _state.value.copyWith(
        isLoading: false,
        error: 'Falha ao carregar usuário: ${e.toString()}',
      );
    }
  }

  /// Realiza logout do usuário.
  /// Limpa a sessão e o estado.
  Future<void> logout() async {
    try {
      await _repository.logout();
      _state.value = const AuthState.initial();
    } catch (e) {
      _state.value = _state.value.copyWith(
        error: 'Falha no logout: ${e.toString()}',
      );
    }
  }

  /// Recupera o usuário da sessão sem fazer requisição à API.
  /// Útil para verificar estado inicial da app.
  void checkSessionUser() {
    final user = _repository.getSessionUser();
    if (user != null) {
      _state.value = _state.value.copyWith(user: user);
    }
  }

  /// Limpa a mensagem de erro.
  void clearError() {
    _state.value = _state.value.copyWith(error: null);
  }
}
