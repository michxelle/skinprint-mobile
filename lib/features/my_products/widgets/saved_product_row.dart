import 'package:flutter/material.dart';

import 'package:skinprint/core/theme/app_colors.dart';
import 'package:skinprint/core/theme/app_text_styles.dart';
import 'package:skinprint/features/my_products/models/saved_product.dart';
import 'reaction_label.dart';

class SavedProductRow extends StatelessWidget {
  final SavedProduct product;
  final bool showReactionLabel;
  final VoidCallback onTap;

  const SavedProductRow({
    super.key,
    required this.product,
    required this.onTap,
    this.showReactionLabel = true,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 18),
        child: Row(
          children: [
            SizedBox(
              width: 72,
              height: 86,
              child: product.imageUrl.isNotEmpty
                  ? ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: Image.network(
                        product.imageUrl,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) {
                          return const _Placeholder();
                        },
                      ),
                    )
                  : const _Placeholder(),
            ),

            const SizedBox(width: 18),

            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    product.brand.toUpperCase(),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: AppTextStyles.label(color: AppColors.primaryAction),
                  ),

                  const SizedBox(height: 5),

                  Text(
                    product.name,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: AppTextStyles.sectionTitle().copyWith(fontSize: 21),
                  ),

                  if (showReactionLabel) ...[
                    const SizedBox(height: 10),
                    ReactionLabel(reaction: product.reaction),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _Placeholder extends StatelessWidget {
  const _Placeholder();

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColors.primarySoft,
      alignment: Alignment.center,
      child: Text(
        'No image',
        textAlign: TextAlign.center,
        style: AppTextStyles.caption(),
      ),
    );
  }
}
