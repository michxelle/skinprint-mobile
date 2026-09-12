import 'package:flutter/material.dart';

import 'package:skinprint/core/theme/app_colors.dart';
import 'package:skinprint/core/theme/app_text_styles.dart';
import 'package:skinprint/features/ingredients/data/ingredient_api_service.dart';
import 'package:skinprint/features/ingredients/models/ingredient_history.dart';
import 'package:skinprint/features/ingredients/models/ingredient_info.dart';
import 'package:skinprint/features/ingredients/services/ingredient_history_service.dart';
import 'package:skinprint/features/my_products/controllers/saved_products_controller.dart';

class IngredientDetailPage extends StatefulWidget {
  final String ingredientName;

  final IngredientInfo? initialIngredient;

  final SavedProductsController savedProductsController;

  const IngredientDetailPage({
    super.key,
    required this.ingredientName,
    required this.savedProductsController,
    this.initialIngredient,
  });

  @override
  State<IngredientDetailPage> createState() => _IngredientDetailPageState();
}

class _IngredientDetailPageState extends State<IngredientDetailPage> {
  final IngredientApiService _service = IngredientApiService();

  IngredientInfo? _ingredient;

  bool _isLoading = true;
  String? _errorMessage;

  late IngredientHistory _history;

  @override
  void initState() {
    super.initState();

    _ingredient = widget.initialIngredient;

    _history = IngredientHistoryService.build(
      ingredientName: widget.ingredientName,
      products: widget.savedProductsController.products,
    );

    _loadDetails();
  }

  Future<void> _loadDetails() async {
    try {
      final result = await _service.getIngredientInfo(widget.ingredientName);

      if (!mounted) {
        return;
      }

      if (result != null) {
        setState(() {
          _ingredient = result;
        });
      }
    } catch (_) {
      if (!mounted) {
        return;
      }

      if (_ingredient == null) {
        setState(() {
          _errorMessage =
              'Detailed information is not available '
              'for this ingredient right now.';
        });
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final ingredient = _ingredient;

    return Scaffold(
      appBar: AppBar(title: const Text('Ingredient')),
      body: SafeArea(
        top: false,
        child: ListView(
          padding: const EdgeInsets.fromLTRB(24, 36, 24, 44),
          children: [
            Text(
              (ingredient?.name ?? widget.ingredientName).toUpperCase(),
              style: AppTextStyles.label(color: AppColors.primaryAction),
            ),

            const SizedBox(height: 10),

            Text(
              ingredient?.name ?? widget.ingredientName,
              style: AppTextStyles.displayLarge(),
            ),

            if (_isLoading) ...[
              const SizedBox(height: 20),

              const LinearProgressIndicator(
                color: AppColors.primaryAction,
                backgroundColor: AppColors.primarySoft,
              ),
            ],

            if (_errorMessage != null) ...[
              const SizedBox(height: 18),

              Text(
                _errorMessage!,
                style: AppTextStyles.bodyMedium(color: AppColors.concern),
              ),
            ],

            const SizedBox(height: 34),

            const Divider(),

            const SizedBox(height: 30),

            Text('What it is', style: AppTextStyles.sectionTitle()),

            const SizedBox(height: 12),

            Text(
              ingredient?.description ??
                  'A detailed general description '
                      'is not available from the connected '
                      'data sources for this ingredient.',
              style: AppTextStyles.bodyLarge(color: AppColors.textSecondary),
            ),

            if (ingredient?.casNumber != null ||
                ingredient?.ecNumber != null) ...[
              const SizedBox(height: 18),

              _Identifiers(ingredient: ingredient!),
            ],

            const SizedBox(height: 34),

            const Divider(),

            const SizedBox(height: 30),

            Text('What it’s used for', style: AppTextStyles.sectionTitle()),

            const SizedBox(height: 12),

            if (ingredient == null || ingredient.functions.isEmpty)
              Text(
                'Cosmetic function information '
                'is not available for this ingredient.',
                style: AppTextStyles.bodyMedium(),
              )
            else
              ...ingredient.functions.map(
                (function) => Padding(
                  padding: const EdgeInsets.only(bottom: 10),
                  child: _FunctionRow(function: function),
                ),
              ),

            const SizedBox(height: 28),

            const Divider(),

            const SizedBox(height: 30),

            Text('Your Skinprint', style: AppTextStyles.sectionTitle()),

            const SizedBox(height: 12),

            if (!_history.hasHistory)
              Text(
                'This ingredient hasn’t appeared '
                'in your saved product history yet.',
                style: AppTextStyles.bodyMedium(),
              )
            else
              _HistorySection(history: _history),

            const SizedBox(height: 34),

            const Divider(),

            const SizedBox(height: 24),

            Text(
              'Cosmetic function data is based on '
              'CosIng-compatible data. General chemical '
              'descriptions may be supplemented by PubChem.',
              style: AppTextStyles.caption(),
            ),

            const SizedBox(height: 10),

            Text(
              'Ingredient information is educational '
              'and does not determine whether an ingredient '
              'is safe, suitable, or effective for you.',
              style: AppTextStyles.caption(),
            ),
          ],
        ),
      ),
    );
  }
}

class _Identifiers extends StatelessWidget {
  final IngredientInfo ingredient;

  const _Identifiers({required this.ingredient});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (ingredient.casNumber != null)
          Text('CAS ${ingredient.casNumber}', style: AppTextStyles.caption()),

        if (ingredient.ecNumber != null)
          Text('EC ${ingredient.ecNumber}', style: AppTextStyles.caption()),
      ],
    );
  }
}

class _FunctionRow extends StatelessWidget {
  final String function;

  const _FunctionRow({required this.function});

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 6,
          height: 6,
          margin: const EdgeInsets.only(top: 8),
          decoration: const BoxDecoration(
            color: AppColors.primary,
            shape: BoxShape.circle,
          ),
        ),

        const SizedBox(width: 12),

        Expanded(child: Text(function, style: AppTextStyles.bodyLarge())),
      ],
    );
  }
}

class _HistorySection extends StatelessWidget {
  final IngredientHistory history;

  const _HistorySection({required this.history});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Seen in ${history.totalOccurrences} '
          '${history.totalOccurrences == 1 ? 'saved product' : 'saved products'}.',
          style: AppTextStyles.bodyMedium(),
        ),

        if (history.workedProductNames.isNotEmpty) ...[
          const SizedBox(height: 22),

          _HistoryGroup(
            label: 'WORKED FOR YOU',
            productNames: history.workedProductNames,
            color: AppColors.good,
          ),
        ],

        if (history.didntWorkProductNames.isNotEmpty) ...[
          const SizedBox(height: 22),

          _HistoryGroup(
            label: 'DIDN’T WORK FOR YOU',
            productNames: history.didntWorkProductNames,
            color: AppColors.concern,
          ),
        ],

        if (history.neutralProductNames.isNotEmpty) ...[
          const SizedBox(height: 22),

          _HistoryGroup(
            label: 'NEUTRAL',
            productNames: history.neutralProductNames,
            color: AppColors.primaryAction,
          ),
        ],
      ],
    );
  }
}

class _HistoryGroup extends StatelessWidget {
  final String label;
  final List<String> productNames;
  final Color color;

  const _HistoryGroup({
    required this.label,
    required this.productNames,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: AppTextStyles.label(color: color)),

        const SizedBox(height: 8),

        ...productNames.map(
          (name) => Padding(
            padding: const EdgeInsets.only(bottom: 5),
            child: Text(
              name,
              style: AppTextStyles.bodyMedium(color: AppColors.textPrimary),
            ),
          ),
        ),
      ],
    );
  }
}
