import 'package:skinprint/features/product_check/models/beauty_product.dart';
import 'product_reaction.dart';

class SavedProduct {
  final int? id;

  final String code;
  final String name;
  final String brand;
  final String ingredientsText;
  final String imageUrl;

  final ProductReaction reaction;
  final DateTime savedAt;

  const SavedProduct({
    this.id,
    required this.code,
    required this.name,
    required this.brand,
    required this.ingredientsText,
    required this.imageUrl,
    required this.reaction,
    required this.savedAt,
  });

  factory SavedProduct.fromBeautyProduct({
    required BeautyProduct product,
    required ProductReaction reaction,
  }) {
    return SavedProduct(
      code: product.code,
      name: product.name,
      brand: product.brand,
      ingredientsText: product.ingredientsText,
      imageUrl: product.imageUrl,
      reaction: reaction,
      savedAt: DateTime.now(),
    );
  }

  factory SavedProduct.fromMap(
    Map<String, Object?> map,
  ) {
    return SavedProduct(
      id: map['id'] as int?,
      code: map['code'] as String,
      name: map['name'] as String,
      brand: map['brand'] as String,
      ingredientsText:
          map['ingredients_text'] as String,
      imageUrl: map['image_url'] as String,
      reaction: productReactionFromDatabase(
        map['reaction'] as String,
      ),
      savedAt: DateTime.parse(
        map['saved_at'] as String,
      ),
    );
  }

  Map<String, Object?> toMap() {
    return {
      if (id != null) 'id': id,
      'code': code,
      'name': name,
      'brand': brand,
      'ingredients_text': ingredientsText,
      'image_url': imageUrl,
      'reaction': reaction.name,
      'saved_at': savedAt.toIso8601String(),
    };
  }

  BeautyProduct toBeautyProduct() {
    return BeautyProduct(
      code: code,
      name: name,
      brand: brand,
      ingredientsText: ingredientsText,
      imageUrl: imageUrl,
    );
  }

  SavedProduct copyWith({
    int? id,
    ProductReaction? reaction,
  }) {
    return SavedProduct(
      id: id ?? this.id,
      code: code,
      name: name,
      brand: brand,
      ingredientsText: ingredientsText,
      imageUrl: imageUrl,
      reaction: reaction ?? this.reaction,
      savedAt: savedAt,
    );
  }
}