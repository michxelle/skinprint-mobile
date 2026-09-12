import 'package:skinprint/features/my_products/models/product_reaction.dart';
import 'package:skinprint/features/my_products/models/saved_product.dart';
import 'package:skinprint/features/product_check/models/beauty_product.dart';
import 'package:skinprint/features/product_check/services/ingredient_parser.dart';
import 'package:skinprint/features/product_comparison/models/product_history_comparison.dart';

class ProductComparisonService {
  ProductComparisonService._();

  static ProductHistoryComparison compare({
    required BeautyProduct newProduct,
    required List<SavedProduct> history,
  }) {
    final newIngredients = IngredientParser.parse(newProduct.ingredientsText);

    final relevantHistory = history
        .where((savedProduct) => savedProduct.code != newProduct.code)
        .toList();

    final allHistoryIngredientNames = <String>{};

    for (final product in relevantHistory) {
      final parsed = IngredientParser.parse(product.ingredientsText);

      allHistoryIngredientNames.addAll(
        parsed.map((ingredient) => ingredient.normalizedName),
      );
    }

    final workedProducts = relevantHistory
        .where((product) => product.reaction == ProductReaction.worked)
        .map(_HistoryIngredientSet.fromProduct)
        .toList();

    final didntWorkProducts = relevantHistory
        .where((product) => product.reaction == ProductReaction.didntWork)
        .map(_HistoryIngredientSet.fromProduct)
        .toList();

    final neutralProducts = relevantHistory
        .where((product) => product.reaction == ProductReaction.neutral)
        .length;

    final workedOnlyMatches = <IngredientHistoryMatch>[];

    final didntWorkOnlyMatches = <IngredientHistoryMatch>[];

    final mixedMatches = <IngredientHistoryMatch>[];

    final unseenIngredients = <String>[];

    for (final ingredient in newIngredients) {
      if (!allHistoryIngredientNames.contains(ingredient.normalizedName)) {
        unseenIngredients.add(ingredient.displayName);
      }
      final workedNames = workedProducts
          .where(
            (product) =>
                product.ingredients.contains(ingredient.normalizedName),
          )
          .map((product) => product.productName)
          .toList();

      final didntWorkNames = didntWorkProducts
          .where(
            (product) =>
                product.ingredients.contains(ingredient.normalizedName),
          )
          .map((product) => product.productName)
          .toList();

      if (workedNames.isEmpty && didntWorkNames.isEmpty) {
        continue;
      }

      final match = IngredientHistoryMatch(
        ingredient: ingredient.displayName,
        workedProductCount: workedNames.length,
        didntWorkProductCount: didntWorkNames.length,
        workedProductNames: workedNames,
        didntWorkProductNames: didntWorkNames,
      );

      if (workedNames.isNotEmpty && didntWorkNames.isNotEmpty) {
        mixedMatches.add(match);
      } else if (workedNames.isNotEmpty) {
        workedOnlyMatches.add(match);
      } else {
        didntWorkOnlyMatches.add(match);
      }
    }

    return ProductHistoryComparison(
      totalNewIngredients: newIngredients.length,
      comparedWorkedProducts: workedProducts.length,
      comparedDidntWorkProducts: didntWorkProducts.length,
      ignoredNeutralProducts: neutralProducts,
      workedOnlyMatches: workedOnlyMatches,
      didntWorkOnlyMatches: didntWorkOnlyMatches,
      mixedMatches: mixedMatches,
      unseenIngredients: unseenIngredients,
    );
  }
}

class _HistoryIngredientSet {
  final String productName;
  final Set<String> ingredients;

  const _HistoryIngredientSet({
    required this.productName,
    required this.ingredients,
  });

  factory _HistoryIngredientSet.fromProduct(SavedProduct product) {
    final parsed = IngredientParser.parse(product.ingredientsText);

    return _HistoryIngredientSet(
      productName: product.name,
      ingredients: parsed
          .map((ingredient) => ingredient.normalizedName)
          .toSet(),
    );
  }
}
