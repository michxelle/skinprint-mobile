enum ProductReaction { worked, didntWork, neutral }

extension ProductReactionExtension on ProductReaction {
  String get label {
    switch (this) {
      case ProductReaction.worked:
        return 'Worked for me';

      case ProductReaction.didntWork:
        return 'Didn\'t work for me';

      case ProductReaction.neutral:
        return 'Neutral';
    }
  }

  String get description {
    switch (this) {
      case ProductReaction.worked:
        return 'Your skin responded well to this product.';

      case ProductReaction.didntWork:
        return 'This product did not work well for your skin.';

      case ProductReaction.neutral:
        return 'No particularly positive or negative experience.';
    }
  }
}

ProductReaction productReactionFromDatabase(String value) {
  return ProductReaction.values.firstWhere(
    (reaction) => reaction.name == value,
    orElse: () => ProductReaction.neutral,
  );
}
