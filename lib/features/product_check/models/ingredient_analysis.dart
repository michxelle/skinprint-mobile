enum IngredientConcernType {
  fragrance,
  dryingAlcohol,
  artificialColor,
}

class IngredientFlag {
  final String ingredient;
  final IngredientConcernType type;
  final String category;
  final String explanation;

  const IngredientFlag({
    required this.ingredient,
    required this.type,
    required this.category,
    required this.explanation,
  });
}

class ProductAnalysis {
  final List<String> ingredients;
  final List<IngredientFlag> flags;

  const ProductAnalysis({
    required this.ingredients,
    required this.flags,
  });

  int get totalIngredients => ingredients.length;

  int get totalFlags => flags.length;

  bool get hasFlags => flags.isNotEmpty;

  int countType(IngredientConcernType type) {
    return flags
        .where(
          (flag) => flag.type == type,
        )
        .length;
  }
}