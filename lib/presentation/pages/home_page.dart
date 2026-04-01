import 'package:flutter/material.dart';
import '../viewmodels/product_viewmodel.dart';
import 'product_page.dart';

/// Tela inicial da aplicação com botão para acessar a listagem de produtos.
class HomePage extends StatelessWidget {
  /// O ViewModel que gerencia o estado do produto.
  final ProductViewModel viewModel;

  /// Cria uma HomePage com o ViewModel informado.
  const HomePage({super.key, required this.viewModel});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Theme.of(context).colorScheme.primary.withAlpha(200),
              Theme.of(context).colorScheme.secondary.withAlpha(150),
            ],
          ),
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Ícone decorativo
              Icon(
                Icons.shopping_bag_outlined,
                size: 120,
                color: Colors.white.withAlpha(220),
              ),
              const SizedBox(height: 32),

              // Título
              Text(
                'Bem-vindo!',
                style: Theme.of(context).textTheme.displaySmall?.copyWith(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 16),

              // Subtítulo
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Text(
                  'Explore nossa incrível coleção de produtos',
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    color: Colors.white.withAlpha(180),
                  ),
                ),
              ),
              const SizedBox(height: 48),

              // Botão para acessar produtos
              ElevatedButton.icon(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ProductPage(viewModel: viewModel),
                    ),
                  );
                },
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 48,
                    vertical: 16,
                  ),
                  backgroundColor: Colors.white,
                  foregroundColor: Theme.of(context).colorScheme.primary,
                ),
                icon: const Icon(Icons.arrow_forward),
                label: const Text(
                  'Ver Produtos',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ),
              const SizedBox(height: 32),

              // Texto informativo
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Text(
                  'Clique no botão acima para explorar nossos produtos e ver os detalhes de cada um.',
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: Colors.white.withAlpha(140),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
