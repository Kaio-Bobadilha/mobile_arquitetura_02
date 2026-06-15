import 'package:flutter/material.dart';
import '../viewmodels/product_viewmodel.dart';
import '../../core/utils/extensions.dart';
import '../../domain/entities/product.dart';

/// Tela que exibe os detalhes completos de um produto selecionado.
class ProductDetailsPage extends StatefulWidget {
  final int productId;
  final ProductViewModel productViewModel;

  const ProductDetailsPage({
    super.key,
    required this.productId,
    required this.productViewModel,
  });

  @override
  State<ProductDetailsPage> createState() => _ProductDetailsPageState();
}

class _ProductDetailsPageState extends State<ProductDetailsPage> {
  Product? _product;
  bool _isLoading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _loadProduct();
  }

  Future<void> _loadProduct() async {
    setState(() {
      _isLoading = true;
      _error = null;
    });

    try {
      final product = await widget.productViewModel.getProduct(widget.productId);
      if (product == null) {
        setState(() {
          _error = 'Produto não encontrado';
          _isLoading = false;
        });
      } else {
        setState(() {
          _product = product;
          _isLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        _error = 'Erro ao carregar detalhes do produto';
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Detalhes do Produto'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: _buildBody(),
    );
  }

  Widget _buildBody() {
    if (_isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (_error != null) {
      return _ErrorView(message: _error!, onRetry: _loadProduct);
    }

    if (_product == null) return const SizedBox.shrink();

    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _ProductHeader(product: _product!),
          const SizedBox(height: 24),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'ID do Produto: ${_product!.id}',
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(color: Colors.grey[600]),
                ),
                const SizedBox(height: 12),
                Text(
                  _product!.title,
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 16),
                PriceBadge(price: _product!.price),
                const SizedBox(height: 32),
                const SectionTitle(title: 'Informações'),
                const SizedBox(height: 12),
                FavoriteStatusCard(
                  product: _product!,
                  onToggle: () {
                    widget.productViewModel.toggleFavorite(_product!.id);
                    setState(() {
                      _product = _product?.copyWith(favorite: !_product!.favorite);
                    });
                  },
                ),
                const SizedBox(height: 32),
                const SectionTitle(title: 'Descrição'),
                const SizedBox(height: 12),
                Text(
                  _product!.description.isNotEmpty ? _product!.description : 'Sem descrição disponível.',
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: Colors.grey[700], height: 1.5),
                ),
                const SizedBox(height: 32),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    onPressed: () => Navigator.pop(context),
                    icon: const Icon(Icons.arrow_back),
                    label: const Text('Voltar para a lista', style: TextStyle(fontSize: 16)),
                    style: ElevatedButton.styleFrom(padding: const EdgeInsets.symmetric(vertical: 12)),
                  ),
                ),
                const SizedBox(height: 24),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

/// Componentes de UI extraídos para evitar repetição e facilitar manutenção.

class _ProductHeader extends StatelessWidget {
  final Product product;
  const _ProductHeader({required this.product});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 300,
      color: Colors.grey[100],
      padding: const EdgeInsets.all(16),
      child: Image.network(
        product.image,
        fit: BoxFit.contain,
        errorBuilder: (context, error, stackTrace) => Container(
          color: Colors.grey[200],
          child: const Icon(Icons.image_not_supported, size: 80, color: Colors.grey),
        ),
        loadingBuilder: (context, child, loadingProgress) {
          if (loadingProgress == null) return child;
          return const Center(child: CircularProgressIndicator());
        },
      ),
    );
  }
}

class PriceBadge extends StatelessWidget {
  final double price;
  const PriceBadge({super.key, required this.price});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.amber[50],
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.amber[300]!, width: 2),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text('R\$ ', style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w500)),
          Text(
            price.toStringAsFixed(2),
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
              fontWeight: FontWeight.bold,
              color: Colors.amber[900],
            ),
          ),
        ],
      ),
    );
  }
}

class FavoriteStatusCard extends StatelessWidget {
  final Product product;
  final VoidCallback onToggle;
  const FavoriteStatusCard({super.key, required this.product, required this.onToggle});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onToggle,
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: product.favorite ? Colors.red[50] : Colors.grey[100],
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: product.favorite ? Colors.red[300]! : Colors.grey[300]!),
        ),
        child: Row(
          children: [
            Icon(Icons.favorite, color: product.favorite ? Colors.red : Colors.grey, size: 20),
            const SizedBox(width: 12),
            Text(
              product.favorite ? 'Este produto está nos seus favoritos' : 'Adicione este produto aos favoritos',
              style: Theme.of(context).textTheme.bodyMedium,
            ),
          ],
        ),
      ),
    );
  }
}

class SectionTitle extends StatelessWidget {
  final String title;
  const SectionTitle({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return Text(
      title,
      style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
    );
  }
}

class _ErrorView extends StatelessWidget {
  final String message;
  final VoidCallback onRetry;
  const _ErrorView({required this.message, required this.onRetry});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.error_outline, size: 64, color: Colors.red.withAlpha(150)),
          const SizedBox(height: 16),
          Text(message, style: Theme.of(context).textTheme.titleLarge),
          const SizedBox(height: 24),
          ElevatedButton(onPressed: onRetry, child: const Text('Tentar Novamente')),
        ],
      ),
    );
  }
}
