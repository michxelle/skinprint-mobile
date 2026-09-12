import 'package:flutter_test/flutter_test.dart';

import 'package:skinprint/features/product_check/services/ingredient_parser.dart';

void main() {
  group('IngredientParser', () {
    test('parses comma separated ingredients', () {
      final result = IngredientParser.parse('Water, Glycerin, Niacinamide');

      expect(result.length, 3);

      expect(result[0].normalizedName, 'water');

      expect(result[1].normalizedName, 'glycerin');
    });

    test('normalizes Aqua to water', () {
      final result = IngredientParser.parse('Aqua, Glycerin');

      expect(result.first.normalizedName, 'water');
    });

    test('normalizes parfum to fragrance', () {
      final result = IngredientParser.parse('Parfum');

      expect(result.first.normalizedName, 'fragrance');
    });

    test('removes duplicate normalized ingredients', () {
      final result = IngredientParser.parse('Water, Aqua, Glycerin');

      expect(result.length, 2);
    });
  });
}
