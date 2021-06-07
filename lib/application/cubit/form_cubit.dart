import 'package:bloc/bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'form_state.dart';
part 'form_cubit.freezed.dart';

class FormCubit extends Cubit<FormState> {
  FormCubit() : super(FormState.initial());

  void switchToINR() {
    emit(state.copyWith(isINR: true));
  }

  void switchToUSD() {
    emit(state.copyWith(isINR: false));
  }

  void activateTotalInvestment() {
    emit(state.copyWith(isBaseAmountActivated: false));
  }

  void activateBaseAmount() {
    emit(state.copyWith(isBaseAmountActivated: true));
  }

  void updateChainSize(double value) {
    final size = value.toInt();
    emit(state.copyWith(chainSize: size > 0 ? size : 0, isTouched: true));
  }

  void updateRecoveryRate(double value) {
    final rate = value.toInt();
    emit(state.copyWith(recoveryRate: rate > 0 ? rate : 0, isTouched: true));
  }
}
