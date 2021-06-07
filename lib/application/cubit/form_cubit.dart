import 'package:bloc/bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'form_state.dart';
part 'form_cubit.freezed.dart';

class FormCubit extends Cubit<FormState> {
  FormCubit() : super(FormState.initial());

  void switchToINR() {
    _emit(state.copyWith(isINR: true));
    _resetAmounts();
  }

  void switchToUSD() {
    _emit(state.copyWith(isINR: false));
    _resetAmounts();
  }

  void activateTotalInvestment() {
    _emit(state.copyWith(isBaseAmountActivated: false));
    _resetAmounts();
  }

  void activateBaseAmount() {
    _emit(state.copyWith(isBaseAmountActivated: true));
    _resetAmounts();
  }

  void updateChainSize(double value) {
    final size = value.toInt();
    _emit(state.copyWith(chainSize: size > 0 ? size : 0, isTouched: true));
  }

  void updateRecoveryRate(double value) {
    final rate = value.toInt();
    _emit(state.copyWith(recoveryRate: rate > 0 ? rate : 0, isTouched: true));
  }

  void updateBaseAmount(double value) {
    if (state.isBaseAmountActivated) {
      double amount = value > 0 ? value : 0;
      _emit(state.copyWith(baseAmount: amount, isTouched: true));
    }
  }

  void updateTotalInvestment(double value) {
    if (state.isTotalInvestementActivated) {
      double amount = value > 0 ? value : 0;
      _emit(state.copyWith(totalInvestment: amount, isTouched: true));
    }
  }

  void _resetAmounts() {
    _emit(state.copyWith(baseAmount: 0, totalInvestment: 0));
  }

  void _emit(FormState newState) {
    emit(newState.copyWith(validated: isFormValidated(newState)));
  }

  bool isFormValidated(FormState currentState) {
    if (currentState.chainSize <= 0 || currentState.recoveryRate <= 0) {
      return false;
    }
    if (currentState.isTotalInvestementActivated &&
        currentState.totalInvestment <= 0) {
      return false;
    }
    if (currentState.isBaseAmountActivated && currentState.baseAmount <= 0) {
      return false;
    }
    return true;
  }
}
