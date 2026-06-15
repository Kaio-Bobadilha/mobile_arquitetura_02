/// Utilitário simples para traduzir termos comuns da API DummyJSON para Português.
class Translator {
  static final Map<String, String> _productTranslations = {
    'Essence Doe': 'Essência do Ser',
    'Collette': 'Collete Elegante',
    'Restored Battery': 'Bateria Restaurada',
    'Composite Component': 'Componente Composto',
    'Wooden Chair': 'Cadeira de Madeira',
    'Double-Sided Tape': 'Fita Dupla Face',
    'Gel Pen': 'Caneta em Gel',
    'Leather Wallet': 'Carteira de Couro',
    'T-Shirt': 'Camiseta Casual',
    'Running Shoes': 'Tênis de Corrida',
  };

  static String translateProduct(String text) {
    if (text == null || text.isEmpty) return text;

    // Tenta tradução direta do mapa
    if (_productTranslations.containsKey(text)) {
      return _productTranslations[text]!;
    }

    // Traduções genéricas simples para descrições
    String translated = text;
    translated = translated.replaceAll('and', 'e');
    translated = translated.replaceAll('with', 'com');
    translated = translated.replaceAll('the', 'o');
    translated = translated.replaceAll('a ', 'um ');
    translated = translated.replaceAll('of', 'de');
    translated = translated.replaceAll('for', 'para');
    translated = translated.replaceAll('is', 'é');

    return translated;
  }
}
