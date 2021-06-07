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
}
