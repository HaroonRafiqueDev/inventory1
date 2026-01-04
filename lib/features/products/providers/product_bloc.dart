import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:inventory_system/core/database/models/product_model.dart';
import 'package:inventory_system/features/products/repositories/product_repository.dart';

// Events
abstract class ProductEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class LoadProducts extends ProductEvent {}

class SearchProducts extends ProductEvent {
  final String query;
  SearchProducts(this.query);
  @override
  List<Object?> get props => [query];
}

class AddProduct extends ProductEvent {
  final ProductModel product;
  AddProduct(this.product);
  @override
  List<Object?> get props => [product];
}

class UpdateProduct extends ProductEvent {
  final ProductModel product;
  UpdateProduct(this.product);
  @override
  List<Object?> get props => [product];
}

class DeleteProduct extends ProductEvent {
  final int id;
  DeleteProduct(this.id);
  @override
  List<Object?> get props => [id];
}

// States
abstract class ProductState extends Equatable {
  @override
  List<Object?> get props => [];
}

class ProductInitial extends ProductState {}

class ProductLoading extends ProductState {}

class ProductsLoaded extends ProductState {
  final List<ProductModel> products;
  ProductsLoaded(this.products);
  @override
  List<Object?> get props => [products];
}

class ProductOperationSuccess extends ProductState {
  final String message;
  ProductOperationSuccess(this.message);
  @override
  List<Object?> get props => [message];
}

class ProductError extends ProductState {
  final String message;
  ProductError(this.message);
  @override
  List<Object?> get props => [message];
}

// Bloc
class ProductBloc extends Bloc<ProductEvent, ProductState> {
  final ProductRepository _repository;

  ProductBloc(this._repository) : super(ProductInitial()) {
    on<LoadProducts>(_onLoadProducts);
    on<SearchProducts>(_onSearchProducts);
    on<AddProduct>(_onAddProduct);
    on<UpdateProduct>(_onUpdateProduct);
    on<DeleteProduct>(_onDeleteProduct);
  }

  Future<void> _onLoadProducts(
      LoadProducts event, Emitter<ProductState> emit) async {
    emit(ProductLoading());
    try {
      final products = await _repository.getAllProducts();
      emit(ProductsLoaded(products));
    } catch (e) {
      emit(ProductError(e.toString()));
    }
  }

  Future<void> _onSearchProducts(
      SearchProducts event, Emitter<ProductState> emit) async {
    emit(ProductLoading());
    try {
      final products = await _repository.searchProducts(event.query);
      emit(ProductsLoaded(products));
    } catch (e) {
      emit(ProductError(e.toString()));
    }
  }

  Future<void> _onAddProduct(
      AddProduct event, Emitter<ProductState> emit) async {
    try {
      await _repository.saveProduct(event.product);
      emit(ProductOperationSuccess('Product added successfully'));
      add(LoadProducts());
    } catch (e) {
      emit(ProductError(e.toString()));
    }
  }

  Future<void> _onUpdateProduct(
      UpdateProduct event, Emitter<ProductState> emit) async {
    try {
      await _repository.saveProduct(event.product);
      emit(ProductOperationSuccess('Product updated successfully'));
      add(LoadProducts());
    } catch (e) {
      emit(ProductError(e.toString()));
    }
  }

  Future<void> _onDeleteProduct(
      DeleteProduct event, Emitter<ProductState> emit) async {
    try {
      await _repository.deleteProduct(event.id);
      emit(ProductOperationSuccess('Product deleted successfully'));
      add(LoadProducts());
    } catch (e) {
      emit(ProductError(e.toString()));
    }
  }
}
