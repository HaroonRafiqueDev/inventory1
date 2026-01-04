import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:inventory_system/core/database/models/sale_item_model.dart';
import 'package:inventory_system/core/database/models/sale_model.dart';
import 'package:inventory_system/features/sales/repositories/sale_repository.dart';

// Events
abstract class SaleEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class LoadSales extends SaleEvent {}

class CreateSale extends SaleEvent {
  final SaleModel sale;
  final List<SaleItemModel> items;
  CreateSale(this.sale, this.items);
  @override
  List<Object?> get props => [sale, items];
}

class DeleteSale extends SaleEvent {
  final int id;
  DeleteSale(this.id);
  @override
  List<Object?> get props => [id];
}

// States
abstract class SaleState extends Equatable {
  @override
  List<Object?> get props => [];
}

class SaleInitial extends SaleState {}

class SaleLoading extends SaleState {}

class SalesLoaded extends SaleState {
  final List<SaleModel> sales;
  SalesLoaded(this.sales);
  @override
  List<Object?> get props => [sales];
}

class SaleOperationSuccess extends SaleState {
  final String message;
  SaleOperationSuccess(this.message);
  @override
  List<Object?> get props => [message];
}

class SaleError extends SaleState {
  final String message;
  SaleError(this.message);
  @override
  List<Object?> get props => [message];
}

// Bloc
class SaleBloc extends Bloc<SaleEvent, SaleState> {
  final SaleRepository _repository;

  SaleBloc(this._repository) : super(SaleInitial()) {
    on<LoadSales>(_onLoadSales);
    on<CreateSale>(_onCreateSale);
    on<DeleteSale>(_onDeleteSale);
  }

  Future<void> _onLoadSales(LoadSales event, Emitter<SaleState> emit) async {
    emit(SaleLoading());
    try {
      final sales = await _repository.getAllSales();
      emit(SalesLoaded(sales));
    } catch (e) {
      emit(SaleError(e.toString()));
    }
  }

  Future<void> _onCreateSale(CreateSale event, Emitter<SaleState> emit) async {
    emit(SaleLoading());
    try {
      await _repository.createSale(event.sale, event.items);
      emit(SaleOperationSuccess('Sale completed successfully'));
      add(LoadSales());
    } catch (e) {
      emit(SaleError(e.toString()));
    }
  }

  Future<void> _onDeleteSale(DeleteSale event, Emitter<SaleState> emit) async {
    emit(SaleLoading());
    try {
      await _repository.deleteSale(event.id);
      emit(SaleOperationSuccess('Sale deleted and stock adjusted'));
      add(LoadSales());
    } catch (e) {
      emit(SaleError(e.toString()));
    }
  }
}
