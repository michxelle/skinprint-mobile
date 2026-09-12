import 'package:skinprint/features/product_check/models/ingredient_analysis.dart';
import 'package:skinprint/features/product_check/services/ingredient_parser.dart';

class IngredientAnalyzer {
  IngredientAnalyzer._();

  static const Set<String> _fragranceKeywords = {
    'fragrance',
    'aroma',
    'limonene',
    'linalool',
    'citronellol',
    'geraniol',
    'eugenol',
    'hexyl cinnamal',
  };

  static const Set<String> _dryingAlcoholKeywords = {
    'alcohol denat',
    'ethanol',
    'ethyl alcohol',
    'sd alcohol',
    'sd alcohol 40',
    'sd alcohol 40-b',
    'isopropyl alcohol',
  };

  static ProductAnalysis analyze(String ingredientsText) {
    final parsedIngredients = IngredientParser.parse(ingredientsText);

    final flags = <IngredientFlag>[];

    for (final ingredient in parsedIngredients) {
      final normalized = ingredient.normalizedName;

      if (_matchesAny(normalized, _fragranceKeywords)) {
        flags.add(
          IngredientFlag(
            ingredient: ingredient.displayName,
            type: IngredientConcernType.fragrance,
            category: 'Fragrance',
            explanation:
                'This ingredient is fragrance-related. '
                'Some users prefer to avoid fragrance '
                'because individual skin responses can vary.',
          ),
        );

        continue;
      }

      if (_isDryingAlcohol(normalized)) {
        flags.add(
          IngredientFlag(
            ingredient: ingredient.displayName,
            type: IngredientConcernType.dryingAlcohol,
            category: 'Drying alcohol',
            explanation:
                'This ingredient belongs to a group of '
                'volatile alcohols that some users prefer '
                'to avoid in their skincare products.',
          ),
        );

        continue;
      }

      if (_isArtificialColor(normalized)) {
        flags.add(
          IngredientFlag(
            ingredient: ingredient.displayName,
            type: IngredientConcernType.artificialColor,
            category: 'Colorant',
            explanation:
                'This appears to be a cosmetic colorant. '
                'Skinprint highlights it so you can compare '
                'it with your personal product history.',
          ),
        );
      }
    }

    return ProductAnalysis(
      ingredients: parsedIngredients
          .map((ingredient) => ingredient.displayName)
          .toList(),
      flags: flags,
    );
  }

  static bool _matchesAny(String ingredient, Set<String> keywords) {
    for (final keyword in keywords) {
      if (ingredient == keyword ||
          ingredient.startsWith('$keyword ') ||
          ingredient.contains(' $keyword')) {
        return true;
      }
    }

    return false;
  }

  static bool _isDryingAlcohol(String ingredient) {
    const fattyAlcohols = {
      'cetyl alcohol',
      'cetearyl alcohol',
      'stearyl alcohol',
      'behenyl alcohol',
      'lauryl alcohol',
    };

    if (_matchesAny(ingredient, fattyAlcohols)) {
      return false;
    }

    return _matchesAny(ingredient, _dryingAlcoholKeywords);
  }

  static bool _isArtificialColor(String ingredient) {
    final ciColorPattern = RegExp(r'\bci\s?\d{5}\b', caseSensitive: false);

    final namedColorPattern = RegExp(
      r'\b(red|yellow|blue|green)\s?\d+\b',
      caseSensitive: false,
    );

    final fdAndCPattern = RegExp(r'\b(fdc|fd&c|d&c)\b', caseSensitive: false);

    return ciColorPattern.hasMatch(ingredient) ||
        namedColorPattern.hasMatch(ingredient) ||
        fdAndCPattern.hasMatch(ingredient);
  }
}
