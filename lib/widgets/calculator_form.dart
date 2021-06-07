import 'package:bommc/application/cubit/form_cubit.dart' as cubit;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CalculatorForm extends StatelessWidget {
  buildInputField(BuildContext context, String label,
      {bool digitOnly = false, bool disabled = false, void Function()? onTap}) {
    return TextFormField(
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
          labelStyle: TextStyle(fontSize: 14)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<cubit.FormCubit, cubit.FormState>(
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
          children: [
            Expanded(
              flex: 2,
              child: buildInputField(
                context,
                'Total Investment',
                digitOnly: formState.isINR,
                disabled: formState.isBaseAmountActivated,
              ),
            ),
            SizedBox(
              width: 20,
            ),
            Expanded(
                flex: 1,
                child: buildInputField(context, 'Chain Size', digitOnly: true)),
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
          children: [
            Expanded(
                flex: 2,
                child: buildInputField(
                  context,
                  'Base Amount',
                  digitOnly: formState.isINR,
                  disabled: formState.isTotalInvestementActivated,
                )),
            SizedBox(
              width: 20,
            ),
            Expanded(
                flex: 1,
                child: buildInputField(context, 'Recovery Rate %',
                    digitOnly: true)),
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
          onPressed: () {},
          style: ElevatedButton.styleFrom(elevation: 0),
          child: Text("Calculate"),
        )
      ],
    ));
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
}
