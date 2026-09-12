import 'package:flutter/material.dart';

import 'package:skinprint/core/theme/app_colors.dart';
import 'package:skinprint/core/theme/app_text_styles.dart';
import 'package:skinprint/core/widgets/primary_button.dart';
import 'package:skinprint/features/product_check/models/beauty_product.dart';
import 'package:skinprint/features/product_check/models/ingredient_analysis.dart';
import 'package:skinprint/features/product_check/services/ingredient_analyzer.dart';
import 'analysis_result_page.dart';
import 'package:skinprint/features/my_products/controllers/saved_products_controller.dart';
import 'package:skinprint/features/my_products/widgets/reaction_picker_sheet.dart';
import 'package:skinprint/features/my_products/models/product_reaction.dart';
import 'package:skinprint/features/product_comparison/screens/personalized_comparison_page.dart';
import 'package:skinprint/features/product_comparison/services/product_comparison_service.dart';
import 'package:skinprint/features/product_comparison/models/product_history_comparison.dart';

class ProductDetailPage extends StatelessWidget {
  final BeautyProduct product;
  final SavedProductsController savedProductsController;

  const ProductDetailPage({
    super.key,
    required this.product,
    required this.savedProductsController,
  });

  void _analyze(BuildContext context) {
    if (!product.hasIngredients) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'This product does not have an '
            'ingredient list yet.',
          ),
        ),
      );

      return;
    }

    final analysis = IngredientAnalyzer.analyze(product.ingredientsText);

    _showAnalysisSummary(context, analysis);
  }

  void _showAnalysisSummary(BuildContext context, ProductAnalysis analysis) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (sheetContext) {
        return Container(
          padding: const EdgeInsets.fromLTRB(24, 12, 24, 32),
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

                const SizedBox(height: 30),

                Text(
                  analysis.hasFlags
                      ? '${analysis.totalFlags} ${analysis.totalFlags == 1 ? 'ingredient' : 'ingredients'} worth a closer look.'
                      : 'Nothing flagged in the categories Skinprint currently checks.',
                  style: AppTextStyles.displayMedium(),
                ),

                const SizedBox(height: 16),

                Text(
                  analysis.hasFlags
                      ? 'We found ${analysis.totalFlags} '
                            '${analysis.totalFlags == 1 ? 'ingredient' : 'ingredients'} '
                            'across fragrance, selected drying '
                            'alcohols, or cosmetic colorants.'
                      : 'The current screening did not find '
                            'fragrance, selected drying alcohols, '
                            'or cosmetic colorants.',
                  style: AppTextStyles.bodyLarge(
                    color: AppColors.textSecondary,
                  ),
                ),

                const SizedBox(height: 18),

                Text(
                  'This is ingredient screening, '
                  'not a medical safety assessment.',
                  style: AppTextStyles.caption(),
                ),

                const SizedBox(height: 28),

                PrimaryButton(
                  label: 'View Full Analysis',
                  onPressed: () {
                    Navigator.pop(sheetContext);

                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => AnalysisResultPage(
                          product: product,
                          analysis: analysis,
                        ),
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Future<void> _saveProduct(BuildContext context) async {
    final existing = savedProductsController.findByCode(product.code);

    final reaction = await showReactionPicker(
      context,
      currentReaction: existing?.reaction,
    );

    if (reaction == null) {
      return;
    }

    try {
      await savedProductsController.saveProduct(
        product: product,
        reaction: reaction,
      );

      if (!context.mounted) {
        return;
      }

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            existing == null
                ? 'Added to My Products.'
                : 'Your product experience was updated.',
          ),
        ),
      );
    } catch (_) {
      if (!context.mounted) {
        return;
      }

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Couldn\'t save this product.')),
      );
    }
  }

  Future<void> _compareWithSkinprint(BuildContext context) async {
    if (!product.hasIngredients) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('This product does not have an ingredient list yet.'),
        ),
      );

      return;
    }

    await savedProductsController.loadProducts();

    if (!context.mounted) {
      return;
    }

    final reactionHistory = savedProductsController.products
        .where(
          (savedProduct) =>
              savedProduct.code != product.code &&
              savedProduct.reaction != ProductReaction.neutral,
        )
        .toList();

    if (reactionHistory.isEmpty) {
      _showMissingHistorySheet(context);

      return;
    }

    final comparison = ProductComparisonService.compare(
      newProduct: product,
      history: savedProductsController.products,
    );

    _showComparisonSummary(context, comparison);
  }

  void _showMissingHistorySheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return Container(
          padding: const EdgeInsets.fromLTRB(24, 12, 24, 32),
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
                  'Build your Skinprint first.',
                  style: AppTextStyles.displayMedium(),
                ),

                const SizedBox(height: 12),

                Text(
                  'Save at least one product as '
                  '“Worked for me” or “Didn’t work for me” '
                  'before comparing a new product.',
                  style: AppTextStyles.bodyMedium(),
                ),

                const SizedBox(height: 22),

                Text(
                  'Neutral products are kept in your history, '
                  'but they aren’t treated as positive or '
                  'negative evidence.',
                  style: AppTextStyles.caption(),
                ),

                const SizedBox(height: 26),

                PrimaryButton(
                  label: 'Got It',
                  onPressed: () {
                    Navigator.pop(context);
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void _showComparisonSummary(
    BuildContext context,
    ProductHistoryComparison comparison,
  ) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (sheetContext) {
        final didntWorkCount = comparison.didntWorkHistoryIngredientCount;

        final workedCount = comparison.workedHistoryIngredientCount;

        String headline;
        String description;

        if (didntWorkCount > 0 && workedCount > 0) {
          headline =
              'This product shares ingredients with both sides of your history.';

          description =
              '$didntWorkCount ${didntWorkCount == 1 ? 'ingredient overlaps' : 'ingredients overlap'} '
              'with products that didn’t work for you, while '
              '$workedCount ${workedCount == 1 ? 'ingredient overlaps' : 'ingredients overlap'} '
              'with products that worked for you.';
        } else if (didntWorkCount > 0) {
          headline =
              '$didntWorkCount ${didntWorkCount == 1 ? 'ingredient' : 'ingredients'} '
              'overlap with your didn’t-work history.';

          description =
              'Skinprint found ingredients that also appeared '
              'in products you previously marked as not working for you.';
        } else if (workedCount > 0) {
          headline =
              '$workedCount ${workedCount == 1 ? 'ingredient looks' : 'ingredients look'} '
              'familiar.';

          description =
              'These ingredients also appeared in products '
              'you previously marked as working for you.';
        } else {
          headline = 'No reaction-history overlap yet.';

          description =
              'Skinprint didn’t find ingredient overlap '
              'between this product and your recorded '
              'worked or didn’t-work products.';
        }

        return Container(
          padding: const EdgeInsets.fromLTRB(24, 12, 24, 32),
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

                const SizedBox(height: 30),

                Text(headline, style: AppTextStyles.displayMedium()),

                const SizedBox(height: 14),

                Text(
                  description,
                  style: AppTextStyles.bodyLarge(
                    color: AppColors.textSecondary,
                  ),
                ),

                const SizedBox(height: 18),

                Text(
                  'Ingredient overlap shows patterns in '
                  'your history, not proof that an ingredient '
                  'caused a reaction.',
                  style: AppTextStyles.caption(),
                ),

                const SizedBox(height: 28),

                PrimaryButton(
                  label: 'View Comparison',
                  onPressed: () {
                    Navigator.pop(sheetContext);

                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => PersonalizedComparisonPage(
                          product: product,
                          comparison: comparison,
                          savedProductsController: savedProductsController,
                        ),
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: SafeArea(
        top: false,
        child: ListView(
          padding: const EdgeInsets.fromLTRB(24, 34, 24, 40),
          children: [
            Center(
              child: SizedBox(
                height: 230,
                child: product.hasImage
                    ? Image.network(
                        product.imageUrl,
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
              product.brand.toUpperCase(),
              style: AppTextStyles.label(color: AppColors.primaryAction),
            ),

            const SizedBox(height: 7),

            Text(product.name, style: AppTextStyles.productTitle()),

            if (product.code.isNotEmpty) ...[
              const SizedBox(height: 10),

              Text('Barcode ${product.code}', style: AppTextStyles.caption()),
            ],

            const SizedBox(height: 34),

            const Divider(),

            const SizedBox(height: 28),

            Text('Ingredients', style: AppTextStyles.sectionTitle()),

            const SizedBox(height: 14),

            SelectableText(
              product.hasIngredients
                  ? product.ingredientsText
                  : 'Ingredient information is not '
                        'available for this product.',
              style: AppTextStyles.bodyMedium(),
            ),

            const SizedBox(height: 34),

            PrimaryButton(
              label: 'Compare with My Skinprint',
              onPressed: product.hasIngredients
                  ? () => _compareWithSkinprint(context)
                  : null,
            ),

            const SizedBox(height: 8),

            SizedBox(
              width: double.infinity,
              child: TextButton(
                onPressed: product.hasIngredients
                    ? () => _analyze(context)
                    : null,
                child: Text(
                  'View General Ingredient Analysis',
                  style: AppTextStyles.bodyMedium(
                    color: AppColors.primaryAction,
                  ).copyWith(fontWeight: FontWeight.w600),
                ),
              ),
            ),

            const SizedBox(height: 2),

            AnimatedBuilder(
              animation: savedProductsController,
              builder: (context, child) {
                final existing = savedProductsController.findByCode(
                  product.code,
                );

                return SizedBox(
                  width: double.infinity,
                  child: TextButton(
                    onPressed: product.code.isEmpty
                        ? null
                        : () => _saveProduct(context),
                    child: Text(
                      existing == null
                          ? 'Save to My Products'
                          : 'Update My Product',
                      style: AppTextStyles.bodyMedium(
                        color: AppColors.primaryAction,
                      ).copyWith(fontWeight: FontWeight.w600),
                    ),
                  ),
                );
              },
            ),
          ],
        ),
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
        height: 210,
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
