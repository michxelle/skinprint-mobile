import 'package:flutter/material.dart';

import 'package:skinprint/core/theme/app_colors.dart';
import 'package:skinprint/core/theme/app_text_styles.dart';
import 'package:skinprint/features/product_check/models/beauty_product.dart';
import 'package:skinprint/features/product_check/models/ingredient_analysis.dart';

class AnalysisResultPage extends StatelessWidget {
  final BeautyProduct product;
  final ProductAnalysis analysis;

  const AnalysisResultPage({
    super.key,
    required this.product,
    required this.analysis,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Ingredient Analysis')),
      body: SafeArea(
        top: false,
        child: ListView(
          padding: const EdgeInsets.fromLTRB(24, 36, 24, 44),
          children: [
            Text(
              product.brand.toUpperCase(),
              style: AppTextStyles.label(color: AppColors.primaryAction),
            ),

            const SizedBox(height: 6),

            Text(product.name, style: AppTextStyles.productTitle()),

            const SizedBox(height: 38),

            _AnalysisSummary(analysis: analysis),

            const SizedBox(height: 34),

            const Divider(),

            const SizedBox(height: 30),

            Text('What Skinprint noticed', style: AppTextStyles.sectionTitle()),

            const SizedBox(height: 8),

            if (!analysis.hasFlags)
              Padding(
                padding: const EdgeInsets.only(top: 10),
                child: Text(
                  'No ingredients matched the '
                  'categories Skinprint currently '
                  'screens for.',
                  style: AppTextStyles.bodyLarge(
                    color: AppColors.textSecondary,
                  ),
                ),
              )
            else
              ..._buildFlags(),

            const SizedBox(height: 34),

            const Divider(),

            const SizedBox(height: 30),

            Text('Full ingredient list', style: AppTextStyles.sectionTitle()),

            const SizedBox(height: 14),

            Text(
              analysis.ingredients.join(' · '),
              style: AppTextStyles.bodyMedium(),
            ),

            const SizedBox(height: 36),

            Text(
              'A highlighted ingredient does not '
              'mean this product will necessarily '
              'cause a reaction. Skinprint is designed '
              'to support ingredient comparison and '
              'personal awareness.',
              style: AppTextStyles.caption(),
            ),
          ],
        ),
      ),
    );
  }

  List<Widget> _buildFlags() {
    final widgets = <Widget>[];

    for (var i = 0; i < analysis.flags.length; i++) {
      widgets.add(_IngredientFinding(flag: analysis.flags[i]));

      if (i < analysis.flags.length - 1) {
        widgets.add(
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 8),
            child: Divider(),
          ),
        );
      }
    }

    return widgets;
  }
}

class _AnalysisSummary extends StatelessWidget {
  final ProductAnalysis analysis;

  const _AnalysisSummary({required this.analysis});

  @override
  Widget build(BuildContext context) {
    final resultColor = analysis.hasFlags ? AppColors.concern : AppColors.good;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '${analysis.totalFlags}',
          style: AppTextStyles.displayLarge(
            color: resultColor,
          ).copyWith(fontSize: 64),
        ),

        Text(
          analysis.totalFlags == 1
              ? 'ingredient flagged'
              : 'ingredients flagged',
          style: AppTextStyles.sectionTitle(),
        ),

        const SizedBox(height: 12),

        Text(
          '${analysis.totalIngredients} ingredients '
          'reviewed',
          style: AppTextStyles.bodyMedium(),
        ),
      ],
    );
  }
}

class _IngredientFinding extends StatelessWidget {
  final IngredientFlag flag;

  const _IngredientFinding({required this.flag});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 18),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            flag.category.toUpperCase(),
            style: AppTextStyles.label(color: AppColors.concern),
          ),

          const SizedBox(height: 6),

          Text(flag.ingredient, style: AppTextStyles.sectionTitle()),

          const SizedBox(height: 10),

          Text(flag.explanation, style: AppTextStyles.bodyMedium()),
        ],
      ),
    );
  }
}
