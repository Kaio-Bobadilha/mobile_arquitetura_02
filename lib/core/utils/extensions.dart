/// Extensões utilitárias para tipos nativos do Dart.
extension FirstWhereOrNull<T> on List<T> {
  /// Retorna o primeiro elemento que atenda à condição, ou null se nenhum for encontrado.
  T? firstWhereOrNull(bool Function(T) test) {
    for (final element in this) {
      if (test(element)) {
        return element;
      }
    }
    return null;
  }
}
