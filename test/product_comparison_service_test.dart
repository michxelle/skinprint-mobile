import 'package:flutter_test/flutter_test.dart';

import 'package:skinprint/features/my_products/models/product_reaction.dart';
import 'package:skinprint/features/my_products/models/saved_product.dart';
import 'package:skinprint/features/product_check/models/beauty_product.dart';
import 'package:skinprint/features/product_comparison/services/product_comparison_service.dart';

void main() {
  group('ProductComparisonService', () {
    test('separates worked, didnt-work, and mixed matches', () {
      const newProduct = BeautyProduct(
        code: 'new',
        name: 'New Serum',
        brand: 'Test',
        ingredientsText:
            'Water, Glycerin, Niacinamide, '
            'Fragrance, Panthenol',
        imageUrl: '',
      );

      final history = [
        SavedProduct(
          id: 1,
          code: 'worked',
          name: 'Good Serum',
          brand: 'Brand A',
          ingredientsText: 'Water, Glycerin, Niacinamide, Panthenol',
          imageUrl: '',
          reaction: ProductReaction.worked,
          savedAt: DateTime(2026),
        ),
        SavedProduct(
          id: 2,
          code: 'bad',
          name: 'Bad Serum',
          brand: 'Brand B',
          ingredientsText: 'Water, Glycerin, Fragrance',
          imageUrl: '',
          reaction: ProductReaction.didntWork,
          savedAt: DateTime(2026),
        ),
      ];

      final result = ProductComparisonService.compare(
        newProduct: newProduct,
        history: history,
      );

      expect(
        result.workedOnlyMatches.map((match) => match.ingredient).toList(),
        containsAll(['Niacinamide', 'Panthenol']),
      );

      expect(
        result.didntWorkOnlyMatches.map((match) => match.ingredient).toList(),
        contains('Fragrance'),
      );

      expect(
        result.mixedMatches.map((match) => match.ingredient).toList(),
        containsAll(['Water', 'Glycerin']),
      );
    });

    test('does not compare product against itself', () {
      const newProduct = BeautyProduct(
        code: 'same-code',
        name: 'Same Product',
        brand: 'Test',
        ingredientsText: 'Water, Glycerin',
        imageUrl: '',
      );

      final history = [
        SavedProduct(
          id: 1,
          code: 'same-code',
          name: 'Same Product',
          brand: 'Test',
          ingredientsText: 'Water, Glycerin',
          imageUrl: '',
          reaction: ProductReaction.worked,
          savedAt: DateTime(2026),
        ),
      ];

      final result = ProductComparisonService.compare(
        newProduct: newProduct,
        history: history,
      );

      expect(result.matchedIngredientCount, 0);
    });
  });
}
