import 'package:flutter/material.dart';

import '/core/theme/app_colors.dart';
import '/core/theme/app_text_styles.dart';
import '/core/widgets/primary_button.dart';
import '/features/product_check/screens/product_search_page.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 68,
        title: Text(
          'Skinprint',
          style: AppTextStyles.brand(
            color: AppColors.onPrimary,
          ),
        ),
      ),
      body: SafeArea(
        top: false,
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(
            24,
            46,
            24,
            40,
          ),
          child: Column(
            crossAxisAlignment:
                CrossAxisAlignment.start,
            children: [
              Text(
                'BEAUTY, MADE MORE PERSONAL',
                style: AppTextStyles.label(
                  color: AppColors.primaryAction,
                ),
              ),

              const SizedBox(height: 18),

              Text(
                'Know what’s inside\nbefore it joins\nyour shelf.',
                style: AppTextStyles.displayLarge(),
              ),

              const SizedBox(height: 22),

              Text(
                'Look up skincare and makeup ingredients, '
                'spot the categories you care about, and '
                'eventually compare new products with what '
                'has or hasn’t worked for you before.',
                style: AppTextStyles.bodyLarge(
                  color: AppColors.textSecondary,
                ),
              ),

              const SizedBox(height: 34),

              PrimaryButton(
                label: 'Check a Product',
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) =>
                          const ProductSearchPage(),
                    ),
                  );
                },
              ),

              const SizedBox(height: 52),

              const Divider(),

              const SizedBox(height: 30),

              Text(
                'What Skinprint looks for',
                style: AppTextStyles.sectionTitle(),
              ),

              const SizedBox(height: 18),

              const _ScreeningItem(
                number: '01',
                title: 'Fragrance',
                description:
                    'Highlights fragrance-related ingredients '
                    'for closer review.',
              ),

              const SizedBox(height: 22),

              const _ScreeningItem(
                number: '02',
                title: 'Drying alcohols',
                description:
                    'Distinguishes selected volatile alcohols '
                    'from fatty alcohols such as cetearyl alcohol.',
              ),

              const SizedBox(height: 22),

              const _ScreeningItem(
                number: '03',
                title: 'Colorants',
                description:
                    'Surfaces common cosmetic colorants found '
                    'in the ingredient list.',
              ),

              const SizedBox(height: 38),

              Text(
                'Skinprint provides ingredient information '
                'for comparison and awareness. It does not '
                'predict or diagnose skin reactions.',
                style: AppTextStyles.caption(),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _ScreeningItem extends StatelessWidget {
  final String number;
  final String title;
  final String description;

  const _ScreeningItem({
    required this.number,
    required this.title,
    required this.description,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: 38,
          child: Text(
            number,
            style: AppTextStyles.label(
              color: AppColors.primary,
            ),
          ),
        ),

        Expanded(
          child: Column(
            crossAxisAlignment:
                CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: AppTextStyles.bodyLarge().copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),

              const SizedBox(height: 4),

              Text(
                description,
                style: AppTextStyles.bodyMedium(),
              ),
            ],
          ),
        ),
      ],
    );
  }
}