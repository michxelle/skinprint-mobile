class IngredientHistory {
  final List<String> workedProductNames;
  final List<String> didntWorkProductNames;
  final List<String> neutralProductNames;

  const IngredientHistory({
    required this.workedProductNames,
    required this.didntWorkProductNames,
    required this.neutralProductNames,
  });

  int get totalOccurrences =>
      workedProductNames.length +
      didntWorkProductNames.length +
      neutralProductNames.length;

  bool get hasHistory => totalOccurrences > 0;
}
