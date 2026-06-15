import 'package:flutter/material.dart';
import '../viewmodels/product_viewmodel.dart';
import '../viewmodels/auth_viewmodel.dart';
import '../viewmodels/theme_viewmodel.dart';
import '../../domain/entities/product.dart';
import 'product_details_page.dart';
import 'profile_page.dart';

/// Tela de listagem de produtos com suporte a autenticação.
/// Exibe o nome do usuário no AppBar e oferece acesso ao perfil e logout.
class ProductListPage extends StatefulWidget {
  final ProductViewModel productViewModel;
  final AuthViewModel authViewModel;
  final ThemeViewModel themeViewModel;

  const ProductListPage({
    super.key,
    required this.productViewModel,
    required this.authViewModel,
    required this.themeViewModel,
  });

  @override
  State<ProductListPage> createState() => _ProductListPageState();
}

class _ProductListPageState extends State<ProductListPage> {
  @override
  void initState() {
    super.initState();
    widget.productViewModel.loadProducts();
  }

  void _handleLogout() {
    widget.authViewModel.logout();
    if (mounted) {
      Navigator.of(context).pushReplacementNamed('/login');
    }
  }

  void _handleRefresh() {
    widget.productViewModel.loadProducts();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: ValueListenableBuilder(
          valueListenable: widget.authViewModel.state,
          builder: (context, authState, _) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('Produtos'),
                if (authState.user != null)
                  Text(
                    'Olá, ${authState.user!.firstName}!',
                    style: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.normal,
                    ),
                  ),
              ],
            );
          },
        ),
        elevation: 0,
        actions: [
          // Botão de alternância de tema
          ValueListenableBuilder<ThemeMode>(
            valueListenable: widget.themeViewModel.themeMode,
            builder: (context, mode, _) {
              final isDark = mode == ThemeMode.dark;
              return IconButton(
                onPressed: () => widget.themeViewModel.toggleTheme(!isDark),
                icon: Icon(
                  isDark ? Icons.light_mode : Icons.dark_mode,
                  color: isDark ? Colors.amber : Colors.indigo,
                ),
                tooltip: 'Trocar Tema',
              );
            },
          ),
          // Botão de filtro de favoritos
          ValueListenableBuilder(
            valueListenable: widget.productViewModel.state,
            builder: (context, productState, _) {
              return IconButton(
                onPressed: () {
                  widget.productViewModel.toggleFavoritesFilter();
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(
                        productState.showOnlyFavorites
                            ? 'Exibindo apenas favoritos'
                            : 'Exibindo todos os produtos',
                      ),
                      duration: const Duration(seconds: 2),
                    ),
                  );
                },
                icon: Icon(
                  Icons.favorite,
                  color: productState.showOnlyFavorites
                      ? Colors.red
                      : Colors.grey,
                ),
                tooltip: 'Filtrar Favoritos',
              );
            },
          ),
          // Botão do perfil
          ValueListenableBuilder(
            valueListenable: widget.authViewModel.state,
            builder: (context, authState, _) {
              return Row(
                children: [
                  if (authState.user?.image != null)
                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => ProfilePage(
                              authViewModel: widget.authViewModel,
                              themeViewModel: widget.themeViewModel,
                            ),
                          ),
                        );
                      },
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 12),
                        child: CircleAvatar(
                          backgroundImage: NetworkImage(authState.user!.image!),
                          radius: 18,
                        ),
                      ),
                    )
                  else
                    IconButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => ProfilePage(
                              authViewModel: widget.authViewModel,
                              themeViewModel: widget.themeViewModel,
                            ),
                          ),
                        );
                      },
                      icon: const Icon(Icons.person),
                    ),
                  // Menu de logout
                  PopupMenuButton(
                    onSelected: (value) {
                      if (value == 'logout') {
                        _showLogoutConfirmation();
                      }
                    },
                    itemBuilder: (BuildContext context) => [
                      const PopupMenuItem(
                        value: 'logout',
                        child: Row(
                          children: [
                            Icon(Icons.logout),
                            SizedBox(width: 12),
                            Text('Sair'),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              );
            },
          ),
        ],
      ),
      body: ValueListenableBuilder(
        valueListenable: widget.productViewModel.state,
        builder: (context, productState, _) {
          if (productState.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (productState.error != null) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.error_outline,
                    size: 64,
                    color: Colors.red.withAlpha(150),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Erro ao carregar produtos',
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    productState.error!,
                    textAlign: TextAlign.center,
                    style: Theme.of(
                      context,
                    ).textTheme.bodyMedium?.copyWith(color: Colors.grey),
                  ),
                  const SizedBox(height: 24),
                  ElevatedButton.icon(
                    onPressed: _handleRefresh,
                    icon: const Icon(Icons.refresh),
                    label: const Text('Tentar Novamente'),
                  ),
                ],
              ),
            );
          }

          // Aplica o filtro de favoritos se estiver ativo
          final products = productState.showOnlyFavorites
              ? productState.products.where((p) => p.favorite).toList()
              : productState.products;

          if (products.isEmpty) {
            return Center(
              child: Text(
                productState.showOnlyFavorites
                    ? 'Você ainda não tem favoritos'
                    : 'Nenhum produto encontrado',
                style: Theme.of(context).textTheme.titleLarge,
              ),
            );
          }

          return RefreshIndicator(
            onRefresh: () async => _handleRefresh(),
            child: ListView.builder(
              padding: const EdgeInsets.all(8),
              itemCount: products.length,
              itemBuilder: (context, index) {
                final product = products[index];
                return ProductTile(
                  product: product,
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ProductDetailsPage(
                          productId: product.id,
                          productViewModel: widget.productViewModel,
                        ),
                      ),
                    );
                  },
                  onFavoriteToggle: () {
                    widget.productViewModel.toggleFavorite(product.id);
                  },
                );
              },
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _handleRefresh,
        tooltip: 'Atualizar',
        child: const Icon(Icons.refresh),
      ),
    );
  }

  void _showLogoutConfirmation() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Sair'),
        content: const Text('Tem certeza de que deseja sair?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancelar'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              _handleLogout();
            },
            child: const Text('Sair'),
          ),
        ],
      ),
    );
  }
}

