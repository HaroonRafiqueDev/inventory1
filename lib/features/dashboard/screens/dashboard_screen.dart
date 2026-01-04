import 'package:flutter/material.dart';
import 'package:inventory_system/features/categories/screens/categories_screen.dart';
import 'package:inventory_system/features/dashboard/screens/dashboard_overview_screen.dart';
import 'package:inventory_system/features/inventory/screens/stock_adjustment_screen.dart';
import 'package:inventory_system/features/products/screens/products_screen.dart';
import 'package:inventory_system/features/purchases/screens/purchases_screen.dart';
import 'package:inventory_system/features/reports/screens/reports_screen.dart';
import 'package:inventory_system/features/sales/screens/sales_screen.dart';
import 'package:inventory_system/features/settings/screens/settings_screen.dart';
import 'package:inventory_system/features/suppliers/screens/suppliers_screen.dart';
import 'package:inventory_system/shared/widgets/app_sidebar.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  int _selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    final List<Widget> _screens = [
      DashboardOverviewScreen(onAction: (index) {
        setState(() {
          _selectedIndex = index;
        });
      }),
      const ProductsScreen(),
      const StockAdjustmentScreen(),
      const CategoriesScreen(),
      const SuppliersScreen(),
      const PurchasesScreen(),
      const SalesScreen(),
      const ReportsScreen(),
      const SettingsScreen(),
    ];

    return Scaffold(
      body: Row(
        children: [
          AppSidebar(
            selectedIndex: _selectedIndex,
            onDestinationSelected: (index) {
              setState(() {
                _selectedIndex = index;
              });
            },
          ),
          const VerticalDivider(thickness: 1, width: 1),
          Expanded(
            child: IndexedStack(
              index: _selectedIndex,
              children: _screens,
            ),
          ),
        ],
      ),
    );
  }
}
