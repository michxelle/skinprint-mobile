import 'package:flutter/material.dart';

import 'package:skinprint/core/theme/app_colors.dart';
import 'package:skinprint/core/theme/app_text_styles.dart';
import 'package:skinprint/features/product_check/models/beauty_product.dart';
import 'package:skinprint/features/product_comparison/models/product_history_comparison.dart';

class PersonalizedComparisonPage
    extends StatelessWidget {
  final BeautyProduct product;
  final ProductHistoryComparison comparison;

  const PersonalizedComparisonPage({
    super.key,
    required this.product,
    required this.comparison,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title:
        const Text('My Skinprint'),
      ),
      body: SafeArea(
        top: false,
        child: ListView(
          padding:
          const EdgeInsets.fromLTRB(
            24,
            36,
            24,
            44,
          ),
          children: [
            Text(
              product.brand.toUpperCase(),
              style:
              AppTextStyles.label(
                color:
                AppColors.primaryAction,
              ),
            ),

            const SizedBox(height: 6),

            Text(
              product.name,
              style:
              AppTextStyles.productTitle(),
            ),

            const SizedBox(height: 36),

            _ComparisonOverview(
              comparison:
              comparison,
            ),

            const SizedBox(height: 34),

            const Divider(),

            if (comparison
                .didntWorkOnlyMatches
                .isNotEmpty) ...[
              const SizedBox(height: 30),

              Text(
                'Seen in products that didn’t work for you',
                style:
                AppTextStyles.sectionTitle(),
              ),

              const SizedBox(height: 10),

              Text(
                'These ingredients also appeared in '
                    'products you previously marked as '
                    '“Didn’t work for me.”',
                style:
                AppTextStyles.bodyMedium(),
              ),

              const SizedBox(height: 12),

              ..._buildMatches(
                comparison
                    .didntWorkOnlyMatches,
                _MatchType.didntWork,
              ),

              const SizedBox(height: 18),

              const Divider(),
            ],

            if (comparison
                .workedOnlyMatches
                .isNotEmpty) ...[
              const SizedBox(height: 30),

              Text(
                'Seen in products that worked for you',
                style:
                AppTextStyles.sectionTitle(),
              ),

              const SizedBox(height: 10),

              Text(
                'These ingredients also appeared in '
                    'products you previously marked as '
                    '“Worked for me.”',
                style:
                AppTextStyles.bodyMedium(),
              ),

              const SizedBox(height: 12),

              ..._buildMatches(
                comparison
                    .workedOnlyMatches,
                _MatchType.worked,
              ),

              const SizedBox(height: 18),

              const Divider(),
            ],

            if (comparison
                .mixedMatches
                .isNotEmpty) ...[
              const SizedBox(height: 30),

              Text(
                'Mixed history',
                style:
                AppTextStyles.sectionTitle(),
              ),

              const SizedBox(height: 10),

              Text(
                'These ingredients appeared in both '
                    'products that worked for you and '
                    'products that didn’t.',
                style:
                AppTextStyles.bodyMedium(),
              ),

              const SizedBox(height: 12),

              ..._buildMatches(
                comparison.mixedMatches,
                _MatchType.mixed,
              ),

              const SizedBox(height: 18),

              const Divider(),
            ],

            if (comparison
                .matchedIngredientCount ==
                0) ...[
              const SizedBox(height: 30),

              Text(
                'No familiar ingredients yet.',
                style:
                AppTextStyles.sectionTitle(),
              ),

              const SizedBox(height: 10),

              Text(
                'None of this product’s ingredients '
                    'matched the reaction history currently '
                    'saved in your Skinprint.',
                style:
                AppTextStyles.bodyMedium(),
              ),

              const SizedBox(height: 18),

              const Divider(),
            ],

            const SizedBox(height: 30),

            Text(
              'About this comparison',
              style:
              AppTextStyles.sectionTitle(),
            ),

            const SizedBox(height: 12),

            Text(
              '${comparison.totalNewIngredients} ingredients '
                  'were reviewed against '
                  '${comparison.comparedWorkedProducts} '
                  '${comparison.comparedWorkedProducts == 1 ? 'product' : 'products'} '
                  'that worked for you and '
                  '${comparison.comparedDidntWorkProducts} '
                  '${comparison.comparedDidntWorkProducts == 1 ? 'product' : 'products'} '
                  'that didn’t.',
              style:
              AppTextStyles.bodyMedium(),
            ),

            if (comparison
                .ignoredNeutralProducts >
                0) ...[
              const SizedBox(height: 10),

              Text(
                '${comparison.ignoredNeutralProducts} '
                    '${comparison.ignoredNeutralProducts == 1 ? 'neutral product was' : 'neutral products were'} '
                    'not used as positive or negative evidence.',
                style:
                AppTextStyles.bodyMedium(),
              ),
            ],

            const SizedBox(height: 24),

            Text(
              'Ingredient overlap can reveal patterns in '
                  'your product history, but it cannot determine '
                  'which ingredient caused a skin reaction.',
              style:
              AppTextStyles.caption(),
            ),
          ],
        ),
      ),
    );
  }

  List<Widget> _buildMatches(
      List<IngredientHistoryMatch> matches,
      _MatchType type,
      ) {
    final widgets = <Widget>[];

    for (var i = 0;
    i < matches.length;
    i++) {
      widgets.add(
        _IngredientHistoryRow(
          match: matches[i],
          type: type,
        ),
      );

      if (i < matches.length - 1) {
        widgets.add(
          const Divider(),
        );
      }
    }

    return widgets;
  }
}

