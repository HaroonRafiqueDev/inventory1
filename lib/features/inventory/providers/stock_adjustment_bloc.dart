import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:inventory_system/core/database/models/stock_adjustment_model.dart';
import 'package:inventory_system/features/inventory/repositories/stock_adjustment_repository.dart';

// Events
abstract class StockAdjustmentEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class LoadAdjustments extends StockAdjustmentEvent {}

class CreateAdjustment extends StockAdjustmentEvent {
  final StockAdjustmentModel adjustment;
  CreateAdjustment(this.adjustment);
  @override
  List<Object?> get props => [adjustment];
}

// States
abstract class StockAdjustmentState extends Equatable {
  @override
  List<Object?> get props => [];
}

class StockAdjustmentInitial extends StockAdjustmentState {}

class StockAdjustmentLoading extends StockAdjustmentState {}

class StockAdjustmentsLoaded extends StockAdjustmentState {
  final List<StockAdjustmentModel> adjustments;
  StockAdjustmentsLoaded(this.adjustments);
  @override
  List<Object?> get props => [adjustments];
}

class StockAdjustmentOperationSuccess extends StockAdjustmentState {
  final String message;
  StockAdjustmentOperationSuccess(this.message);
  @override
  List<Object?> get props => [message];
}

class StockAdjustmentError extends StockAdjustmentState {
  final String message;
  StockAdjustmentError(this.message);
  @override
  List<Object?> get props => [message];
}

// Bloc
class StockAdjustmentBloc
    extends Bloc<StockAdjustmentEvent, StockAdjustmentState> {
  final StockAdjustmentRepository _repository;

  StockAdjustmentBloc(this._repository) : super(StockAdjustmentInitial()) {
    on<LoadAdjustments>(_onLoadAdjustments);
    on<CreateAdjustment>(_onCreateAdjustment);
  }

  Future<void> _onLoadAdjustments(
      LoadAdjustments event, Emitter<StockAdjustmentState> emit) async {
    emit(StockAdjustmentLoading());
    try {
      final adjustments = await _repository.getAllAdjustments();
      emit(StockAdjustmentsLoaded(adjustments));
    } catch (e) {
      emit(StockAdjustmentError(e.toString()));
    }
  }

  Future<void> _onCreateAdjustment(
      CreateAdjustment event, Emitter<StockAdjustmentState> emit) async {
    emit(StockAdjustmentLoading());
    try {
      await _repository.createAdjustment(event.adjustment);
      emit(StockAdjustmentOperationSuccess('Stock adjusted successfully'));
      add(LoadAdjustments());
    } catch (e) {
      emit(StockAdjustmentError(e.toString()));
    }
  }
}
