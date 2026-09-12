import 'package:flutter/material.dart';

import 'package:skinprint/core/theme/app_colors.dart';
import 'package:skinprint/core/theme/app_text_styles.dart';
import 'package:skinprint/core/widgets/primary_button.dart';
import 'package:skinprint/features/my_products/controllers/saved_products_controller.dart';
import 'package:skinprint/features/product_check/screens/product_search_page.dart';

class HomePage extends StatelessWidget {
  final SavedProductsController savedProductsController;

  const HomePage({super.key, required this.savedProductsController});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
      child: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(24, 46, 24, 40),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'BEAUTY, MADE MORE PERSONAL',
              style: AppTextStyles.label(color: AppColors.primaryAction),
            ),

            const SizedBox(height: 18),

            Text(
              'Know what’s inside\n'
              'before it joins\n'
              'your shelf.',
              style: AppTextStyles.displayLarge(),
            ),

            const SizedBox(height: 22),

            Text(
              'Look up skincare and makeup ingredients, '
              'spot the categories you care about, and '
              'compare new products with what has or '
              'hasn’t worked for you before.',
              style: AppTextStyles.bodyLarge(color: AppColors.textSecondary),
            ),

            const SizedBox(height: 34),

            PrimaryButton(
              label: 'Check a Product',
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => ProductSearchPage(
                      savedProductsController: savedProductsController,
                    ),
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
                  'Surfaces common cosmetic colorants '
                  'found in the ingredient list.',
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
            style: AppTextStyles.label(color: AppColors.primary),
          ),
        ),

        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: AppTextStyles.bodyLarge().copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),

              const SizedBox(height: 4),

              Text(description, style: AppTextStyles.bodyMedium()),
            ],
          ),
        ),
      ],
    );
  }
}
