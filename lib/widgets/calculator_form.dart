import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

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
    return Form(
        child: Column(
      children: [
        Row(
          children: [
            Expanded(
                flex: 2, child: buildInputField(context, 'Total Investment')),
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
            Expanded(flex: 2, child: buildInputField(context, 'Base Amount')),
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
            Text("INR"),
            Switch(value: false, onChanged: (newValue) {}),
            Text("USD"),
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
}