class ProductTile extends StatelessWidget {
  final Product product;
  final VoidCallback onTap;
  final VoidCallback onFavoriteToggle;

  const ProductTile({
    super.key,
    required this.product,
    required this.onTap,
    required this.onFavoriteToggle,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Card(
        margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
        elevation: 2,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        child: Row(
          children: [
            ClipRRect(
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(12),
                bottomLeft: Radius.circular(12),
              ),
              child: Container(
                width: 120,
                height: 120,
                color: Colors.grey.shade200,
                child: product.image != null && product.image!.isNotEmpty
                    ? Image.network(
                        product.image!,
                        fit: BoxFit.cover,
                        loadingBuilder: (context, child, loadingProgress) {
                          if (loadingProgress == null) return child;
                          return const Center(child: CircularProgressIndicator(strokeWidth: 2));
                        },
                        errorBuilder: (context, error, stackTrace) => Container(
                          color: Colors.grey.shade300,
                          child: const Icon(Icons.image_not_supported, color: Colors.grey, size: 40),
                        ),
                      )
                    : const Icon(Icons.shopping_bag, color: Colors.grey),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      product.title,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      product.description,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(color: Colors.grey),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'R\$ ${product.price.toStringAsFixed(2)}',
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            color: Theme.of(context).colorScheme.primary,
                            fontWeight: FontWeight.bold,
                          ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(width: 8),
            IconButton(
              onPressed: onFavoriteToggle,
              icon: Icon(
                product.favorite ? Icons.favorite : Icons.favorite_border,
                color: product.favorite ? Colors.red : Colors.grey,
              ),
            ),
            const SizedBox(width: 8),
            const Padding(
              padding: EdgeInsets.all(12),
              child: Icon(Icons.arrow_forward_ios, size: 16),
            ),
          ],
        ),
      ),
    );
  }
}
