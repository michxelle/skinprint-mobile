import 'package:flutter/material.dart';

import 'package:skinprint/core/theme/app_colors.dart';
import 'package:skinprint/core/theme/app_text_styles.dart';
import 'package:skinprint/features/product_check/models/beauty_product.dart';

class ProductResultCard extends StatelessWidget {
  final BeautyProduct product;
  final VoidCallback onTap;

  const ProductResultCard({
    super.key,
    required this.product,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(
          vertical: 18,
        ),
        child: Row(
          crossAxisAlignment:
              CrossAxisAlignment.center,
          children: [
            _ProductImage(product: product),

            const SizedBox(width: 18),

            Expanded(
              child: Column(
                crossAxisAlignment:
                    CrossAxisAlignment.start,
                children: [
                  Text(
                    product.brand.toUpperCase(),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: AppTextStyles.label(
                      color:
                          AppColors.primaryAction,
                    ),
                  ),

                  const SizedBox(height: 5),

                  Text(
                    product.name,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style:
                        AppTextStyles.sectionTitle()
                            .copyWith(
                      fontSize: 21,
                    ),
                  ),

                  const SizedBox(height: 7),

                  Text(
                    product.hasIngredients
                        ? 'Ingredient list available'
                        : 'Ingredient list unavailable',
                    style:
                        AppTextStyles.caption(
                      color:
                          product.hasIngredients
                              ? AppColors.good
                              : AppColors.warning,
                    ).copyWith(
                      fontWeight:
                          FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ProductImage extends StatelessWidget {
  final BeautyProduct product;

  const _ProductImage({
    required this.product,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 78,
      height: 92,
      child: product.hasImage
          ? ClipRRect(
              borderRadius:
                  BorderRadius.circular(8),
              child: Image.network(
                product.imageUrl,
                fit: BoxFit.cover,
                errorBuilder: (
                  context,
                  error,
                  stackTrace,
                ) {
                  return const _Placeholder();
                },
              ),
            )
          : const _Placeholder(),
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