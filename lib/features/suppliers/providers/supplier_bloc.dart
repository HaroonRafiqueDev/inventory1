import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:inventory_system/core/database/models/supplier_model.dart';
import 'package:inventory_system/features/suppliers/repositories/supplier_repository.dart';

// Events
abstract class SupplierEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class LoadSuppliers extends SupplierEvent {}

class SearchSuppliers extends SupplierEvent {
  final String query;
  SearchSuppliers(this.query);
  @override
  List<Object?> get props => [query];
}

class AddSupplier extends SupplierEvent {
  final SupplierModel supplier;
  AddSupplier(this.supplier);
  @override
  List<Object?> get props => [supplier];
}

class UpdateSupplier extends SupplierEvent {
  final SupplierModel supplier;
  UpdateSupplier(this.supplier);
  @override
  List<Object?> get props => [supplier];
}

class DeleteSupplier extends SupplierEvent {
  final int id;
  DeleteSupplier(this.id);
  @override
  List<Object?> get props => [id];
}

// States
abstract class SupplierState extends Equatable {
  @override
  List<Object?> get props => [];
}

class SupplierInitial extends SupplierState {}

class SupplierLoading extends SupplierState {}

class SuppliersLoaded extends SupplierState {
  final List<SupplierModel> suppliers;
  SuppliersLoaded(this.suppliers);
  @override
  List<Object?> get props => [suppliers];
}

class SupplierOperationSuccess extends SupplierState {
  final String message;
  SupplierOperationSuccess(this.message);
  @override
  List<Object?> get props => [message];
}

class SupplierError extends SupplierState {
  final String message;
  SupplierError(this.message);
  @override
  List<Object?> get props => [message];
}

// Bloc
class SupplierBloc extends Bloc<SupplierEvent, SupplierState> {
  final SupplierRepository _repository;

  SupplierBloc(this._repository) : super(SupplierInitial()) {
    on<LoadSuppliers>(_onLoadSuppliers);
    on<SearchSuppliers>(_onSearchSuppliers);
    on<AddSupplier>(_onAddSupplier);
    on<UpdateSupplier>(_onUpdateSupplier);
    on<DeleteSupplier>(_onDeleteSupplier);
  }

  Future<void> _onLoadSuppliers(
      LoadSuppliers event, Emitter<SupplierState> emit) async {
    emit(SupplierLoading());
    try {
      final suppliers = await _repository.getAllSuppliers();
      emit(SuppliersLoaded(suppliers));
    } catch (e) {
      emit(SupplierError(e.toString()));
    }
  }

  Future<void> _onSearchSuppliers(
      SearchSuppliers event, Emitter<SupplierState> emit) async {
    emit(SupplierLoading());
    try {
      final suppliers = await _repository.searchSuppliers(event.query);
      emit(SuppliersLoaded(suppliers));
    } catch (e) {
      emit(SupplierError(e.toString()));
    }
  }

  Future<void> _onAddSupplier(
      AddSupplier event, Emitter<SupplierState> emit) async {
    try {
      await _repository.saveSupplier(event.supplier);
      emit(SupplierOperationSuccess('Supplier added successfully'));
      add(LoadSuppliers());
    } catch (e) {
      emit(SupplierError(e.toString()));
    }
  }

  Future<void> _onUpdateSupplier(
      UpdateSupplier event, Emitter<SupplierState> emit) async {
    try {
      await _repository.saveSupplier(event.supplier);
      emit(SupplierOperationSuccess('Supplier updated successfully'));
      add(LoadSuppliers());
    } catch (e) {
      emit(SupplierError(e.toString()));
    }
  }

  Future<void> _onDeleteSupplier(
      DeleteSupplier event, Emitter<SupplierState> emit) async {
    try {
      await _repository.deleteSupplier(event.id);
      emit(SupplierOperationSuccess('Supplier deleted successfully'));
      add(LoadSuppliers());
    } catch (e) {
      emit(SupplierError(e.toString()));
    }
  }
}
