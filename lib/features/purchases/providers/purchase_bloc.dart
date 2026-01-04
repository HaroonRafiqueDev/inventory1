import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:inventory_system/core/database/models/purchase_item_model.dart';
import 'package:inventory_system/core/database/models/purchase_model.dart';
import 'package:inventory_system/features/purchases/repositories/purchase_repository.dart';

// Events
abstract class PurchaseEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class LoadPurchases extends PurchaseEvent {}

class CreatePurchase extends PurchaseEvent {
  final PurchaseModel purchase;
  final List<PurchaseItemModel> items;
  CreatePurchase(this.purchase, this.items);
  @override
  List<Object?> get props => [purchase, items];
}

class DeletePurchase extends PurchaseEvent {
  final int id;
  DeletePurchase(this.id);
  @override
  List<Object?> get props => [id];
}

// States
abstract class PurchaseState extends Equatable {
  @override
  List<Object?> get props => [];
}

class PurchaseInitial extends PurchaseState {}

class PurchaseLoading extends PurchaseState {}

class PurchasesLoaded extends PurchaseState {
  final List<PurchaseModel> purchases;
  PurchasesLoaded(this.purchases);
  @override
  List<Object?> get props => [purchases];
}

class PurchaseOperationSuccess extends PurchaseState {
  final String message;
  PurchaseOperationSuccess(this.message);
  @override
  List<Object?> get props => [message];
}

class PurchaseError extends PurchaseState {
  final String message;
  PurchaseError(this.message);
  @override
  List<Object?> get props => [message];
}

// Bloc
class PurchaseBloc extends Bloc<PurchaseEvent, PurchaseState> {
  final PurchaseRepository _repository;

  PurchaseBloc(this._repository) : super(PurchaseInitial()) {
    on<LoadPurchases>(_onLoadPurchases);
    on<CreatePurchase>(_onCreatePurchase);
    on<DeletePurchase>(_onDeletePurchase);
  }

  Future<void> _onLoadPurchases(
      LoadPurchases event, Emitter<PurchaseState> emit) async {
    emit(PurchaseLoading());
    try {
      final purchases = await _repository.getAllPurchases();
      emit(PurchasesLoaded(purchases));
    } catch (e) {
      emit(PurchaseError(e.toString()));
    }
  }

  Future<void> _onCreatePurchase(
      CreatePurchase event, Emitter<PurchaseState> emit) async {
    emit(PurchaseLoading());
    try {
      await _repository.createPurchase(event.purchase, event.items);
      emit(PurchaseOperationSuccess('Purchase created successfully'));
      add(LoadPurchases());
    } catch (e) {
      emit(PurchaseError(e.toString()));
    }
  }

  Future<void> _onDeletePurchase(
      DeletePurchase event, Emitter<PurchaseState> emit) async {
    emit(PurchaseLoading());
    try {
      await _repository.deletePurchase(event.id);
      emit(PurchaseOperationSuccess('Purchase deleted and stock adjusted'));
      add(LoadPurchases());
    } catch (e) {
      emit(PurchaseError(e.toString()));
    }
  }
}
