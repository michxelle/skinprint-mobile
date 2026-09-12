import 'package:flutter/material.dart';

import 'package:skinprint/core/theme/app_colors.dart';
import 'package:skinprint/core/theme/app_text_styles.dart';

class AboutSkinprintPage extends StatelessWidget {
  const AboutSkinprintPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('About Skinprint')),
      body: SafeArea(
        top: false,
        child: ListView(
          padding: const EdgeInsets.fromLTRB(24, 36, 24, 44),
          children: [
            Text(
              'Beauty, made more personal.',
              style: AppTextStyles.displayMedium(),
            ),

            const SizedBox(height: 14),

            Text(
              'Skinprint helps you explore beauty-product '
              'ingredients and compare them with products '
              'you have personally used.',
              style: AppTextStyles.bodyLarge(color: AppColors.textSecondary),
            ),

            const SizedBox(height: 34),

            const Divider(),

            const SizedBox(height: 30),

            Text('How Skinprint works', style: AppTextStyles.sectionTitle()),

            const SizedBox(height: 14),

            Text(
              'Save products as “Worked for me,” '
              '“Didn’t work for me,” or “Neutral.” '
              'When you check another product, Skinprint '
              'compares its ingredients with your saved '
              'product history and shows patterns of overlap.',
              style: AppTextStyles.bodyMedium(),
            ),

            const SizedBox(height: 18),

            Text(
              'Ingredient overlap does not prove that a '
              'specific ingredient caused a reaction or '
              'predict whether a product will suit you.',
              style: AppTextStyles.caption(),
            ),

            const SizedBox(height: 34),

            const Divider(),

            const SizedBox(height: 30),

            Text('Your data', style: AppTextStyles.sectionTitle()),

            const SizedBox(height: 14),

            Text(
              'Your saved product history is stored locally '
              'on this device. Skinprint does not currently '
              'provide account-based backup or synchronization.',
              style: AppTextStyles.bodyMedium(),
            ),

            const SizedBox(height: 12),

            Text(
              'Deleting the app or clearing its local data '
              'may remove your saved Skinprint history.',
              style: AppTextStyles.caption(),
            ),

            const SizedBox(height: 34),

            const Divider(),

            const SizedBox(height: 30),

            Text('Data sources', style: AppTextStyles.sectionTitle()),

            const SizedBox(height: 18),

            const _SourceRow(
              number: '01',
              title: 'Open Beauty Facts',
              description:
                  'Product names, images, barcodes, and ingredient lists.',
            ),

            const SizedBox(height: 24),

            const _SourceRow(
              number: '02',
              title: 'CosIng-compatible data',
              description: 'INCI ingredient names and cosmetic functions.',
            ),

            const SizedBox(height: 24),

            const _SourceRow(
              number: '03',
              title: 'PubChem',
              description:
                  'Supplementary general descriptions for supported ingredients.',
            ),

            const SizedBox(height: 30),

            Text(
              'Skinprint is a prototype and its information '
              'is intended for educational and exploratory use.',
              style: AppTextStyles.caption(),
            ),
          ],
        ),
      ),
    );
  }
}

class _SourceRow extends StatelessWidget {
  final String number;
  final String title;
  final String description;

  const _SourceRow({
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
          width: 42,
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

              const SizedBox(height: 5),

              Text(
                description,
                style: AppTextStyles.bodyMedium(color: AppColors.textSecondary),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