enum _MatchType {
  worked,
  didntWork,
  mixed,
}

class _ComparisonOverview
    extends StatelessWidget {
  final ProductHistoryComparison comparison;

  const _ComparisonOverview({
    required this.comparison,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment:
      CrossAxisAlignment.start,
      children: [
        Text(
          '${comparison.matchedIngredientCount}',
          style:
          AppTextStyles.displayLarge(
            color:
            AppColors.primaryAction,
          ).copyWith(
            fontSize: 64,
          ),
        ),

        Text(
          comparison.matchedIngredientCount == 1
              ? 'familiar ingredient'
              : 'familiar ingredients',
          style:
          AppTextStyles.sectionTitle(),
        ),

        const SizedBox(height: 12),

        Text(
          '${comparison.didntWorkHistoryIngredientCount} '
              'linked to your didn’t-work history  ·  '
              '${comparison.workedHistoryIngredientCount} '
              'linked to your worked history',
          style:
          AppTextStyles.bodyMedium(),
        ),
      ],
    );
  }
}

class _IngredientHistoryRow
    extends StatelessWidget {
  final IngredientHistoryMatch match;
  final _MatchType type;

  const _IngredientHistoryRow({
    required this.match,
    required this.type,
  });

  Color get _accentColor {
    switch (type) {
      case _MatchType.worked:
        return AppColors.good;

      case _MatchType.didntWork:
        return AppColors.concern;

      case _MatchType.mixed:
        return AppColors.primaryAction;
    }
  }

  String get _categoryLabel {
    switch (type) {
      case _MatchType.worked:
        return 'WORKED HISTORY';

      case _MatchType.didntWork:
        return 'DIDN’T-WORK HISTORY';

      case _MatchType.mixed:
        return 'MIXED HISTORY';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding:
      const EdgeInsets.symmetric(
        vertical: 18,
      ),
      child: Column(
        crossAxisAlignment:
        CrossAxisAlignment.start,
        children: [
          Text(
            _categoryLabel,
            style:
            AppTextStyles.label(
              color: _accentColor,
            ),
          ),

          const SizedBox(height: 6),

          Text(
            match.ingredient,
            style:
            AppTextStyles.sectionTitle(),
          ),

          const SizedBox(height: 10),

          if (match
              .workedProductNames
              .isNotEmpty)
            _HistoryEvidence(
              label:
              'Worked for you',
              productNames:
              match.workedProductNames,
              color:
              AppColors.good,
            ),

          if (match
              .workedProductNames
              .isNotEmpty &&
              match
                  .didntWorkProductNames
                  .isNotEmpty)
            const SizedBox(height: 10),

          if (match
              .didntWorkProductNames
              .isNotEmpty)
            _HistoryEvidence(
              label:
              'Didn’t work for you',
              productNames:
              match.didntWorkProductNames,
              color:
              AppColors.concern,
            ),
        ],
      ),
    );
  }
}

class _HistoryEvidence
    extends StatelessWidget {
  final String label;
  final List<String> productNames;
  final Color color;

  const _HistoryEvidence({
    required this.label,
    required this.productNames,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Text.rich(
      TextSpan(
        style:
        AppTextStyles.bodyMedium(),
        children: [
          TextSpan(
            text: '$label: ',
            style: TextStyle(
              color: color,
              fontWeight:
              FontWeight.w600,
            ),
          ),

          TextSpan(
            text:
            productNames.join(', '),
          ),
        ],
      ),
    );
  }
}