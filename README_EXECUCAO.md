# Guia de Execução do Projeto - E-Commerce App

Este guia fornece instruções passo a passo para configurar e executar o projeto de E-Commerce desenvolvido em Flutter.

## Pré-requisitos

Antes de começar, certifique-se de ter instalado em sua máquina:

1. **Flutter SDK**: [Instruções de Instalação](https://docs.flutter.dev/get-started/install)
2. **Dart SDK** (incluído no Flutter)
3. **IDE Recomendada**: VS Code (com extensões Flutter/Dart) ou Android Studio.
4. **Emulador ou Dispositivo Físico**: Um emulador Android/iOS configurado ou um dispositivo real conectado via USB.

## Configuração do Projeto

Siga os passos abaixo para preparar o ambiente:

### 1. Clonar o Repositório
Abra o terminal e execute:
```bash
git clone <url-do-repositorio>
cd mobile_arquitetura_01
```

### 2. Instalar Dependências
Baixe todos os pacotes necessários definidos no `pubspec.yaml`:
```bash
flutter pub get
```

## Executando a Aplicação

### Via Terminal
Com o dispositivo conectado ou emulador aberto:
```bash
flutter run
```

### Via IDE (VS Code)
1. Abra a pasta do projeto.
2. Pressione `F5` ou vá até a aba **Run and Debug** $\rightarrow$ **Start Debugging**.

---

## Dados de Teste (Login)

A API DummyJSON fornece usuários de teste. Use as seguintes credenciais na tela de login:

- **Usuário:** `emilys`
- **Senha:** `emilyspass`

---

## Funcionalidades Implementadas

O aplicativo conta com as seguintes funcionalidades principais:

- **Autenticação**: Sistema de login com persistência de sessão.
- **Catálogo de Produtos**: Listagem de produtos com opção de marcar favoritos.
- **Detalhes do Produto**: Visualização detalhada de cada item.
- **Perfil do Usuário**: Página de perfil com informações do usuário logado.
- **Troca de Tema**: Alternância entre Modo Claro e Modo Escuro (acessível via botão na AppBar da lista de produtos ou switch no perfil).

## Estrutura do Projeto (Arquitetura)

O projeto segue princípios de separação de responsabilidades:

- `lib/core`: Configurações globais, clientes HTTP e gerenciamento de sessão.
- `lib/data`: Implementações de datasources (remoto/cache) e repositórios.
- `lib/domain`: Entidades de negócio e definições de repositórios (contratos).
- `lib/presentation`: Interface do usuário (UI), ViewModels para lógica de estado e Páginas.

---

**Dica**: Se encontrar erros de dependências, tente rodar `flutter clean` seguido de `flutter pub get`.
