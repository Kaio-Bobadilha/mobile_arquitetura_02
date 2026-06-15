import '../../domain/entities/user.dart';

/// Classe de estado para gerenciar o estado de autenticação da aplicação.
/// Armazena informações sobre o processo de autenticação e estado da sessão.
class AuthState {
  /// Usuário autenticado (null se não autenticado)
  final User? user;

  /// Indica se a autenticação está em andamento
  final bool isLoading;

  /// Mensagem de erro (null se sem erro)
  final String? error;

  /// Cria um AuthState com as propriedades informadas.
  const AuthState({this.user, this.isLoading = false, this.error});

  /// Estado inicial (não autenticado, sem carregamento, sem erro)
  const AuthState.initial() : user = null, isLoading = false, error = null;

  /// Estado de carregamento
  AuthState copyWith({User? user, bool? isLoading, String? error}) {
    return AuthState(
      user: user ?? this.user,
      isLoading: isLoading ?? this.isLoading,
      error: error ?? this.error,
    );
  }

  /// Verifica se o usuário está autenticado
  bool get isAuthenticated => user != null;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is AuthState &&
          runtimeType == other.runtimeType &&
          user == other.user &&
          isLoading == other.isLoading &&
          error == other.error;

  @override
  int get hashCode => user.hashCode ^ isLoading.hashCode ^ error.hashCode;
}
