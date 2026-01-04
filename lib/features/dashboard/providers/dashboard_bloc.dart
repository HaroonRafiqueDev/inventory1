import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:inventory_system/core/database/hive_service.dart';
import 'package:inventory_system/core/database/models/product_model.dart';
import 'package:inventory_system/core/database/models/purchase_model.dart';
import 'package:inventory_system/core/database/models/sale_model.dart';

// Events
abstract class DashboardEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class LoadDashboardStats extends DashboardEvent {}

// States
class DashboardStats extends Equatable {
  final int totalProducts;
  final int lowStockCount;
  final double totalSales;
  final double totalProfit;
  final double totalPurchases;
  final List<SaleModel> recentSales;

  const DashboardStats({
    required this.totalProducts,
    required this.lowStockCount,
    required this.totalSales,
    required this.totalProfit,
    required this.totalPurchases,
    required this.recentSales,
  });

  @override
  List<Object?> get props => [
        totalProducts,
        lowStockCount,
        totalSales,
        totalProfit,
        totalPurchases,
        recentSales
      ];
}

abstract class DashboardState extends Equatable {
  @override
  List<Object?> get props => [];
}

class DashboardInitial extends DashboardState {}

class DashboardLoading extends DashboardState {}

class DashboardLoaded extends DashboardState {
  final DashboardStats stats;
  DashboardLoaded(this.stats);
  @override
  List<Object?> get props => [stats];
}

class DashboardError extends DashboardState {
  final String message;
  DashboardError(this.message);
  @override
  List<Object?> get props => [message];
}

// Bloc
class DashboardBloc extends Bloc<DashboardEvent, DashboardState> {
  DashboardBloc() : super(DashboardInitial()) {
    on<LoadDashboardStats>(_onLoadStats);
  }

  Future<void> _onLoadStats(
      LoadDashboardStats event, Emitter<DashboardState> emit) async {
    emit(DashboardLoading());
    try {
      final productBox = HiveService.getBox<ProductModel>('products');
      final saleBox = HiveService.getBox<SaleModel>('sales');
      final purchaseBox = HiveService.getBox<PurchaseModel>('purchases');

      final products = productBox.values.toList();
      final sales = saleBox.values.toList();
      final purchases = purchaseBox.values.toList();

      final totalProducts = products.length;
      final lowStockCount =
          products.where((p) => p.quantity <= p.minStockThreshold).length;
      final totalSales = sales.fold(0.0, (sum, s) => sum + s.totalAmount);
      final totalProfit = sales.fold(0.0, (sum, s) => sum + s.totalProfit);
      final totalPurchases =
          purchases.fold(0.0, (sum, p) => sum + p.totalAmount);

      final recentSales = sales
        ..sort((a, b) => b.saleDate.compareTo(a.saleDate));
      final top5Sales = recentSales.take(5).toList();

      emit(DashboardLoaded(DashboardStats(
        totalProducts: totalProducts,
        lowStockCount: lowStockCount,
        totalSales: totalSales,
        totalProfit: totalProfit,
        totalPurchases: totalPurchases,
        recentSales: top5Sales,
      )));
    } catch (e) {
      emit(DashboardError(e.toString()));
    }
  }
}
