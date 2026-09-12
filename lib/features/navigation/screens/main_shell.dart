import 'package:flutter/material.dart';

import 'package:skinprint/core/theme/app_colors.dart';
import 'package:skinprint/core/theme/app_text_styles.dart';
import 'package:skinprint/features/home/screens/home_page.dart';
import 'package:skinprint/features/my_products/controllers/saved_products_controller.dart';
import 'package:skinprint/features/my_products/screens/my_products_page.dart';

class MainShell
    extends StatefulWidget {
  const MainShell({
    super.key,
  });

  @override
  State<MainShell> createState() =>
      _MainShellState();
}

class _MainShellState
    extends State<MainShell> {
  int _selectedIndex = 0;

  late final SavedProductsController
      _savedProductsController;

  @override
  void initState() {
    super.initState();

    _savedProductsController =
        SavedProductsController();
  }

  @override
  void dispose() {
    _savedProductsController.dispose();

    super.dispose();
  }

  void _selectTab(
    int index,
  ) {
    setState(() {
      _selectedIndex = index;
    });

    if (index == 1) {
      _savedProductsController
          .loadProducts();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 68,
        title: _selectedIndex == 0
            ? Text(
                'Skinprint',
                style:
                    AppTextStyles.brand(
                  color:
                      AppColors.onPrimary,
                ),
              )
            : const Text(
                'My Products',
              ),
      ),

      body: _selectedIndex == 0
          ? HomePage(
              savedProductsController:
                  _savedProductsController,
            )
          : MyProductsPage(
              controller:
                  _savedProductsController,
            ),

      bottomNavigationBar:
          Container(
        decoration: const BoxDecoration(
          border: Border(
            top: BorderSide(
              color: AppColors.border,
            ),
          ),
        ),
        child: BottomNavigationBar(
          currentIndex:
              _selectedIndex,
          onTap: _selectTab,

          backgroundColor:
              AppColors.surface,

          elevation: 0,

          selectedItemColor:
              AppColors.primaryAction,

          unselectedItemColor:
              AppColors.textSecondary,

          selectedLabelStyle:
              AppTextStyles.caption(
            color:
                AppColors.primaryAction,
          ).copyWith(
            fontWeight:
                FontWeight.w600,
          ),

          unselectedLabelStyle:
              AppTextStyles.caption(),

          items: const [
            BottomNavigationBarItem(
              icon: Icon(
                Icons.home_outlined,
              ),
              activeIcon:
                  Icon(Icons.home),
              label: 'Home',
            ),

            BottomNavigationBarItem(
              icon: Icon(
                Icons.list_alt_outlined,
              ),
              activeIcon:
                  Icon(Icons.list_alt),
              label: 'My Products',
            ),
          ],
        ),
      ),
    );
  }
}