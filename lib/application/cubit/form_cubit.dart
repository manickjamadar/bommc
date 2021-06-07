import 'dart:math';

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
    if (currentState.chainSize <= 1) {
      return false;
    }
    if (currentState.recoveryRate <= 0) {
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

  double _ceilToINR(double amount) {
    return amount.ceil().toDouble();
  }

  double _floorToINR(double amount) {
    return amount.floor().toDouble();
  }

  double _ceilToUSD(double amount) {
    return (amount * 100).ceil() / 100;
  }

  double _floorToUSD(double amount) {
    return (amount * 100).floor() / 100;
  }

  double _ceilAmount(double amount) {
    return state.isINR ? _ceilToINR(amount) : _ceilToUSD(amount);
  }

  double _floorAmount(double amount) {
    return state.isINR ? _floorToINR(amount) : _floorToUSD(amount);
  }

  void selectAmount(int chainSize) {
    if (state.amounts.isEmpty || chainSize < 1) {
      return;
    }
    _emit(state.copyWith(
        selectedChainSize: chainSize,
        selectedTotalAmount: _calculateTotalAmount(state.amounts, chainSize)));
  }

  void calculate() {
    double actualBaseAmount = _ceilAmount(state.baseAmount);
    if (state.isTotalInvestementActivated) {
      double actualTotalInvestment = _ceilAmount(state.totalInvestment);
      actualBaseAmount = _calculateBaseAmount(
          actualTotalInvestment, state.chainSize, state.recoveryRate);
    }
    _emit(state.copyWith(
        amounts: _calculateAmounts(
            actualBaseAmount, state.chainSize, state.recoveryRate)));
    selectAmount(state.chainSize);
  }

  double _calculateBaseAmount(
      double totalInvestment, int chainSize, int recoveryRate) {
    final baseAmount = totalInvestment /
        pow((recoveryRate + 100) / recoveryRate, chainSize - 1);
    return _floorAmount(baseAmount);
  }

  List<double> _calculateAmounts(
      double baseAmount, int chainSize, int recoveryRate) {
    final amounts = [baseAmount];
    double totalAmount = baseAmount;
    for (var i = 2; i <= chainSize; i++) {
      final nextAmount = _ceilAmount(totalAmount * 100 / recoveryRate);
      totalAmount = totalAmount + nextAmount;
      amounts.add(nextAmount);
    }
    return amounts;
  }

  double _calculateTotalAmount(List<double> amounts, int length) {
    double totalAmount = 0;
    for (var i = 0; i < length; i++) {
      totalAmount = amounts[i] + totalAmount;
    }
    return _ceilAmount(totalAmount);
  }
}
