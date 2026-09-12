import 'package:flutter/material.dart';

import 'package:skinprint/core/theme/app_colors.dart';
import 'package:skinprint/core/theme/app_text_styles.dart';
import 'package:skinprint/core/widgets/primary_button.dart';
import 'package:skinprint/features/ingredients/data/ingredient_api_service.dart';
import 'package:skinprint/features/ingredients/models/ingredient_info.dart';
import 'package:skinprint/features/ingredients/screens/ingredient_detail_page.dart';
import 'package:skinprint/features/ingredients/widgets/ingredient_search_row.dart';
import 'package:skinprint/features/my_products/controllers/saved_products_controller.dart';

class IngredientsPage extends StatefulWidget {
  final SavedProductsController savedProductsController;

  const IngredientsPage({super.key, required this.savedProductsController});

  @override
  State<IngredientsPage> createState() => _IngredientsPageState();
}

class _IngredientsPageState extends State<IngredientsPage> {
  final TextEditingController _searchController = TextEditingController();

  final IngredientApiService _service = IngredientApiService();

  List<IngredientInfo> _results = [];

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
        _errorMessage = 'Enter an ingredient name.';
      });

      return;
    }

    FocusScope.of(context).unfocus();

    setState(() {
      _isLoading = true;
      _hasSearched = true;
      _errorMessage = null;
      _results = [];
    });

    try {
      final results = await _service.searchIngredients(query);

      if (!mounted) {
        return;
      }

      setState(() {
        _results = results;
      });
    } catch (_) {
      if (!mounted) {
        return;
      }

      setState(() {
        _errorMessage =
            'We couldn\'t load ingredient information '
            'right now. Please try again.';
      });
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  void _openIngredient(IngredientInfo ingredient) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => IngredientDetailPage(
          ingredientName: ingredient.name,
          initialIngredient: ingredient,
          savedProductsController: widget.savedProductsController,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(24, 38, 24, 26),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Explore what’s inside.',
                  style: AppTextStyles.displayMedium(),
                ),

                const SizedBox(height: 12),

                Text(
                  'Search an ingredient to learn '
                  'what it is, why it is used in '
                  'cosmetics, and where it appears '
                  'in your Skinprint.',
                  style: AppTextStyles.bodyLarge(
                    color: AppColors.textSecondary,
                  ),
                ),

                const SizedBox(height: 26),

                TextField(
                  controller: _searchController,
                  textInputAction: TextInputAction.search,
                  onSubmitted: (_) => _search(),
                  style: AppTextStyles.bodyLarge(),
                  decoration: const InputDecoration(
                    hintText: 'Niacinamide, glycerin...',
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
                    style: AppTextStyles.bodyMedium(color: AppColors.concern),
                  ),
                ],
              ],
            ),
          ),

          const Divider(),

          Expanded(child: _buildResults()),
        ],
      ),
    );
  }

  Widget _buildResults() {
    if (_isLoading) {
      return const Center(
        child: CircularProgressIndicator(color: AppColors.primaryAction),
      );
    }

    if (!_hasSearched) {
      return Padding(
        padding: const EdgeInsets.all(36),
        child: Align(
          alignment: Alignment.topLeft,
          child: Text(
            'Try searching for an ingredient '
            'you recognize from one of your products.',
            style: AppTextStyles.bodyLarge(color: AppColors.textSecondary),
          ),
        ),
      );
    }

    if (_results.isEmpty) {
      return Padding(
        padding: const EdgeInsets.all(36),
        child: Align(
          alignment: Alignment.topLeft,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('No ingredient found.', style: AppTextStyles.sectionTitle()),

              const SizedBox(height: 8),

              Text(
                'Try the INCI name or another spelling.',
                style: AppTextStyles.bodyMedium(),
              ),
            ],
          ),
        ),
      );
    }

    return ListView.separated(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      itemCount: _results.length,
      separatorBuilder: (_, __) => const Divider(),
      itemBuilder: (context, index) {
        final ingredient = _results[index];

        return IngredientSearchRow(
          ingredient: ingredient,
          onTap: () => _openIngredient(ingredient),
        );
      },
    );
  }
}
