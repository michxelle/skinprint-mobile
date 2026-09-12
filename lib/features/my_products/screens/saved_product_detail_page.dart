import 'package:flutter/material.dart';

import 'package:skinprint/core/theme/app_colors.dart';
import 'package:skinprint/core/theme/app_text_styles.dart';
import 'package:skinprint/core/widgets/primary_button.dart';
import 'package:skinprint/features/product_check/screens/analysis_result_page.dart';
import 'package:skinprint/features/product_check/services/ingredient_analyzer.dart';
import 'package:skinprint/features/my_products/controllers/saved_products_controller.dart';
import 'package:skinprint/features/my_products/models/saved_product.dart';
import 'package:skinprint/features/my_products/widgets/reaction_label.dart';
import 'package:skinprint/features/my_products/widgets/reaction_picker_sheet.dart';

class SavedProductDetailPage extends StatelessWidget {
  final SavedProduct initialProduct;

  final SavedProductsController controller;

  const SavedProductDetailPage({
    super.key,
    required this.initialProduct,
    required this.controller,
  });

  Future<void> _changeReaction(
    BuildContext context,
    SavedProduct product,
  ) async {
    final reaction = await showReactionPicker(
      context,
      currentReaction: product.reaction,
    );

    if (reaction == null || reaction == product.reaction) {
      return;
    }

    await controller.updateReaction(product: product, reaction: reaction);

    if (!context.mounted) {
      return;
    }

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Your product experience was updated.')),
    );
  }

  void _analyze(BuildContext context, SavedProduct product) {
    final beautyProduct = product.toBeautyProduct();

    final analysis = IngredientAnalyzer.analyze(product.ingredientsText);

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) =>
            AnalysisResultPage(product: beautyProduct, analysis: analysis),
      ),
    );
  }

  Future<void> _removeProduct(
    BuildContext context,
    SavedProduct product,
  ) async {
    final confirmed = await showModalBottomSheet<bool>(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (sheetContext) {
        return Container(
          padding: const EdgeInsets.fromLTRB(24, 12, 24, 30),
          decoration: const BoxDecoration(
            color: AppColors.surface,
            borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
          ),
          child: SafeArea(
            top: false,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Container(
                    width: 40,
                    height: 4,
                    decoration: BoxDecoration(
                      color: AppColors.border,
                      borderRadius: BorderRadius.circular(100),
                    ),
                  ),
                ),

                const SizedBox(height: 28),

                Text(
                  'Remove this product?',
                  style: AppTextStyles.displayMedium(),
                ),

                const SizedBox(height: 10),

                Text(
                  'It will no longer be part '
                  'of your Skinprint history.',
                  style: AppTextStyles.bodyMedium(),
                ),

                const SizedBox(height: 28),

                SizedBox(
                  width: double.infinity,
                  height: 52,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.concern,
                    ),
                    onPressed: () {
                      Navigator.pop(sheetContext, true);
                    },
                    child: Text(
                      'Remove Product',
                      style: AppTextStyles.button(),
                    ),
                  ),
                ),

                const SizedBox(height: 8),

                SizedBox(
                  width: double.infinity,
                  child: TextButton(
                    onPressed: () {
                      Navigator.pop(sheetContext, false);
                    },
                    child: Text(
                      'Cancel',
                      style: AppTextStyles.bodyMedium(
                        color: AppColors.textPrimary,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );

    if (confirmed != true) {
      return;
    }

    await controller.deleteProduct(product);

    if (!context.mounted) {
      return;
    }

    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('My Product')),
      body: AnimatedBuilder(
        animation: controller,
        builder: (context, child) {
          final currentProduct =
              controller.findByCode(initialProduct.code) ?? initialProduct;

          return SafeArea(
            top: false,
            child: ListView(
              padding: const EdgeInsets.fromLTRB(24, 34, 24, 44),
              children: [
                Center(
                  child: SizedBox(
                    height: 220,
                    child: currentProduct.imageUrl.isNotEmpty
                        ? Image.network(
                            currentProduct.imageUrl,
                            fit: BoxFit.contain,
                            errorBuilder: (context, error, stackTrace) {
                              return const _ImagePlaceholder();
                            },
                          )
                        : const _ImagePlaceholder(),
                  ),
                ),

                const SizedBox(height: 34),

                Text(
                  currentProduct.brand.toUpperCase(),
                  style: AppTextStyles.label(color: AppColors.primaryAction),
                ),

                const SizedBox(height: 6),

                Text(currentProduct.name, style: AppTextStyles.productTitle()),

                const SizedBox(height: 34),

                const Divider(),

                const SizedBox(height: 28),

                Text('Your experience', style: AppTextStyles.sectionTitle()),

                const SizedBox(height: 12),

                Row(
                  children: [
                    Expanded(
                      child: ReactionLabel(reaction: currentProduct.reaction),
                    ),

                    TextButton(
                      onPressed: () => _changeReaction(context, currentProduct),
                      child: const Text('Change'),
                    ),
                  ],
                ),

                const SizedBox(height: 26),

                const Divider(),

                const SizedBox(height: 28),

                Text('Ingredients', style: AppTextStyles.sectionTitle()),

                const SizedBox(height: 14),

                SelectableText(
                  currentProduct.ingredientsText.isNotEmpty
                      ? currentProduct.ingredientsText
                      : 'Ingredient information '
                            'is unavailable.',
                  style: AppTextStyles.bodyMedium(),
                ),

                const SizedBox(height: 34),

                if (currentProduct.ingredientsText.isNotEmpty)
                  PrimaryButton(
                    label: 'Analyze Ingredients',
                    onPressed: () => _analyze(context, currentProduct),
                  ),

                const SizedBox(height: 12),

                TextButton(
                  onPressed: () => _removeProduct(context, currentProduct),
                  child: Text(
                    'Remove from My Products',
                    style: AppTextStyles.bodyMedium(
                      color: AppColors.concern,
                    ).copyWith(fontWeight: FontWeight.w600),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

class _ImagePlaceholder extends StatelessWidget {
  const _ImagePlaceholder();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        width: 170,
        height: 200,
        color: AppColors.primarySoft,
        alignment: Alignment.center,
        child: Text(
          'Image unavailable',
          textAlign: TextAlign.center,
          style: AppTextStyles.caption(),
        ),
      ),
    );
  }
}
