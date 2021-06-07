import 'package:bommc/application/cubit/form_cubit.dart' as cubit;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CalculatorForm extends StatefulWidget {
  @override
  _CalculatorFormState createState() => _CalculatorFormState();
}

class _CalculatorFormState extends State<CalculatorForm> {
  late TextEditingController _baseAmountController;
  late TextEditingController _totalInvestmentController;
  late FocusNode _baseAmountFocusNode;
  late FocusNode _totalInvestmentFocusNode;
  @override
  initState() {
    super.initState();
    _baseAmountController = new TextEditingController();
    _totalInvestmentController = new TextEditingController();
    _baseAmountFocusNode = new FocusNode();
    _totalInvestmentFocusNode = new FocusNode();
  }

  @override
  dispose() {
    _baseAmountController.dispose();
    _totalInvestmentController.dispose();
    _baseAmountFocusNode.dispose();
    _totalInvestmentFocusNode.dispose();
    super.dispose();
  }

  buildInputField(BuildContext context, String label,
      {bool digitOnly = false,
      bool disabled = false,
      void Function()? onTap,
      void Function(String)? onChanged,
      TextEditingController? controller,
      FocusNode? focusNode,
      String? errorText}) {
    return TextFormField(
      focusNode: focusNode,
      controller: controller,
      onChanged: onChanged,
      onTap: onTap,
      enabled: !disabled,
      keyboardType: TextInputType.number,
      inputFormatters: [
        digitOnly
            ? FilteringTextInputFormatter.digitsOnly
            : FilteringTextInputFormatter.allow(RegExp(r'^(\d+)?\.?\d{0,2}')),
      ],
      decoration: InputDecoration(
          contentPadding: EdgeInsets.all(10),
          border: OutlineInputBorder(),
          labelText: label,
          labelStyle: TextStyle(fontSize: 14),
          errorText: errorText),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<cubit.FormCubit, cubit.FormState>(
      buildWhen: (previousState, currentState) {
        if (previousState.isINR == currentState.isUSD ||
            previousState.isBaseAmountActivated ==
                currentState.isTotalInvestementActivated) {
          print(previousState);
          resetAmountInputs();
        }
        if (currentState.isBaseAmountActivated) {
          _baseAmountFocusNode.requestFocus();
        }
        if (currentState.isTotalInvestementActivated) {
          _baseAmountFocusNode.requestFocus();
        }
        return true;
      },
      builder: (context, state) {
        return buildForm(context, state);
      },
    );
  }

  Widget buildForm(BuildContext context, cubit.FormState formState) {
    return Form(
        child: Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Expanded(
              flex: 2,
              child: buildInputField(
                context,
                'Total Investment',
                controller: _totalInvestmentController,
                focusNode: _totalInvestmentFocusNode,
                digitOnly: formState.isINR,
                disabled: formState.isBaseAmountActivated,
                errorText: getErrorText(
                    formState.totalInvestment, formState.isTouched),
                onChanged: (newValue) =>
                    onTotalInvestmentChanged(context, newValue),
              ),
            ),
            SizedBox(
              width: 20,
            ),
            Expanded(
                flex: 1,
                child: buildInputField(
                  context,
                  'Chain Size',
                  digitOnly: true,
                  errorText: getErrorText(
                      formState.chainSize.toDouble(), formState.isTouched),
                  onChanged: (newValue) =>
                      onChainSizeChanged(context, newValue),
                )),
          ],
        ),
        Row(
          children: [
            Text("Switch "),
            Switch(
                value: formState.isBaseAmountActivated,
                onChanged: (newValue) =>
                    onCalculationTypeSwitch(context, newValue))
          ],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Expanded(
                flex: 2,
                child: buildInputField(
                  context,
                  'Base Amount',
                  controller: _baseAmountController,
                  focusNode: _baseAmountFocusNode,
                  digitOnly: formState.isINR,
                  disabled: formState.isTotalInvestementActivated,
                  errorText:
                      getErrorText(formState.baseAmount, formState.isTouched),
                  onChanged: (newValue) =>
                      onBaseAmountChanged(context, newValue),
                )),
            SizedBox(
              width: 20,
            ),
            Expanded(
                flex: 1,
                child: buildInputField(
                  context,
                  'Recovery Rate %',
                  digitOnly: true,
                  errorText: getErrorText(
                      formState.recoveryRate.toDouble(), formState.isTouched),
                  onChanged: (newValue) =>
                      onRecoveryRateChanged(context, newValue),
                )),
          ],
        ),
        Row(
          children: [
            Text("USD"),
            Switch(
                value: formState.isINR,
                onChanged: (newValue) => onCurrencySwitch(context, newValue)),
            Text("INR"),
          ],
        ),
        ElevatedButton(
          onPressed: formState.validated ? () => onCalculate(context) : null,
          style: ElevatedButton.styleFrom(elevation: 0),
          child: Text("Calculate"),
        )
      ],
    ));
  }

  void resetAmountInputs() {
    _baseAmountController.clear();
    _totalInvestmentController.clear();
  }

  void onChainSizeChanged(BuildContext context, String value) {
    final size = double.tryParse(value);
    BlocProvider.of<cubit.FormCubit>(context)
        .updateChainSize(size == null ? 0 : size);
  }

  void onRecoveryRateChanged(BuildContext context, String value) {
    final rate = double.tryParse(value);
    BlocProvider.of<cubit.FormCubit>(context)
        .updateRecoveryRate(rate == null ? 0 : rate);
  }

  void onBaseAmountChanged(BuildContext context, String value) {
    final amount = double.tryParse(value);
    BlocProvider.of<cubit.FormCubit>(context)
        .updateBaseAmount(amount == null ? 0 : amount);
  }

  void onTotalInvestmentChanged(BuildContext context, String value) {
    final amount = double.tryParse(value);
    BlocProvider.of<cubit.FormCubit>(context)
        .updateTotalInvestment(amount == null ? 0 : amount);
  }

  void onCurrencySwitch(BuildContext context, bool isINR) {
    if (isINR) {
      BlocProvider.of<cubit.FormCubit>(context).switchToINR();
    } else {
      BlocProvider.of<cubit.FormCubit>(context).switchToUSD();
    }
  }

  void onCalculationTypeSwitch(
      BuildContext context, bool isBaseAmountActivated) {
    if (isBaseAmountActivated) {
      BlocProvider.of<cubit.FormCubit>(context).activateBaseAmount();
    } else {
      BlocProvider.of<cubit.FormCubit>(context).activateTotalInvestment();
    }
  }

  void unFocuskeyboard(BuildContext context) {
    FocusScope.of(context).unfocus();
  }

  void onCalculate(BuildContext context) {
    unFocuskeyboard(context);
    print("calculated");
  }

  String? getErrorText(double value, bool isTouched) {
    return value <= 0 && isTouched ? "Required" : null;
  }
}
