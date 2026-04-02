import 'package:flutter/material.dart';
import '../../domain/entities/product.dart';

/// Widget reutilizável que exibe um único produto em um layout de tile.
/// Exibe a imagem, título, preço formatado e botões de ação.
class ProductTile extends StatelessWidget {
  /// O produto a ser exibido.
  final Product product;

  /// Callback chamado quando o botão de favorito é pressionado.
  final VoidCallback? onFavoriteToggle;

  /// Callback chamado quando o tile é clicado.
  final VoidCallback? onTap;

  /// Callback chamado quando o botão de editar é pressionado.
  final VoidCallback? onEdit;

  /// Callback chamado quando o botão de excluir é pressionado.
  final VoidCallback? onDelete;

  /// Cria um ProductTile com o produto informado.
  const ProductTile({
    super.key,
    required this.product,
    this.onFavoriteToggle,
    this.onTap,
    this.onEdit,
    this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Card(
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        elevation: 2,
        color: product.favorite ? Colors.amber[50] : null,
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Imagem do produto com tamanho fixo
              SizedBox(
                width: 80,
                height: 80,
                child: Image.network(
                  product.image,
                  fit: BoxFit.contain,
                  errorBuilder: (context, error, stackTrace) {
                    return Container(
                      color: Colors.grey[200],
                      child: const Icon(
                        Icons.image_not_supported,
                        color: Colors.grey,
                        size: 40,
                      ),
                    );
                  },
                  loadingBuilder: (context, child, loadingProgress) {
                    if (loadingProgress == null) return child;
                    return const Center(
                      child: CircularProgressIndicator(strokeWidth: 2),
                    );
                  },
                ),
              ),
              const SizedBox(width: 16),
              // Detalhes do produto
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      product.title,
                      style: Theme.of(context).textTheme.titleSmall?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'R\$ ${product.price.toStringAsFixed(2)}',
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        color: Colors.green[700],
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
              // Botões de ação
              Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  IconButton(
                    onPressed: onFavoriteToggle,
                    icon: Icon(
                      product.favorite ? Icons.star : Icons.star_border,
                      color: product.favorite ? Colors.amber[700] : Colors.grey,
                    ),
                    tooltip: product.favorite
                        ? 'Remover dos favoritos'
                        : 'Adicionar aos favoritos',
                    iconSize: 24,
                    constraints: const BoxConstraints(),
                    padding: const EdgeInsets.all(4),
                  ),
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        onPressed: onEdit,
                        icon: Icon(Icons.edit, color: Colors.blue[600]),
                        tooltip: 'Editar',
                        iconSize: 20,
                        constraints: const BoxConstraints(),
                        padding: const EdgeInsets.all(4),
                      ),
                      IconButton(
                        onPressed: onDelete,
                        icon: Icon(Icons.delete, color: Colors.red[600]),
                        tooltip: 'Excluir',
                        iconSize: 20,
                        constraints: const BoxConstraints(),
                        padding: const EdgeInsets.all(4),
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
