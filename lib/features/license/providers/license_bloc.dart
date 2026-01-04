import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:inventory_system/features/license/services/license_service.dart';

// Events
abstract class LicenseEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class CheckLicenseStatus extends LicenseEvent {}

class ActivateTrial extends LicenseEvent {}

class ActivateLicense extends LicenseEvent {
  final String key;
  ActivateLicense(this.key);
  @override
  List<Object?> get props => [key];
}

// States
abstract class LicenseState extends Equatable {
  @override
  List<Object?> get props => [];
}

class LicenseInitial extends LicenseState {}

class LicenseLoading extends LicenseState {}

class LicenseValid extends LicenseState {
  final bool isTrial;
  LicenseValid({required this.isTrial});
  @override
  List<Object?> get props => [isTrial];
}

class LicenseInvalid extends LicenseState {}

class LicenseError extends LicenseState {
  final String message;
  LicenseError(this.message);
  @override
  List<Object?> get props => [message];
}

// Bloc
class LicenseBloc extends Bloc<LicenseEvent, LicenseState> {
  LicenseBloc() : super(LicenseInitial()) {
    on<CheckLicenseStatus>(_onCheckStatus);
    on<ActivateTrial>(_onActivateTrial);
    on<ActivateLicense>(_onActivateLicense);
  }

  Future<void> _onCheckStatus(
      CheckLicenseStatus event, Emitter<LicenseState> emit) async {
    emit(LicenseLoading());
    try {
      final isValid = await LicenseService.isLicenseValid();
      if (isValid) {
        final license = await LicenseService.getLicense();
        emit(LicenseValid(isTrial: license?.isTrial ?? false));
      } else {
        emit(LicenseInvalid());
      }
    } catch (e) {
      emit(LicenseError(e.toString()));
    }
  }

  Future<void> _onActivateTrial(
      ActivateTrial event, Emitter<LicenseState> emit) async {
    emit(LicenseLoading());
    try {
      await LicenseService.activateTrial();
      emit(LicenseValid(isTrial: true));
    } catch (e) {
      emit(LicenseError(e.toString()));
    }
  }

  Future<void> _onActivateLicense(
      ActivateLicense event, Emitter<LicenseState> emit) async {
    emit(LicenseLoading());
    try {
      final success = await LicenseService.activateLicense(event.key);
      if (success) {
        emit(LicenseValid(isTrial: false));
      } else {
        emit(LicenseError('Invalid license key'));
      }
    } catch (e) {
      emit(LicenseError(e.toString()));
    }
  }
}
