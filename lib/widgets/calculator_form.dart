import 'package:bommc/application/cubit/form_cubit.dart' as cubit;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CalculatorForm extends StatelessWidget {
  buildInputField(BuildContext context, String label,
      {bool digitOnly = false}) {
    return TextFormField(
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
                child: buildInputField(context, 'Total Investment',
                    digitOnly: formState.isINR)),
            SizedBox(
              width: 20,
            ),
            Expanded(
                flex: 1,
                child: buildInputField(context, 'Chain Size', digitOnly: true)),
          ],
        ),
        SizedBox(height: 20),
        Row(
          children: [
            Expanded(
                flex: 2,
                child: buildInputField(context, 'Base Amount',
                    digitOnly: formState.isINR)),
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
}
