import 'package:flutter/material.dart';

import 'core/network/http_client.dart';
import 'core/session/session_manager.dart';
import 'data/datasources/auth_remote_datasource.dart';
import 'data/datasources/product_remote_datasource.dart';
import 'data/datasources/product_cache_datasource.dart';
import 'data/repositories/auth_repository_impl.dart';
import 'data/repositories/product_repository_impl.dart';
import 'presentation/viewmodels/auth_viewmodel.dart';
import 'presentation/viewmodels/product_viewmodel.dart';
import 'presentation/viewmodels/theme_viewmodel.dart';
import 'presentation/pages/splash_page.dart';
import 'presentation/pages/login_page.dart';
import 'presentation/pages/product_list_page.dart';

void main() async {
  // Inicializa o SessionManager antes de rodar o app
  final sessionManager = SessionManager();
  await sessionManager.initialize();

  runApp(MyApp(sessionManager: sessionManager));
}

/// Widget principal da aplicação que configura a injeção de dependência.
class MyApp extends StatefulWidget {
  final SessionManager sessionManager;

  const MyApp({super.key, required this.sessionManager});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  AuthViewModel? _authViewModel;
  ProductViewModel? _productViewModel;
  ThemeViewModel? _themeViewModel;

  @override
  void initState() {
    super.initState();
    _initApp();
  }

  Future<void> _initApp() async {
    // Inicializa o tema
    final themeVM = ThemeViewModel();
    await themeVM.init();
    _themeViewModel = themeVM;

    // 1. Cria o HttpClient
    final httpClient = HttpClient();

    // 2. Cria os datasources
    final authRemoteDatasource = AuthRemoteDatasource(httpClient: httpClient);
    final productRemoteDatasource = ProductRemoteDatasource(
      httpClient: httpClient,
    );
    final productCacheDatasource = ProductCacheDatasource();

    // 3. Cria os repositórios
    final authRepository = AuthRepositoryImpl(
      remoteDatasource: authRemoteDatasource,
      sessionManager: widget.sessionManager,
    );

    final productRepository = ProductRepositoryImpl(
      remoteDatasource: productRemoteDatasource,
      cacheDatasource: productCacheDatasource,
      sessionManager: widget.sessionManager,
    );

    // 4. Cria os ViewModels
    _authViewModel = AuthViewModel(repository: authRepository);
    _productViewModel = ProductViewModel(repository: productRepository);

    if (mounted) {
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_themeViewModel == null || _authViewModel == null || _productViewModel == null) {
      return const MaterialApp(
        home: Scaffold(
          body: Center(child: CircularProgressIndicator()),
        ),
      );
    }

    return ValueListenableBuilder<ThemeMode>(
      valueListenable: _themeViewModel!.themeMode,
      builder: (context, mode, _) {
        return MaterialApp(
          title: 'E-Commerce App',
          debugShowCheckedModeBanner: false,
          themeMode: mode,
          theme: ThemeData(
            colorScheme: ColorScheme.fromSeed(
              seedColor: Colors.deepPurple,
              brightness: Brightness.light,
            ),
            useMaterial3: true,
          ),
          darkTheme: ThemeData(
            colorScheme: ColorScheme.fromSeed(
              seedColor: Colors.deepPurple,
              brightness: Brightness.dark,
            ),
            useMaterial3: true,
          ),
          home: SplashPage(authViewModel: _authViewModel!),
          routes: {
            '/login': (context) => LoginPage(viewModel: _authViewModel!),
            '/products': (context) => ProductListPage(
              productViewModel: _productViewModel!,
              authViewModel: _authViewModel!,
              themeViewModel: _themeViewModel!,
            ),
          },
          navigatorObservers: [
            _AuthNavigatorObserver(_authViewModel!),
          ],
        );
      },
    );
  }
}

/// Observer que redireciona para login se a autenticação for perdida
class _AuthNavigatorObserver extends NavigatorObserver {
  final AuthViewModel authViewModel;

  _AuthNavigatorObserver(this.authViewModel);

  @override
  void didPop(Route route, Route? previousRoute) {
    super.didPop(route, previousRoute);
    _checkAuth();
  }

  void _checkAuth() {
    if (!authViewModel.state.value.isAuthenticated) {
      navigator?.pushReplacementNamed('/login');
    }
  }
}
