class IngredientHistoryMatch {
  final String ingredient;

  final int workedProductCount;
  final int didntWorkProductCount;

  final List<String> workedProductNames;
  final List<String> didntWorkProductNames;

  const IngredientHistoryMatch({
    required this.ingredient,
    required this.workedProductCount,
    required this.didntWorkProductCount,
    required this.workedProductNames,
    required this.didntWorkProductNames,
  });

  bool get appearsInWorkedProducts => workedProductCount > 0;

  bool get appearsInDidntWorkProducts => didntWorkProductCount > 0;

  bool get appearsInBoth =>
      appearsInWorkedProducts && appearsInDidntWorkProducts;
}

class ProductHistoryComparison {
  final int totalNewIngredients;

  final int comparedWorkedProducts;
  final int comparedDidntWorkProducts;

  final int ignoredNeutralProducts;

  final List<IngredientHistoryMatch> workedOnlyMatches;

  final List<IngredientHistoryMatch> didntWorkOnlyMatches;

  final List<IngredientHistoryMatch> mixedMatches;

  final List<String> unseenIngredients;

  const ProductHistoryComparison({
    required this.totalNewIngredients,
    required this.comparedWorkedProducts,
    required this.comparedDidntWorkProducts,
    required this.ignoredNeutralProducts,
    required this.workedOnlyMatches,
    required this.didntWorkOnlyMatches,
    required this.mixedMatches,
    required this.unseenIngredients,
  });

  bool get hasReactionHistory =>
      comparedWorkedProducts > 0 || comparedDidntWorkProducts > 0;

  int get matchedIngredientCount =>
      workedOnlyMatches.length +
      didntWorkOnlyMatches.length +
      mixedMatches.length;

  int get unseenIngredientCount => unseenIngredients.length;

  int get workedHistoryIngredientCount =>
      workedOnlyMatches.length + mixedMatches.length;

  int get didntWorkHistoryIngredientCount =>
      didntWorkOnlyMatches.length + mixedMatches.length;
}
