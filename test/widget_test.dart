import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:mobile_arquitetura_01/domain/entities/product.dart';
import 'package:mobile_arquitetura_01/domain/repositories/product_repository.dart';
import 'package:mobile_arquitetura_01/presentation/viewmodels/product_viewmodel.dart';
import 'package:mobile_arquitetura_01/presentation/pages/product_page.dart';

// Mock class for ProductRepository
class MockProductRepository extends Mock implements ProductRepository {}

void main() {
  late MockProductRepository mockRepository;

  setUp(() {
    mockRepository = MockProductRepository();
  });

  group('ProductPage Widget Tests', () {
    testWidgets('should show error message when there is an error', (WidgetTester tester) async {
      // Arrange
      when(() => mockRepository.getProducts()).thenThrow(
        Exception('Network error'),
      );

      final viewModel = ProductViewModel(repository: mockRepository);

      // Act
      await tester.pumpWidget(
        MaterialApp(
          home: ProductPage(viewModel: viewModel),
        ),
      );

      await viewModel.loadProducts();
      await tester.pumpAndSettle();

      // Assert - should show error message
      expect(find.text('Não foi possível carregar os produtos'), findsOneWidget);
      expect(find.byIcon(Icons.error_outline), findsOneWidget);
      expect(find.text('Tentar novamente'), findsOneWidget);

      // Cleanup
      viewModel.dispose();
    });

    testWidgets('should show empty message when no products', (WidgetTester tester) async {
      // Arrange
      when(() => mockRepository.getProducts()).thenAnswer((_) async => []);

      final viewModel = ProductViewModel(repository: mockRepository);

      // Act
      await tester.pumpWidget(
        MaterialApp(
          home: ProductPage(viewModel: viewModel),
        ),
      );

      await viewModel.loadProducts();
      await tester.pumpAndSettle();

      // Assert - should show empty message
      expect(find.text('Nenhum produto encontrado'), findsOneWidget);
      expect(find.byIcon(Icons.inventory_2_outlined), findsOneWidget);

      // Cleanup
      viewModel.dispose();
    });

    testWidgets('should show list of products when loaded successfully', (WidgetTester tester) async {
      // Arrange
      final testProducts = [
        const Product(id: 1, title: 'Product 1', price: 10.0, image: 'http://example.com/1.jpg'),
        const Product(id: 2, title: 'Product 2', price: 20.0, image: 'http://example.com/2.jpg'),
      ];

      when(() => mockRepository.getProducts()).thenAnswer((_) async => testProducts);

      final viewModel = ProductViewModel(repository: mockRepository);

      // Act
      await tester.pumpWidget(
        MaterialApp(
          home: ProductPage(viewModel: viewModel),
        ),
      );

      await viewModel.loadProducts();
      await tester.pumpAndSettle();

      // Assert - should show products
      expect(find.text('Product 1'), findsOneWidget);
      expect(find.text('Product 2'), findsOneWidget);
      expect(find.text('\$10.00'), findsOneWidget);
      expect(find.text('\$20.00'), findsOneWidget);

      // Cleanup
      viewModel.dispose();
    });

    testWidgets('should have app bar with title', (WidgetTester tester) async {
      // Arrange
      when(() => mockRepository.getProducts()).thenAnswer((_) async => []);

      final viewModel = ProductViewModel(repository: mockRepository);

      // Act
      await tester.pumpWidget(
        MaterialApp(
          home: ProductPage(viewModel: viewModel),
        ),
      );

      await viewModel.loadProducts();
      await tester.pumpAndSettle();

      // Assert
      expect(find.text('Produtos'), findsOneWidget);

      // Cleanup
      viewModel.dispose();
    });

    testWidgets('should have floating action button to refresh', (WidgetTester tester) async {
      // Arrange
      when(() => mockRepository.getProducts()).thenAnswer((_) async => []);

      final viewModel = ProductViewModel(repository: mockRepository);

      // Act
      await tester.pumpWidget(
        MaterialApp(
          home: ProductPage(viewModel: viewModel),
        ),
      );

      await viewModel.loadProducts();
      await tester.pumpAndSettle();

      // Assert - agora temos 2 FABs (refresh e add)
      expect(find.byType(FloatingActionButton), findsNWidgets(2));
      expect(find.byIcon(Icons.refresh), findsAtLeast(1));
      expect(find.byIcon(Icons.add), findsOneWidget);

      // Cleanup
      viewModel.dispose();
    });
  });
}

