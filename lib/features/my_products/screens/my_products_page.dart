import 'package:flutter/material.dart';


import '/core/theme/app_colors.dart';
import '/core/theme/app_text_styles.dart';
import '/features/my_products/controllers/saved_products_controller.dart';
import '/features/my_products/models/saved_product.dart';
import '/features/my_products/widgets/saved_product_row.dart';
import 'saved_product_detail_page.dart';

class MyProductsPage
    extends StatelessWidget {
  final SavedProductsController controller;

  const MyProductsPage({
    super.key,
    required this.controller,
  });

  void _openProduct(
    BuildContext context,
    SavedProduct product,
  ) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) =>
            SavedProductDetailPage(
          initialProduct: product,
          controller: controller,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
      child: AnimatedBuilder(
        animation: controller,
        builder: (
          context,
          child,
        ) {
          if (controller.isLoading &&
              !controller.hasLoaded) {
            return const Center(
              child:
                  CircularProgressIndicator(
                color:
                    AppColors.primaryAction,
              ),
            );
          }

          return RefreshIndicator(
            color:
                AppColors.primaryAction,
            onRefresh: () =>
                controller.loadProducts(
              force: true,
            ),
            child: ListView(
              padding:
                  const EdgeInsets.fromLTRB(
                24,
                38,
                24,
                40,
              ),
              children: [
                Text(
                  'Your product history.',
                  style:
                      AppTextStyles.displayMedium(),
                ),

                const SizedBox(height: 12),

                Text(
                  'Products you save here become '
                  'the personal context Skinprint '
                  'uses to understand what has and '
                  'hasn\'t worked for you.',
                  style:
                      AppTextStyles.bodyLarge(
                    color:
                        AppColors.textSecondary,
                  ),
                ),

                if (controller
                    .products.isNotEmpty) ...[
                  const SizedBox(height: 24),

                  _HistorySummary(
                    controller:
                        controller,
                  ),
                ],

                const SizedBox(height: 30),

                const Divider(),

                if (controller.errorMessage !=
                    null) ...[
                  const SizedBox(height: 24),

                  Text(
                    controller.errorMessage!,
                    style:
                        AppTextStyles.bodyMedium(
                      color:
                          AppColors.concern,
                    ),
                  ),
                ],

                if (controller
                    .products.isEmpty)
                  const _EmptyHistory()
                else
                  ..._buildProductList(
                    context,
                  ),
              ],
            ),
          );
        },
      ),
    );
  }

  List<Widget> _buildProductList(
    BuildContext context,
  ) {
    final widgets = <Widget>[];

    for (var i = 0;
        i < controller.products.length;
        i++) {
      final product =
          controller.products[i];

      widgets.add(
        SavedProductRow(
          product: product,
          onTap: () =>
              _openProduct(
            context,
            product,
          ),
        ),
      );

      if (i <
          controller.products.length -
              1) {
        widgets.add(
          const Divider(),
        );
      }
    }

    return widgets;
  }
}

class _HistorySummary
    extends StatelessWidget {
  final SavedProductsController controller;

  const _HistorySummary({
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    return Text.rich(
      TextSpan(
        style:
            AppTextStyles.bodyMedium(),
        children: [
          TextSpan(
            text:
                '${controller.totalProducts} saved',
            style:
                const TextStyle(
              fontWeight:
                  FontWeight.w600,
              color:
                  AppColors.textPrimary,
            ),
          ),

          const TextSpan(
            text: '  ·  ',
          ),

          TextSpan(
            text:
                '${controller.workedCount} worked',
            style: const TextStyle(
              color: AppColors.good,
            ),
          ),

          const TextSpan(
            text: '  ·  ',
          ),

          TextSpan(
            text:
                '${controller.didntWorkCount} didn\'t',
            style: const TextStyle(
              color:
                  AppColors.concern,
            ),
          ),

          const TextSpan(
            text: '  ·  ',
          ),

          TextSpan(
            text:
                '${controller.neutralCount} neutral',
          ),
        ],
      ),
    );
  }
}

class _EmptyHistory
    extends StatelessWidget {
  const _EmptyHistory();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding:
          const EdgeInsets.only(
        top: 38,
      ),
      child: Column(
        crossAxisAlignment:
            CrossAxisAlignment.start,
        children: [
          Text(
            'Nothing here yet.',
            style:
                AppTextStyles.sectionTitle(),
          ),

          const SizedBox(height: 10),

          Text(
            'Find a product from Home and '
            'save how it worked for you. '
            'Your history will appear here.',
            style:
                AppTextStyles.bodyMedium(),
          ),
        ],
      ),
    );
  }
}