import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:inventory_system/core/config/app_config.dart';
import 'package:inventory_system/core/database/hive_service.dart';
import 'package:inventory_system/core/theme/app_theme.dart';
import 'package:inventory_system/features/auth/providers/auth_bloc.dart';
import 'package:inventory_system/features/auth/screens/login_screen.dart';
import 'package:inventory_system/features/auth/services/auth_service.dart';
import 'package:inventory_system/features/categories/providers/category_bloc.dart';
import 'package:inventory_system/features/categories/repositories/category_repository.dart';
import 'package:inventory_system/features/dashboard/providers/dashboard_bloc.dart';
import 'package:inventory_system/features/dashboard/screens/dashboard_screen.dart';
import 'package:inventory_system/features/license/providers/license_bloc.dart';
import 'package:inventory_system/features/license/screens/license_activation_screen.dart';
import 'package:inventory_system/features/inventory/providers/stock_adjustment_bloc.dart';
import 'package:inventory_system/features/inventory/repositories/stock_adjustment_repository.dart';
import 'package:inventory_system/features/products/providers/product_bloc.dart';
import 'package:inventory_system/features/products/repositories/product_repository.dart';
import 'package:inventory_system/features/purchases/providers/purchase_bloc.dart';
import 'package:inventory_system/features/purchases/repositories/purchase_repository.dart';
import 'package:inventory_system/features/sales/providers/sale_bloc.dart';
import 'package:inventory_system/features/sales/repositories/sale_repository.dart';
import 'package:inventory_system/features/settings/services/settings_service.dart';

import 'package:inventory_system/features/suppliers/providers/supplier_bloc.dart';
import 'package:inventory_system/features/suppliers/repositories/supplier_repository.dart';

void main() {
  // Show a basic loading screen immediately to avoid white screen
  runApp(const MaterialApp(
    home: Scaffold(
      body: Center(
        child: CircularProgressIndicator(),
      ),
    ),
  ));

  _initialize();
}

Future<void> _initialize() async {
  WidgetsFlutterBinding.ensureInitialized();
  debugPrint('App Starting..');

  try {
    debugPrint('Initializing Hive...');
    // Initialize Services
    await HiveService.init();
    debugPrint('Hive Initialized.');

    debugPrint('Initializing Default Admin...');
    await AuthService.initDefaultAdmin();
    debugPrint('Admin Initialized.');

    debugPrint('Initializing Settings...');
    await SettingsService.init();
    debugPrint('Settings Initialized.');

    debugPrint('Running App...');
    runApp(const MyApp());
  } catch (e, stack) {
    debugPrint('Initialization Error: $e');
    debugPrint('Stack Trace: $stack');
    runApp(MaterialApp(
      home: Scaffold(
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.error_outline, size: 64, color: Colors.red),
                const SizedBox(height: 16),
                const Text('Failed to initialize application',
                    style:
                        TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                const SizedBox(height: 8),
                Text(e.toString(), textAlign: TextAlign.center),
                const SizedBox(height: 24),
                ElevatedButton(
                  onPressed: () => _initialize(),
                  child: const Text('Retry'),
                ),
              ],
            ),
          ),
        ),
      ),
    ));
  }
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
            create: (context) => LicenseBloc()..add(CheckLicenseStatus())),
        BlocProvider(create: (context) => AuthBloc()),
        BlocProvider(
            create: (context) => DashboardBloc()..add(LoadDashboardStats())),
        BlocProvider(
            create: (context) =>
                CategoryBloc(CategoryRepository())..add(LoadCategories())),
        BlocProvider(
            create: (context) =>
                ProductBloc(ProductRepository())..add(LoadProducts())),
        BlocProvider(
            create: (context) =>
                SupplierBloc(SupplierRepository())..add(LoadSuppliers())),
        BlocProvider(
            create: (context) =>
                PurchaseBloc(PurchaseRepository())..add(LoadPurchases())),
        BlocProvider(
            create: (context) => SaleBloc(SaleRepository())..add(LoadSales())),
        BlocProvider(
            create: (context) =>
                StockAdjustmentBloc(StockAdjustmentRepository())
                  ..add(LoadAdjustments())),
      ],
      child: MaterialApp(
        title: AppConfig.appName,
        debugShowCheckedModeBanner: false,
        theme: AppTheme.lightTheme,
        darkTheme: AppTheme.darkTheme,
        themeMode: ThemeMode.system,
        home: const InitializerScreen(),
      ),
    );
  }
}

class InitializerScreen extends StatelessWidget {
  const InitializerScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LicenseBloc, LicenseState>(
      builder: (context, licenseState) {
        if (licenseState is LicenseValid) {
          return BlocBuilder<AuthBloc, AuthState>(
            builder: (context, authState) {
              if (authState is Authenticated) {
                return const DashboardScreen();
              } else {
                return const LoginScreen();
              }
            },
          );
        } else if (licenseState is LicenseInvalid) {
          return const LicenseActivationScreen();
        } else if (licenseState is LicenseError) {
          return Scaffold(
            body: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.error_outline, size: 64, color: Colors.red),
                  const SizedBox(height: 16),
                  Text('Error: ${licenseState.message}'),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () =>
                        context.read<LicenseBloc>().add(CheckLicenseStatus()),
                    child: const Text('Retry'),
                  ),
                ],
              ),
            ),
          );
        }

        return const Scaffold(
          body: Center(
            child: CircularProgressIndicator(),
          ),
        );
      },
    );
  }
}
