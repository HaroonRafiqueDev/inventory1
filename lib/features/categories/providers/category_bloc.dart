import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:inventory_system/core/database/models/category_model.dart';
import 'package:inventory_system/features/categories/repositories/category_repository.dart';

// Events
abstract class CategoryEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class LoadCategories extends CategoryEvent {}

class AddCategory extends CategoryEvent {
  final CategoryModel category;
  AddCategory(this.category);
  @override
  List<Object?> get props => [category];
}

class UpdateCategory extends CategoryEvent {
  final CategoryModel category;
  UpdateCategory(this.category);
  @override
  List<Object?> get props => [category];
}

class DeleteCategory extends CategoryEvent {
  final int id;
  DeleteCategory(this.id);
  @override
  List<Object?> get props => [id];
}

// States
abstract class CategoryState extends Equatable {
  @override
  List<Object?> get props => [];
}

class CategoryInitial extends CategoryState {}

class CategoryLoading extends CategoryState {}

class CategoriesLoaded extends CategoryState {
  final List<CategoryModel> categories;
  CategoriesLoaded(this.categories);
  @override
  List<Object?> get props => [categories];
}

class CategoryOperationSuccess extends CategoryState {
  final String message;
  CategoryOperationSuccess(this.message);
  @override
  List<Object?> get props => [message];
}

class CategoryError extends CategoryState {
  final String message;
  CategoryError(this.message);
  @override
  List<Object?> get props => [message];
}

// Bloc
class CategoryBloc extends Bloc<CategoryEvent, CategoryState> {
  final CategoryRepository _repository;

  CategoryBloc(this._repository) : super(CategoryInitial()) {
    on<LoadCategories>(_onLoadCategories);
    on<AddCategory>(_onAddCategory);
    on<UpdateCategory>(_onUpdateCategory);
    on<DeleteCategory>(_onDeleteCategory);
  }

  Future<void> _onLoadCategories(
      LoadCategories event, Emitter<CategoryState> emit) async {
    emit(CategoryLoading());
    try {
      final categories = await _repository.getAllCategories();
      emit(CategoriesLoaded(categories));
    } catch (e) {
      emit(CategoryError(e.toString()));
    }
  }

  Future<void> _onAddCategory(
      AddCategory event, Emitter<CategoryState> emit) async {
    try {
      await _repository.saveCategory(event.category);
      emit(CategoryOperationSuccess('Category added successfully'));
      add(LoadCategories());
    } catch (e) {
      emit(CategoryError(e.toString()));
    }
  }

  Future<void> _onUpdateCategory(
      UpdateCategory event, Emitter<CategoryState> emit) async {
    try {
      await _repository.saveCategory(event.category);
      emit(CategoryOperationSuccess('Category updated successfully'));
      add(LoadCategories());
    } catch (e) {
      emit(CategoryError(e.toString()));
    }
  }

  Future<void> _onDeleteCategory(
      DeleteCategory event, Emitter<CategoryState> emit) async {
    try {
      final success = await _repository.deleteCategory(event.id);
      if (success) {
        emit(CategoryOperationSuccess('Category deleted successfully'));
        add(LoadCategories());
      } else {
        emit(CategoryError('Cannot delete category with existing products'));
      }
    } catch (e) {
      emit(CategoryError(e.toString()));
    }
  }
}
