import 'package:flutter/material.dart';
import '../viewmodels/auth_viewmodel.dart';
import 'login_page.dart';
import 'product_list_page.dart';

/// Tela inicial que verifica se existe uma sessão ativa.
/// Se autenticado, vai direto para a listagem de produtos.
/// Se não, vai para a tela de login.
class SplashPage extends StatefulWidget {
  final AuthViewModel authViewModel;

  const SplashPage({super.key, required this.authViewModel});

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  @override
  void initState() {
    super.initState();
    _checkSession();
  }

  Future<void> _checkSession() async {
    // Aguarda um pouco para efeito visual
    await Future.delayed(const Duration(seconds: 1));

    // Verifica se há sessão ativa
    widget.authViewModel.checkSessionUser();

    if (mounted) {
      final authState = widget.authViewModel.state.value;

      // Navega para a tela apropriada
      if (authState.isAuthenticated) {
        if (mounted) {
          Navigator.of(context).pushReplacementNamed('/products');
        }
      } else {
        if (mounted) {
          Navigator.of(context).pushReplacementNamed('/login');
        }
      }
    }
  }

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
              Icon(
                Icons.shopping_bag,
                size: 80,
                color: Colors.white.withAlpha(220),
              ),
              const SizedBox(height: 24),
              Text(
                'E-Commerce',
                style: Theme.of(context).textTheme.displaySmall?.copyWith(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 48),
              const SizedBox(
                width: 40,
                height: 40,
                child: CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation(Colors.white),
                  strokeWidth: 2,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
