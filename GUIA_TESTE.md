# Guia de Teste e Uso - Navegação em Múltiplas Telas

## 📱 Como Testar a Aplicação

### Pré-requisitos
- Flutter 3.9.2 ou superior
- Dart 3.9.2 ou superior
- Um emulador ou dispositivo físico

### Passos para Executar

1. **Navegue até o diretório do projeto:**
   ```bash
   cd mobile_arquitetura_01
   ```

2. **Obtenha as dependências:**
   ```bash
   flutter pub get
   ```

3. **Execute a aplicação:**
   ```bash
   flutter run
   ```

4. **Aguarde a compilação** (pode levar alguns minutos na primeira vez)

---

## 🔄 Fluxo de Teste Recomendado

### 1️⃣ Tela Inicial (HomePage)

**O que você verá:**
- Título "Bem-vindo!"
- Subtítulo descritivo
- Ícone decorativo de shopping bag
- Botão "Ver Produtos"

**O que você deve fazer:**
- Clique no botão "Ver Produtos"

**Resultado esperado:**
- Transição para a tela de listagem de produtos
- Aplicação exibe `Navigator.push()` em ação

---

### 2️⃣ Tela de Listagem de Produtos (ProductPage)

**O que você verá:**
- AppBar com título "Produtos"
- Ícone de filtro de favoritos na AppBar
- Contador de favoritos (★ X)
- Lista de produtos carregados da API
- FloatingActionButton para atualizar

**O que você pode fazer:**
1. **Ver produtos** - Scroll na lista para ver todos
2. **Marcar favorito** - Clique na estrela de cada produto
3. **Atualizar lista** - Clique no botão flutuante
4. **Filtrar favoritos** - Clique no ícone de coração na AppBar

**Interações importantes:**
- **Clique em um produto** - Navegará para a tela de detalhes
- **Clique na estrela** - Marca/desmarca como favorito (sem navegar)

**Resultado esperado:**
- Ao clicar em um produto (mas não na estrela), vai para ProductDetailsPage
- Favoritos são atualizado em tempo real

---

### 3️⃣ Tela de Detalhes do Produto (ProductDetailsPage)

**O que você verá:**
- AppBar com título "Detalhes do Produto" e botão de voltar
- Imagem grande do produto
- Informações detalhadas:
  - ID do produto
  - Título/Nome
  - Preço destacado em ouro
  - Status de favorito
  - Descrição
- Botão "Voltar para a lista"

**O que você pode fazer:**
1. **Visualizar detalhes** - Observe todas as informações
2. **Voltar à lista** - Múltiplas opções:
   - Clique no botão de seta preta na AppBar
   - Clique no botão "Voltar para a lista"
   - Use o botão de voltar físico do dispositivo (Android)

**Resultado esperado:**
- Retorna para ProductPage mantendo o estado (lista e filtros)
- Aplicação exibe `Navigator.pop()` em ação

---

## 🎯 Testes de Navegação Específicos

### Teste 1: Navegação Completa
```
HomePage → [clique Ver Produtos] → ProductPage 
→ [clique em produto] → ProductDetailsPage 
→ [clique Voltar] → ProductPage 
→ [clique seta voltar] → HomePage
```

### Teste 2: Múltiplos Produtos
```
HomePage → ProductPage 
→ [clique em Produto 1] → ProductDetailsPage 
→ [voltar] → ProductPage 
→ [clique em Produto 2] → ProductDetailsPage 
→ [voltar] → ProductPage
```

### Teste 3: Sistema de Favoritos
```
ProductPage → [marque alguns favoritos] → [clique em um] → ProductDetailsPage 
→ [voltar] → ProductPage → [clique no filtro de favoritos] 
→ [veja apenas favoritos] → [clique em um favorito] → ProductDetailsPage
```

### Teste 4: Atualização de Dados
```
ProductPage → [clique botão atualizar] → [aguarde carregamento] 
→ [clique em um produto] → ProductDetailsPage 
→ [voltar] → ProductPage [dados atualizados]
```

---

## 🔍 O Que Observar

### ✅ Comportamentos Esperados

- ✅ Transições suaves entre telas
- ✅ Botões de voltar funcionam em todas as telas
- ✅ Dados do produto são transmitidos corretamente
- ✅ Estado da listagem é preservado ao retornar (favoritos mantidos)
- ✅ Sem erros no console
- ✅ Navegação intuitiva

### ⚠️ Possíveis Problemas

Se você encontrar algum desses problemas:

1. **Erros de "null safety"**:
   - Execute `flutter pub get` novamente
   - Execute `flutter clean` e depois `flutter pub get`

2. **Imagens não carregam**:
   - Verifique sua conexão com a internet
   - A API da JSONPlaceholder está acessível?

3. **Transições lentas**:
   - Pode ser normal em emulador
   - Teste em um dispositivo físico para melhor performance

4. **Navegação não responde**:
   - Verifique se `Navigator` está sendo usado corretamente
   - Restart a aplicação completamente

---

## 📊 Verificar Estrutura de Código

### Arquivo: `lib/main.dart`
```dart
// Verifique que a HomePage é a tela inicial
home: HomePage(viewModel: viewModel),
```

### Arquivo: `lib/presentation/pages/home_page.dart`
```dart
// HomePage deve ter um botão que navega via Navigator.push()
Navigator.push(context, MaterialPageRoute(...))
```

### Arquivo: `lib/presentation/pages/product_page.dart`
```dart
// ProductPage deve navegar para ProductDetailsPage ao clicar
onTap: () {
  Navigator.push(context, MaterialPageRoute(...))
}
```

### Arquivo: `lib/presentation/pages/product_details_page.dart`
```dart
// ProductDetailsPage deve ter um botão que volta via Navigator.pop()
Navigator.pop(context)
```

---

## 🚀 Melhorias Futuras (Opcionais)

Se quiser aprofundar ainda mais, você pode implementar:

1. **Rotas Nomeadas**: Substituir `MaterialPageRoute` por rotas nomeadas
2. **Transições Personalizadas**: Adicionar animações custom entre telas
3. **Persistência de Estado**: Manter dados ao retornar
4. **Indicadores de Carregamento**: Melhorar UX em transições
5. **Tratamento de Erros**: Adicionar fallbacks para erros de conexão
6. **Testes Automatizados**: Escrever testes de navegação

---

## 📝 Documentação Adicional

- [MUDANCAS_NAVEGACAO.md](MUDANCAS_NAVEGACAO.md) - Detalhes técnicos das mudanças
- [RESPOSTAS_QUESTIONARIO.md](RESPOSTAS_QUESTIONARIO.md) - Respostas das perguntas da atividade

---

## ✨ Resumo da Implementação

| Aspecto | Antes | Depois |
|---------|-------|--------|
| **Telas** | 1 (apenas lista) | 3 (home, lista, detalhes) |
| **Navegação** | Nenhuma | Push/Pop funcional |
| **Entry Point** | ProductPage | HomePage |
| **Passagem de Dados** | N/A | Product entre telas |
| **UX** | Direto na lista | Guiado pelo fluxo |

---

## 🎓 Conceitos Aprendidos

- ✅ Estrutura de múltiplas telas em Flutter
- ✅ Navigator.push() para navegar forward
- ✅ Navigator.pop() para navegar backward
- ✅ MaterialPageRoute para transições
- ✅ Passagem de dados entre telas via construtor
- ✅ Arquitetura com separação de responsabilidades
- ✅ Estado gerenciável em múltiplas telas

---

**Bom teste! 🚀**
