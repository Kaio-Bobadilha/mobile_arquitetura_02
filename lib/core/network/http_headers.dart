/// Classe auxiliar para construir headers HTTP com autenticação.
/// Fornece métodos estáticos para adicionar token aos headers de requisições.
class HttpHeaders {
  /// Retorna os headers com autenticação via token Bearer.
  ///
  /// Uso:
  /// ```dart
  /// final headers = HttpHeaders.withBearerToken(token);
  /// final response = await httpClient.get(url, headers: headers);
  /// ```
  static Map<String, String> withBearerToken(String token) {
    return {'Authorization': 'Bearer $token'};
  }

  /// Retorna os headers com autenticação via token Bearer e conteúdo JSON.
  static Map<String, String> withBearerTokenAndJson(String token) {
    return {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token',
    };
  }

  /// Retorna headers padrão sem autenticação.
  static Map<String, String> get defaultHeaders {
    return {'Content-Type': 'application/json'};
  }

  /// Retorna headers personalizados mesclados com valor padrão.
  static Map<String, String> merge(Map<String, String> customHeaders) {
    final headers = defaultHeaders;
    headers.addAll(customHeaders);
    return headers;
  }
}
