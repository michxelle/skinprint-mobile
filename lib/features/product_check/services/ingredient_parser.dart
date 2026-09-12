import 'package:skinprint/features/product_check/models/parsed_ingredient.dart';

class IngredientParser {
  IngredientParser._();

  static List<ParsedIngredient> parse(String ingredientsText) {
    if (ingredientsText.trim().isEmpty) {
      return [];
    }

    final rawIngredients = ingredientsText.split(RegExp(r'[,;]'));

    final parsed = <ParsedIngredient>[];

    final seenNormalizedNames = <String>{};

    for (final rawIngredient in rawIngredients) {
      final displayName = _cleanDisplayName(rawIngredient);

      if (displayName.isEmpty) {
        continue;
      }

      final normalizedName = normalize(displayName);

      if (normalizedName.isEmpty) {
        continue;
      }

      if (seenNormalizedNames.contains(normalizedName)) {
        continue;
      }

      seenNormalizedNames.add(normalizedName);

      parsed.add(
        ParsedIngredient(
          displayName: displayName,
          normalizedName: normalizedName,
        ),
      );
    }

    return parsed;
  }

  static String normalize(String ingredient) {
    var value = ingredient.toLowerCase().replaceAll('_', ' ').trim();

    // remove common cosmetic-list symbols
    value = value.replaceAll(RegExp(r'[*†‡]'), '');

    // remove percentages
    value = value.replaceAll(RegExp(r'\s+\d+(\.\d+)?%$'), '');

    // remove most punctuation for comparison
    value = value.replaceAll(RegExp(r'[()\[\]{}.]'), ' ');

    value = value.replaceAll(RegExp(r'\s+'), ' ');

    value = value.trim();

    return _canonicalizeAlias(value);
  }

  static String _cleanDisplayName(String ingredient) {
    return ingredient
        .replaceAll('_', ' ')
        .replaceAll(RegExp(r'\s+'), ' ')
        .trim();
  }

  static String _canonicalizeAlias(String value) {
    const aliases = {
      'aqua': 'water',
      'aqua water': 'water',
      'water aqua': 'water',

      'parfum': 'fragrance',
      'perfume': 'fragrance',
      'parfum fragrance': 'fragrance',
      'fragrance parfum': 'fragrance',

      'alcohol denat': 'alcohol denat',
      'denatured alcohol': 'alcohol denat',
    };

    return aliases[value] ?? value;
  }
}
