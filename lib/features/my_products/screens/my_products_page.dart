import 'package:flutter/material.dart';

import 'package:skinprint/core/theme/app_colors.dart';
import 'package:skinprint/core/theme/app_text_styles.dart';
import 'package:skinprint/features/my_products/controllers/saved_products_controller.dart';
import 'package:skinprint/features/my_products/models/product_reaction.dart';
import 'package:skinprint/features/my_products/models/saved_product.dart';
import 'package:skinprint/features/my_products/widgets/saved_product_row.dart';
import 'saved_product_detail_page.dart';

enum _ProductFilter { all, worked, didntWork, neutral }

class MyProductsPage extends StatefulWidget {
  final SavedProductsController controller;

  const MyProductsPage({super.key, required this.controller});

  @override
  State<MyProductsPage> createState() => _MyProductsPageState();
}

class _MyProductsPageState extends State<MyProductsPage> {
  _ProductFilter selectedFilter = _ProductFilter.all;

  SavedProductsController get controller => widget.controller;

  void _openProduct(BuildContext context, SavedProduct product) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => SavedProductDetailPage(
          initialProduct: product,
          controller: controller,
        ),
      ),
    );
  }

  List<SavedProduct> get filteredProducts {
    switch (selectedFilter) {
      case _ProductFilter.worked:
        return controller.products
            .where((product) => product.reaction == ProductReaction.worked)
            .toList();

      case _ProductFilter.didntWork:
        return controller.products
            .where((product) => product.reaction == ProductReaction.didntWork)
            .toList();

      case _ProductFilter.neutral:
        return controller.products
            .where((product) => product.reaction == ProductReaction.neutral)
            .toList();

      case _ProductFilter.all:
        return controller.products;
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
      child: AnimatedBuilder(
        animation: controller,
        builder: (context, child) {
          if (controller.isLoading && !controller.hasLoaded) {
            return const Center(
              child: CircularProgressIndicator(color: AppColors.primaryAction),
            );
          }

          final products = filteredProducts;

          return RefreshIndicator(
            color: AppColors.primaryAction,
            onRefresh: () => controller.loadProducts(force: true),
            child: ListView(
              padding: const EdgeInsets.fromLTRB(24, 38, 24, 40),
              children: [
                Text(
                  'Your product history.',
                  style: AppTextStyles.displayMedium(),
                ),

                const SizedBox(height: 12),

                Text(
                  'Products you save here become '
                  'the personal context Skinprint '
                  'uses to understand what has and '
                  'hasn\'t worked for you.',
                  style: AppTextStyles.bodyLarge(
                    color: AppColors.textSecondary,
                  ),
                ),

                if (controller.products.isNotEmpty) ...[
                  const SizedBox(height: 28),

                  _FilterBar(
                    selected: selectedFilter,
                    onChanged: (filter) {
                      setState(() {
                        selectedFilter = filter;
                      });
                    },
                  ),
                ],

                const SizedBox(height: 28),

                const Divider(),

                if (controller.errorMessage != null) ...[
                  const SizedBox(height: 24),

                  Text(
                    controller.errorMessage!,
                    style: AppTextStyles.bodyMedium(color: AppColors.concern),
                  ),
                ],

                if (controller.products.isEmpty)
                  const _EmptyHistory()
                else if (products.isEmpty)
                  _EmptyFilter(filter: selectedFilter)
                else
                  ..._buildProductList(context, products),
              ],
            ),
          );
        },
      ),
    );
  }

  List<Widget> _buildProductList(
    BuildContext context,
    List<SavedProduct> products,
  ) {
    final widgets = <Widget>[];

    final showReactionLabel = selectedFilter == _ProductFilter.all;

    for (var i = 0; i < products.length; i++) {
      final product = products[i];

      widgets.add(
        SavedProductRow(
          product: product,
          showReactionLabel: showReactionLabel,
          onTap: () => _openProduct(context, product),
        ),
      );

      if (i < products.length - 1) {
        widgets.add(const Divider());
      }
    }

    return widgets;
  }
}

class _FilterBar extends StatelessWidget {
  final _ProductFilter selected;
  final ValueChanged<_ProductFilter> onChanged;

  const _FilterBar({required this.selected, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: [
          _FilterButton(
            label: 'All',
            value: _ProductFilter.all,
            selected: selected,
            onChanged: onChanged,
          ),

          const SizedBox(width: 8),

          _FilterButton(
            label: 'Worked',
            value: _ProductFilter.worked,
            selected: selected,
            onChanged: onChanged,
          ),

          const SizedBox(width: 8),

          _FilterButton(
            label: 'Didn\'t work',
            value: _ProductFilter.didntWork,
            selected: selected,
            onChanged: onChanged,
          ),

          const SizedBox(width: 8),

          _FilterButton(
            label: 'Neutral',
            value: _ProductFilter.neutral,
            selected: selected,
            onChanged: onChanged,
          ),
        ],
      ),
    );
  }
}

class _FilterButton extends StatelessWidget {
  final String label;
  final _ProductFilter value;
  final _ProductFilter selected;
  final ValueChanged<_ProductFilter> onChanged;

  const _FilterButton({
    required this.label,
    required this.value,
    required this.selected,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    final isSelected = value == selected;

    return InkWell(
      onTap: () => onChanged(value),
      borderRadius: BorderRadius.circular(8),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.primaryAction : Colors.transparent,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: isSelected ? AppColors.primaryAction : AppColors.border,
          ),
        ),
        child: Text(
          label,
          style: AppTextStyles.bodyMedium(
            color: isSelected ? Colors.white : AppColors.textPrimary,
          ).copyWith(fontWeight: FontWeight.w500),
        ),
      ),
    );
  }
}

class _EmptyHistory extends StatelessWidget {
  const _EmptyHistory();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 38),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Nothing here yet.', style: AppTextStyles.sectionTitle()),

          const SizedBox(height: 10),

          Text(
            'Find a product from Home and '
            'save how it worked for you. '
            'Your history will appear here.',
            style: AppTextStyles.bodyMedium(),
          ),
        ],
      ),
    );
  }
}

class _EmptyFilter extends StatelessWidget {
  final _ProductFilter filter;

  const _EmptyFilter({required this.filter});

  String get message {
    switch (filter) {
      case _ProductFilter.worked:
        return 'No products marked as worked yet.';

      case _ProductFilter.didntWork:
        return 'No products marked as didn\'t work yet.';

      case _ProductFilter.neutral:
        return 'No neutral products yet.';

      case _ProductFilter.all:
        return '';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 38),
      child: Text(
        message,
        style: AppTextStyles.bodyMedium(color: AppColors.textSecondary),
      ),
    );
  }
}
