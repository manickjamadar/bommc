part of 'form_cubit.dart';

@freezed
class FormState with _$FormState {
  const FormState._();
  const factory FormState(
    bool isINR,
    int chainSize,
    int recoveryRate,
    double totalInvestment,
    double baseAmount,
    bool isBaseAmountActivated,
    bool isTouched,
    List<double> amounts,
  ) = _FormState;

  bool get isUSD => !isINR;
  bool get isTotalInvestementActivated => !isBaseAmountActivated;

  static FormState initial() {
    return FormState(true, 0, 0, 0, 0, false, false, []);
  }
}
