import 'package:flutter/material.dart';

import '/core/theme/app_colors.dart';
import '/core/theme/app_text_styles.dart';
import '/core/widgets/primary_button.dart';
import '/features/product_check/data/open_beauty_facts_service.dart';
import '/features/product_check/models/beauty_product.dart';
import '/features/product_check/widgets/product_result_card.dart';
import 'product_detail_page.dart';
import '/features/my_products/controllers/saved_products_controller.dart';

class ProductSearchPage extends StatefulWidget {
  final SavedProductsController savedProductsController;
  const ProductSearchPage({super.key, required this.savedProductsController});

  @override
  State<ProductSearchPage> createState() =>
      _ProductSearchPageState();
}

class _ProductSearchPageState extends State<ProductSearchPage> {
  final TextEditingController _searchController =
      TextEditingController();

  final OpenBeautyFactsService _service =
      OpenBeautyFactsService();

  List<BeautyProduct> _products = [];

  bool _isLoading = false;
  bool _hasSearched = false;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    widget.savedProductsController.loadProducts();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _search() async {
    final query = _searchController.text.trim();

    if (query.isEmpty) {
      setState(() {
        _errorMessage =
            'Enter a product name, brand, or barcode.';
      });

      return;
    }

    FocusScope.of(context).unfocus();

    setState(() {
      _isLoading = true;
      _hasSearched = true;
      _errorMessage = null;
      _products = [];
    });

    try {
      final results =
          await _service.searchProducts(query);

      if (!mounted) {
        return;
      }

      setState(() {
        _products = results;
      });
    } catch (_) {
      if (!mounted) {
        return;
      }

      setState(() {
        _errorMessage =
            'We couldn\'t load products right now. '
            'Try again or search using a barcode.';
      });
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  void _openProduct(
    BeautyProduct product,
  ) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => ProductDetailPage(
          product: product,
          savedProductsController:
              widget.savedProductsController,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Check a Product'),
      ),
      body: SafeArea(
        top: false,
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(
                24,
                34,
                24,
                26,
              ),
              child: Column(
                crossAxisAlignment:
                    CrossAxisAlignment.start,
                children: [
                  Text(
                    'Find your product.',
                    style:
                        AppTextStyles.displayMedium(),
                  ),

                  const SizedBox(height: 10),

                  Text(
                    'Search by product name, brand, '
                    'or barcode.',
                    style:
                        AppTextStyles.bodyMedium(),
                  ),

                  const SizedBox(height: 24),

                  TextField(
                    controller: _searchController,
                    textInputAction:
                        TextInputAction.search,
                    onSubmitted: (_) => _search(),
                    style:
                        AppTextStyles.bodyLarge(),
                    decoration:
                        const InputDecoration(
                      hintText:
                          'COSRX, Rhode,...',
                    ),
                  ),

                  const SizedBox(height: 14),

                  PrimaryButton(
                    label: 'Search',
                    onPressed: _search,
                    isLoading: _isLoading,
                  ),

                  if (_errorMessage != null) ...[
                    const SizedBox(height: 14),

                    Text(
                      _errorMessage!,
                      style:
                          AppTextStyles.bodyMedium(
                        color:
                            AppColors.concern,
                      ),
                    ),
                  ],
                ],
              ),
            ),

            const Divider(),

            Expanded(
              child: _buildResults(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildResults() {
    if (_isLoading) {
      return const Center(
        child: CircularProgressIndicator(
          color: AppColors.primaryAction,
        ),
      );
    }

    if (!_hasSearched) {
      return Padding(
        padding: const EdgeInsets.all(36),
        child: Align(
          alignment: Alignment.topLeft,
          child: Text(
            'Search for something you already use, '
            'or something you’re thinking of buying.',
            style: AppTextStyles.bodyLarge(
              color: AppColors.textSecondary,
            ),
          ),
        ),
      );
    }

    if (_products.isEmpty) {
      return Padding(
        padding: const EdgeInsets.all(36),
        child: Align(
          alignment: Alignment.topLeft,
          child: Column(
            crossAxisAlignment:
                CrossAxisAlignment.start,
            children: [
              Text(
                'Nothing came up.',
                style:
                    AppTextStyles.sectionTitle(),
              ),

              const SizedBox(height: 8),

              Text(
                'Try another spelling, brand name, '
                'or barcode.',
                style:
                    AppTextStyles.bodyMedium(),
              ),
            ],
          ),
        ),
      );
    }

    return ListView.separated(
      padding: const EdgeInsets.symmetric(
        horizontal: 24,
      ),
      itemCount: _products.length,
      separatorBuilder: (_, __) =>
          const Divider(),
      itemBuilder: (context, index) {
        final product = _products[index];

        return ProductResultCard(
          product: product,
          onTap: () => _openProduct(product),
        );
      },
    );
  }
}