import 'package:flutter/material.dart';

import 'package:skinprint/core/theme/app_colors.dart';
import 'package:skinprint/core/theme/app_text_styles.dart';
import 'package:skinprint/features/home/screens/home_page.dart';
import 'package:skinprint/features/my_products/controllers/saved_products_controller.dart';
import 'package:skinprint/features/my_products/screens/my_products_page.dart';
import 'package:skinprint/features/ingredients/screens/ingredients_page.dart';

class MainShell extends StatefulWidget {
  const MainShell({super.key});

  @override
  State<MainShell> createState() => _MainShellState();
}

class _MainShellState extends State<MainShell> {
  int _selectedIndex = 0;

  late final SavedProductsController _savedProductsController;

  @override
  void initState() {
    super.initState();

    _savedProductsController = SavedProductsController();
  }

  @override
  void dispose() {
    _savedProductsController.dispose();

    super.dispose();
  }

  void _selectTab(int index) {
    setState(() {
      _selectedIndex = index;
    });

    if (index == 1 || index == 2) {
      _savedProductsController.loadProducts();
    }
  }

  Widget _buildCurrentPage() {
    switch (_selectedIndex) {
      case 0:
        return HomePage(savedProductsController: _savedProductsController);

      case 1:
        return MyProductsPage(controller: _savedProductsController);

      case 2:
        return IngredientsPage(
          savedProductsController: _savedProductsController,
        );

      default:
        return HomePage(savedProductsController: _savedProductsController);
    }
  }

  Widget _buildAppBarTitle() {
    switch (_selectedIndex) {
      case 0:
        return Text(
          'Skinprint',
          style: AppTextStyles.brand(color: AppColors.onPrimary),
        );

      case 1:
        return const Text('My Products');

      case 2:
        return const Text('Ingredients');

      default:
        return const Text('Skinprint');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(toolbarHeight: 68, title: _buildAppBarTitle()),

      body: _buildCurrentPage(),

      bottomNavigationBar: Container(
        decoration: const BoxDecoration(
          border: Border(top: BorderSide(color: AppColors.border)),
        ),
        child: BottomNavigationBar(
          currentIndex: _selectedIndex,
          onTap: _selectTab,

          backgroundColor: AppColors.surface,

          elevation: 0,

          selectedItemColor: AppColors.primaryAction,

          unselectedItemColor: AppColors.textSecondary,

          selectedLabelStyle: AppTextStyles.caption(
            color: AppColors.primaryAction,
          ).copyWith(fontWeight: FontWeight.w600),

          unselectedLabelStyle: AppTextStyles.caption(),

          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.home_outlined),
              activeIcon: Icon(Icons.home),
              label: 'Home',
            ),

            BottomNavigationBarItem(
              icon: Icon(Icons.list_alt_outlined),
              activeIcon: Icon(Icons.list_alt),
              label: 'My Products',
            ),

            BottomNavigationBarItem(
              icon: Icon(Icons.science_outlined),
              activeIcon: Icon(Icons.science),
              label: 'Ingredients',
            ),
          ],
        ),
      ),
    );
  }
}
