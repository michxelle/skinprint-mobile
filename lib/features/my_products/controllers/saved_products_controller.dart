import 'package:flutter/foundation.dart';

import 'package:skinprint/features/product_check/models/beauty_product.dart';
import 'package:skinprint/features/my_products/data/saved_product_repository.dart';
import 'package:skinprint/features/my_products/models/product_reaction.dart';
import 'package:skinprint/features/my_products/models/saved_product.dart';

class SavedProductsController
    extends ChangeNotifier {
  final SavedProductRepository _repository;

  SavedProductsController({
    SavedProductRepository? repository,
  }) : _repository =
            repository ??
            SavedProductRepository();

  List<SavedProduct> _products = [];

  bool _isLoading = false;
  bool _hasLoaded = false;
  String? _errorMessage;

  List<SavedProduct> get products =>
      List.unmodifiable(_products);

  bool get isLoading => _isLoading;

  bool get hasLoaded => _hasLoaded;

  String? get errorMessage =>
      _errorMessage;

  int get totalProducts =>
      _products.length;

  int get workedCount => _products
      .where(
        (product) =>
            product.reaction ==
            ProductReaction.worked,
      )
      .length;

  int get didntWorkCount => _products
      .where(
        (product) =>
            product.reaction ==
            ProductReaction.didntWork,
      )
      .length;

  int get neutralCount => _products
      .where(
        (product) =>
            product.reaction ==
            ProductReaction.neutral,
      )
      .length;

  SavedProduct? findByCode(
    String code,
  ) {
    for (final product in _products) {
      if (product.code == code) {
        return product;
      }
    }

    return null;
  }

  Future<void> loadProducts({
    bool force = false,
  }) async {
    if (_isLoading) {
      return;
    }

    if (_hasLoaded && !force) {
      return;
    }

    _isLoading = true;
    _errorMessage = null;

    notifyListeners();

    try {
      _products =
          await _repository.getAllProducts();

      _hasLoaded = true;
    } catch (_) {
      _errorMessage =
          'Couldn\'t load your saved products.';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<SavedProduct> saveProduct({
    required BeautyProduct product,
    required ProductReaction reaction,
  }) async {
    if (!_hasLoaded) {
      await loadProducts();
    }

    final saved =
        await _repository.saveProduct(
      product: product,
      reaction: reaction,
    );

    _products.removeWhere(
      (item) => item.code == saved.code,
    );

    _products.insert(
      0,
      saved,
    );

    _hasLoaded = true;

    notifyListeners();

    return saved;
  }

  Future<void> updateReaction({
    required SavedProduct product,
    required ProductReaction reaction,
  }) async {
    final updated =
        await _repository.updateReaction(
      product: product,
      reaction: reaction,
    );

    final index = _products.indexWhere(
      (item) =>
          item.code == updated.code,
    );

    if (index >= 0) {
      _products[index] = updated;
    }

    notifyListeners();
  }

  Future<void> deleteProduct(
    SavedProduct product,
  ) async {
    await _repository.deleteProduct(
      product.code,
    );

    _products.removeWhere(
      (item) =>
          item.code == product.code,
    );

    notifyListeners();
  }
}