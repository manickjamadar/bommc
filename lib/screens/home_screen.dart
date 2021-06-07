import 'package:bommc/application/cubit/form_cubit.dart' as cubit;
import 'package:bommc/helpers/currency_symbol.dart';
import 'package:bommc/widgets/calculator_form.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class HomeScreen extends StatelessWidget {
  buildAmountChip(BuildContext context, String amount, int position,
      String currencySymbol) {
    return InkWell(onTap: () {
      BlocProvider.of<cubit.FormCubit>(context).selectAmount(position);
    }, child: BlocBuilder<cubit.FormCubit, cubit.FormState>(
      builder: (context, state) {
        final activeColor = Theme.of(context).primaryColor;
        final disabledColor = Colors.grey;
        final isEnabled = position <= state.selectedChainSize;
        final chipColor = isEnabled ? activeColor : disabledColor;
        return Container(
            padding: EdgeInsets.symmetric(vertical: 8, horizontal: 10),
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(6),
                border: Border.all(color: chipColor, width: 1)),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  child: Center(
                      child: Text(
                    position.toString(),
                    style: TextStyle(color: Colors.white),
                  )),
                  padding: EdgeInsets.symmetric(vertical: 4, horizontal: 8),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(3),
                    color: chipColor,
                  ),
                ),
                SizedBox(
                  width: 10,
                ),
                Text(
                  "$currencySymbol $amount",
                  style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      color: chipColor),
                ),
              ],
            ));
      },
    ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "BOMMC",
          style: TextStyle(
            color: Colors.black,
          ),
        ),
      ),
      body: GestureDetector(
        onTap: () {
          FocusScope.of(context).unfocus();
        },
        child: Stack(
          children: [
            SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CalculatorForm(),
                    SizedBox(
                      height: 16,
                    ),
                    Text("Chain Amounts"),
                    SizedBox(
                      height: 16,
                    ),
                    BlocBuilder<cubit.FormCubit, cubit.FormState>(
                      builder: (context, state) {
                        return state.amounts.isEmpty
                            ? Center(
                                child: Text(
                                "No Amounts Available",
                                style: TextStyle(color: Colors.grey),
                              ))
                            : Wrap(
                                runSpacing: 16,
                                spacing: 16,
                                children: [
                                  for (int index = 0;
                                      index < state.amounts.length;
                                      index++)
                                    buildAmountChip(
                                        context,
                                        state.isINR
                                            ? state.amounts[index]
                                                .ceil()
                                                .toString()
                                            : state.amounts[index].toString(),
                                        index + 1,
                                        state.isINR
                                            ? CurrencySymbol.INR
                                            : CurrencySymbol.USD)
                                ],
                              );
                      },
                    ),
                    SizedBox(
                      height: 130,
                    ),
                  ],
                ),
              ),
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: Container(
                margin: EdgeInsets.only(bottom: 26),
                padding: EdgeInsets.symmetric(vertical: 20, horizontal: 40),
                // width: double.infinity,
                decoration: BoxDecoration(
                    color: Colors.white,
                    // border: Border.all(),
                    borderRadius: BorderRadius.circular(6),
                    boxShadow: [
                      BoxShadow(
                          blurRadius: 10,
                          spreadRadius: 10,
                          color: Colors.grey.withOpacity(0.1)),
                    ]),
                child: BlocBuilder<cubit.FormCubit, cubit.FormState>(
                  builder: (context, state) {
                    return Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              "Selected Chain Size : ",
                              style: TextStyle(
                                  fontWeight: FontWeight.w600,
                                  fontStyle: FontStyle.italic),
                            ),
                            Text(
                              state.selectedChainSize.toString(),
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.green),
                            )
                          ],
                        ),
                        SizedBox(height: 10),
                        Text(
                          "${state.isINR ? CurrencySymbol.INR : CurrencySymbol.USD} ${state.isINR ? state.selectedTotalAmount.ceil() : state.selectedTotalAmount}",
                          style: TextStyle(fontSize: 26),
                        ),
                      ],
                    );
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
