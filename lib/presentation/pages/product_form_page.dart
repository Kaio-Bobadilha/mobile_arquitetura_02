import 'package:flutter/material.dart';
import '../../domain/entities/product.dart';

/// Tela de formulário para cadastro e edição de produtos.
/// Se um [product] for passado, funciona como edição; caso contrário, como cadastro.
class ProductFormPage extends StatefulWidget {
  /// Produto a ser editado. Null para cadastro de novo produto.
  final Product? product;

  const ProductFormPage({super.key, this.product});

  @override
  State<ProductFormPage> createState() => _ProductFormPageState();
}

class _ProductFormPageState extends State<ProductFormPage> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _titleController;
  late final TextEditingController _priceController;
  late final TextEditingController _descriptionController;
  late final TextEditingController _imageController;

  /// Indica se estamos no modo de edição.
  bool get isEditing => widget.product != null;

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(text: widget.product?.title ?? '');
    _priceController = TextEditingController(
      text: widget.product != null
          ? widget.product!.price.toStringAsFixed(2)
          : '',
    );
    _descriptionController = TextEditingController(
      text: widget.product?.description ?? '',
    );
    _imageController = TextEditingController(
      text: widget.product?.image ?? '',
    );
  }

  @override
  void dispose() {
    _titleController.dispose();
    _priceController.dispose();
    _descriptionController.dispose();
    _imageController.dispose();
    super.dispose();
  }

  void _submitForm() {
    if (!_formKey.currentState!.validate()) return;

    final product = Product(
      id: widget.product?.id ?? 0,
      title: _titleController.text.trim(),
      price: double.parse(_priceController.text.trim()),
      description: _descriptionController.text.trim(),
      image: _imageController.text.trim().isNotEmpty
          ? _imageController.text.trim()
          : 'https://via.placeholder.com/150',
      favorite: widget.product?.favorite ?? false,
    );

    Navigator.pop(context, product);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(isEditing ? 'Editar Produto' : 'Novo Produto'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Campo: Título
              TextFormField(
                controller: _titleController,
                decoration: const InputDecoration(
                  labelText: 'Nome do Produto',
                  hintText: 'Ex: Camiseta Azul',
                  prefixIcon: Icon(Icons.title),
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'O nome do produto é obrigatório';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),

              // Campo: Preço
              TextFormField(
                controller: _priceController,
                decoration: const InputDecoration(
                  labelText: 'Preço',
                  hintText: 'Ex: 29.90',
                  prefixIcon: Icon(Icons.attach_money),
                  border: OutlineInputBorder(),
                ),
                keyboardType: const TextInputType.numberWithOptions(decimal: true),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'O preço é obrigatório';
                  }
                  final price = double.tryParse(value.trim());
                  if (price == null || price < 0) {
                    return 'Informe um preço válido';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),

              // Campo: Descrição
              TextFormField(
                controller: _descriptionController,
                decoration: const InputDecoration(
                  labelText: 'Descrição',
                  hintText: 'Descreva o produto...',
                  prefixIcon: Icon(Icons.description),
                  border: OutlineInputBorder(),
                ),
                maxLines: 4,
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'A descrição é obrigatória';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),

              // Campo: URL da Imagem
              TextFormField(
                controller: _imageController,
                decoration: const InputDecoration(
                  labelText: 'URL da Imagem (opcional)',
                  hintText: 'https://exemplo.com/imagem.png',
                  prefixIcon: Icon(Icons.image),
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 32),

              // Botão de Salvar
              ElevatedButton.icon(
                onPressed: _submitForm,
                icon: Icon(isEditing ? Icons.save : Icons.add),
                label: Text(
                  isEditing ? 'Salvar Alterações' : 'Cadastrar Produto',
                  style: const TextStyle(fontSize: 16),
                ),
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 14),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
