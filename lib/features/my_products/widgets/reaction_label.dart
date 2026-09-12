import 'package:flutter/material.dart';

import 'package:skinprint/core/theme/app_colors.dart';
import 'package:skinprint/core/theme/app_text_styles.dart';
import 'package:skinprint/features/my_products/models/product_reaction.dart';

Color reactionColor(
  ProductReaction reaction,
) {
  switch (reaction) {
    case ProductReaction.worked:
      return AppColors.good;

    case ProductReaction.didntWork:
      return AppColors.concern;

    case ProductReaction.neutral:
      return AppColors.primaryAction;
  }
}

class ReactionLabel
    extends StatelessWidget {
  final ProductReaction reaction;

  const ReactionLabel({
    super.key,
    required this.reaction,
  });

  @override
  Widget build(BuildContext context) {
    return Text(
      reaction.label.toUpperCase(),
      style: AppTextStyles.label(
        color: reactionColor(reaction),
      ),
    );
  }
}