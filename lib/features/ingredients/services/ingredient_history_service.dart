import 'package:skinprint/features/ingredients/models/ingredient_history.dart';
import 'package:skinprint/features/my_products/models/product_reaction.dart';
import 'package:skinprint/features/my_products/models/saved_product.dart';
import 'package:skinprint/features/product_check/services/ingredient_parser.dart';

class IngredientHistoryService {
  IngredientHistoryService._();

  static IngredientHistory build({
    required String ingredientName,
    required List<SavedProduct> products,
  }) {
    final normalizedTarget = IngredientParser.normalize(ingredientName);

    final worked = <String>[];
    final didntWork = <String>[];
    final neutral = <String>[];

    for (final product in products) {
      final productIngredients = IngredientParser.parse(
        product.ingredientsText,
      );

      final containsIngredient = productIngredients.any(
        (ingredient) => ingredient.normalizedName == normalizedTarget,
      );

      if (!containsIngredient) {
        continue;
      }

      switch (product.reaction) {
        case ProductReaction.worked:
          worked.add(product.name);
          break;

        case ProductReaction.didntWork:
          didntWork.add(product.name);
          break;

        case ProductReaction.neutral:
          neutral.add(product.name);
          break;
      }
    }

    return IngredientHistory(
      workedProductNames: worked,
      didntWorkProductNames: didntWork,
      neutralProductNames: neutral,
    );
  }
}
