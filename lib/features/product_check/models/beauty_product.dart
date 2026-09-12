class BeautyProduct {
  final String code;
  final String name;
  final String brand;
  final String ingredientsText;
  final String imageUrl;

  const BeautyProduct({
    required this.code,
    required this.name,
    required this.brand,
    required this.ingredientsText,
    required this.imageUrl,
  });

  factory BeautyProduct.fromJson(Map<String, dynamic> json) {
    return BeautyProduct(
      code: json['code']?.toString() ?? '',
      name: _cleanString(json['product_name'], 'Unnamed product'),
      brand: _cleanString(json['brands'], 'Unknown brand'),
      ingredientsText: _cleanString(json['ingredients_text'], ''),
      imageUrl: _cleanString(json['image_front_url'], ''),
    );
  }

  static String _cleanString(dynamic value, String fallback) {
    if (value == null) {
      return fallback;
    }

    final text = value.toString().trim();

    if (text.isEmpty) {
      return fallback;
    }

    return text;
  }

  bool get hasIngredients => ingredientsText.trim().isNotEmpty;

  bool get hasImage => imageUrl.trim().isNotEmpty;
}
