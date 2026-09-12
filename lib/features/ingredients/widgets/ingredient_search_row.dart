import 'package:flutter/material.dart';

import 'package:skinprint/core/theme/app_colors.dart';
import 'package:skinprint/core/theme/app_text_styles.dart';
import 'package:skinprint/features/ingredients/models/ingredient_info.dart';

class IngredientSearchRow extends StatelessWidget {
  final IngredientInfo ingredient;
  final VoidCallback onTap;

  const IngredientSearchRow({
    super.key,
    required this.ingredient,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 18),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    ingredient.name,
                    style: AppTextStyles.sectionTitle().copyWith(fontSize: 21),
                  ),

                  if (ingredient.functions.isNotEmpty) ...[
                    const SizedBox(height: 5),

                    Text(
                      ingredient.functions.take(3).join(' · '),
                      style: AppTextStyles.bodyMedium(),
                    ),
                  ],
                ],
              ),
            ),

            const SizedBox(width: 16),

            const Icon(Icons.chevron_right, color: AppColors.textSecondary),
          ],
        ),
      ),
    );
  }
}
