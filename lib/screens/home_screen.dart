import 'package:bommc/widgets/calculator_form.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget {
  buildAmountChip(BuildContext context, String amount, int position) {
    return Container(
        padding: EdgeInsets.symmetric(vertical: 8, horizontal: 10),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(6),
            border:
                Border.all(color: Theme.of(context).primaryColor, width: 1)),
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
                color: Theme.of(context).primaryColor,
              ),
            ),
            SizedBox(
              width: 10,
            ),
            Text(
              "\$ $amount",
              style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: Theme.of(context).primaryColor),
            ),
          ],
        ));
  }

  @override
  Widget build(BuildContext context) {
    const chainAmounts = [
      73,
      87,
      191,
      418,
      916,
      87,
      191,
      418,
      916,
      1050,
      // 191,
      // 418,
      // 916,
      // 87,
      // 191,
      // 418,
      // 916,
      // 87,
      // 191,
      // 418,
      // 916,
      // 87,
      // 191,
      // 418,
      // 916,
      // 87,
      // 191,
      // 418,
      // 916,
      // 87,
      // 191,
      // 418,
      // 916,
      // 87,
      // 191,
      // 418,
      // 916,
      // 87,
      // 191,
      // 418,
      // 916,
      // 87,
      // 191,
      // 418,
      // 916,
    ];
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "BOMMC",
          style: TextStyle(
            color: Colors.black,
          ),
        ),
      ),
      body: Stack(
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
                  Wrap(
                    runSpacing: 16,
                    spacing: 16,
                    children: [
                      for (int index = 0; index < chainAmounts.length; index++)
                        buildAmountChip(
                            context, chainAmounts[index].toString(), index + 1)
                    ],
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
              child: Column(
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
                        "3",
                        style: TextStyle(
                            fontWeight: FontWeight.bold, color: Colors.green),
                      )
                    ],
                  ),
                  SizedBox(height: 10),
                  Text(
                    "\$ 23425.45",
                    style: TextStyle(fontSize: 26),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
