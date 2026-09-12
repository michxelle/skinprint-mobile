class IngredientInfo {
  final String name;
  final String slug;

  final String? casNumber;
  final String? ecNumber;

  final List<String> functions;

  final String? description;

  const IngredientInfo({
    required this.name,
    required this.slug,
    required this.casNumber,
    required this.ecNumber,
    required this.functions,
    this.description,
  });

  IngredientInfo copyWith({String? description}) {
    return IngredientInfo(
      name: name,
      slug: slug,
      casNumber: casNumber,
      ecNumber: ecNumber,
      functions: functions,
      description: description ?? this.description,
    );
  }

  factory IngredientInfo.fromCosingJson(Map<String, dynamic> json) {
    final rawFunctions = json['function_names'];

    final functions = rawFunctions is List
        ? rawFunctions.whereType<String>().map(_formatFunction).toList()
        : <String>[];

    return IngredientInfo(
      name: _clean(json['inci_name'], 'Unknown ingredient'),
      slug: _clean(json['slug'], ''),
      casNumber: _nullableString(json['cas_no']),
      ecNumber: _nullableString(json['ec_no']),
      functions: functions,
    );
  }

  static String _clean(dynamic value, String fallback) {
    if (value == null) {
      return fallback;
    }

    final text = value.toString().trim();

    return text.isEmpty ? fallback : text;
  }

  static String? _nullableString(dynamic value) {
    if (value == null) {
      return null;
    }

    final text = value.toString().trim();

    return text.isEmpty ? null : text;
  }

  static String _formatFunction(String function) {
    final words = function.toLowerCase().split(RegExp(r'[\s_-]+'));

    return words
        .map(
          (word) => word.isEmpty
          ? ''
          : '${word[0].toUpperCase()}${word.substring(1)}',
    )
        .join(' ');
  }
}
