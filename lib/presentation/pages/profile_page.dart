import 'package:flutter/material.dart';
import '../viewmodels/auth_viewmodel.dart';
import '../viewmodels/theme_viewmodel.dart';

/// Tela de perfil do usuário autenticado.
/// Exibe informações recuperadas do endpoint /auth/me.
class ProfilePage extends StatefulWidget {
  final AuthViewModel authViewModel;
  final ThemeViewModel themeViewModel;

  const ProfilePage({super.key, required this.authViewModel, required this.themeViewModel});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  @override
  void initState() {
    super.initState();
    // Carrega dados atualizados do servidor
    widget.authViewModel.loadCurrentUser();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Perfil'),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: ValueListenableBuilder(
        valueListenable: widget.authViewModel.state,
        builder: (context, authState, _) {
          final user = authState.user;

          if (authState.isLoading && user == null) {
            return const Center(child: CircularProgressIndicator());
          }

          if (user == null && authState.error != null) {
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
                    'Erro ao carregar perfil',
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  const SizedBox(height: 8),
                  Text(authState.error!, textAlign: TextAlign.center),
                  const SizedBox(height: 24),
                  ElevatedButton.icon(
                    onPressed: widget.authViewModel.loadCurrentUser,
                    icon: const Icon(Icons.refresh),
                    label: const Text('Tentar Novamente'),
                  ),
                ],
              ),
            );
          }

          if (user == null) {
            return const Center(child: Text('Usuário não autenticado'));
          }

          return SingleChildScrollView(
            child: Column(
              children: [
                // Cabeçalho com imagem
                Container(
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
                  padding: const EdgeInsets.all(24),
                  child: Column(
                    children: [
                      // Avatar
                      Container(
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(color: Colors.white, width: 4),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withAlpha(51),
                              blurRadius: 10,
                              offset: const Offset(0, 4),
                            ),
                          ],
                        ),
                        child: user.image != null
                            ? CircleAvatar(
                                radius: 60,
                                backgroundImage: NetworkImage(user.image!),
                              )
                            : CircleAvatar(
                                radius: 60,
                                child: Icon(
                                  Icons.person,
                                  size: 40,
                                  color: Theme.of(context).colorScheme.primary,
                                ),
                              ),
                      ),
                      const SizedBox(height: 16),
                      // Nome
                      Text(
                        user.fullName,
                        style: Theme.of(context).textTheme.displaySmall
                            ?.copyWith(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 4),
                      // Username
                      Text(
                        '@${user.username}',
                        style: Theme.of(
                          context,
                        ).textTheme.bodyLarge?.copyWith(color: Colors.white70),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 24),
                // Informações
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: Column(
                    children: [
                      // Email
                      _buildInfoCard(
                        context: context,
                        icon: Icons.email,
                        label: 'Email',
                        value: user.email,
                      ),
                      const SizedBox(height: 12),
                      // ID
                      _buildInfoCard(
                        context: context,
                        icon: Icons.badge,
                        label: 'ID',
                        value: user.id.toString(),
                      ),
                      const SizedBox(height: 12),
                      // Username
                      _buildInfoCard(
                        context: context,
                        icon: Icons.account_circle,
                        label: 'Usuário',
                        value: user.username,
                      ),
                      const SizedBox(height: 12),
                      // Tema Escuro Toggle
                      _buildThemeToggle(context),
                    ],
                  ),
                ),
                const SizedBox(height: 24),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildThemeToggle(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.grey.shade50,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade200),
      ),
      padding: const EdgeInsets.all(16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.primary.withAlpha(51),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Icon(Icons.dark_mode),
              ),
              const SizedBox(width: 16),
              const Text(
                'Modo Escuro',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            ],
          ),
          Switch(
            value: widget.themeViewModel.themeMode.value == ThemeMode.dark,
            onChanged: (value) {
              widget.themeViewModel.toggleTheme(value);
            },
          ),
        ],
      ),
    );
  }

  Widget _buildInfoCard({
    required BuildContext context,
    required IconData icon,
    required String label,
    required String value,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.grey.shade50,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade200),
      ),
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.primary.withAlpha(51),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(icon, color: Theme.of(context).colorScheme.primary),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: Theme.of(
                    context,
                  ).textTheme.bodySmall?.copyWith(color: Colors.grey),
                ),
                const SizedBox(height: 4),
                Text(
                  value,
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
