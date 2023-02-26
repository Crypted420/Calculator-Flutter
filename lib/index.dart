import 'dart:developer';
import 'package:math_expressions/math_expressions.dart';
import 'package:flutter/material.dart';

class Calculator extends StatefulWidget {
  const Calculator({super.key});
  @override
  State<Calculator> createState() => _CalulatorState();
}

class _CalulatorState extends State<Calculator> {
  @override
  Widget build(BuildContext context) {
    final containerHeight = MediaQuery.of(context).size.height;
    final containerWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      body: Column(
        children: [
          Container(
              height: containerHeight / 2.5,
              color: Colors.white,
              child: resultDisplay(containerWidth, containerHeight)),
          Expanded(child: keyPads(containerWidth, containerHeight))
        ],
      ),
    );
  }

  final keyPadsValue = [
    ['C', '^', '%', '÷'],
    ['7', '8', '9', 'x'],
    ['4', '5', '6', '-'],
    ['1', '2', '3', '+'],
    ['R', '0', '.', '=']
  ];

  FractionallySizedBox keyPads(double containerWidth, double containerHeight) {
    return FractionallySizedBox(
      widthFactor: 1,
      heightFactor: 1,
      child: Container(
        width: double.infinity,
        height: double.infinity,
        padding: const EdgeInsets.only(top: 20, bottom: 20),
        decoration: const BoxDecoration(
          color: Color.fromRGBO(249, 249, 249, 1),
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(40), topRight: Radius.circular(40)),
        ),
        child: Column(children: [
          keyPadsContainer(0, keyPadsValue[0], containerWidth),
          keyPadsContainer(1, keyPadsValue[1], containerWidth),
          keyPadsContainer(2, keyPadsValue[2], containerWidth),
          keyPadsContainer(3, keyPadsValue[3], containerWidth),
          keyPadsContainer(4, keyPadsValue[4], containerWidth),
        ]),
      ),
    );
  }

  String inputs = '';
  String expression =
      ''; //same as inputs but evaluating * & x are different for math_expression
  String previousCal = '';
  evaluateExpression() {
    try {
      Parser p = Parser();
      Expression exp = p.parse(expression);
      ContextModel cm = ContextModel();
      double result = exp.evaluate(EvaluationType.REAL, cm);
      return result;
    } catch (e) {
      return 'syntax error';
    }
  }

  handleChangeState(index, keys) {
    if (keys[index] == 'C') {
      inputs = inputs.isNotEmpty ? inputs.substring(0, inputs.length - 1) : '';
      expression =
          expression.isNotEmpty ? inputs.substring(0, inputs.length - 1) : '';
    } else if (keys[index] == 'R') {
      inputs = '';
      expression = '';
      previousCal = '';
    } else if (inputs.length > 20) {
      inputs = inputs;
    } else if (keys[index] == '+' ||
        keys[index] == '-' ||
        keys[index] == '÷' ||
        keys[index] == '^' ||
        keys[index] == 'x' ||
        keys[index] == '%') {
      inputs += ' ${keys[index]} ';
      expression += '${keys[index] == 'x' ? '*' : keys[index]}';
    } else if (keys[index] == '=') {
      previousCal = expression;
      inputs = evaluateExpression().toString();
      expression = inputs;
    } else {
      inputs += keys[index];
      expression += keys[index];
    }
  }

  SizedBox resultDisplay(double containerWidth, double containerHeight) {
    return SizedBox(
      width: containerWidth,
      child:
          Column(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
        Center(
          child: Container(
            width: 90,
            height: 45,
            margin: const EdgeInsets.only(top: 50),
            decoration: BoxDecoration(
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.2),
                  spreadRadius: 0.1,
                  blurRadius: 2,
                  offset: const Offset(0, 1),
                )
              ],
              color: Colors.grey[100],
              borderRadius: BorderRadius.circular(15),
            ),
            child: Row(
              children: [
                const Expanded(
                  child: Icon(Icons.light_mode_outlined,
                      color: Colors.black, size: 14),
                ),
                Expanded(
                  child: Icon(
                    Icons.dark_mode_outlined,
                    color: Colors.grey[500],
                    size: 14,
                  ),
                )
              ],
            ),
          ),
        ),

        // Inputs view
        Expanded(
          child: Container(
              alignment: const Alignment(1.0, 1.0),
              padding: const EdgeInsets.only(bottom: 15, right: 15, left: 10),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    previousCal,
                    style: TextStyle(
                      color: Colors.grey,
                      fontFamily: 'OpenSans',
                      fontSize: 25 - (inputs.length / 10).clamp(0, 3) * 5,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                  Text(
                    inputs,
                    style: TextStyle(
                      fontFamily: 'OpenSans',
                      fontSize: 40 - (inputs.length / 10).clamp(0, 3) * 5,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ],
              )),
        )
      ]),
    );
  }

  Expanded keyPadsContainer(final arrIndex, keys, containerWidth) {
    return Expanded(
      child: Wrap(
        // spacing: 10,
        runSpacing: 10,
        children: List.generate(
          keys.length,
          (index) {
            Color textColor = arrIndex == 0
                ? (index != 3
                    ? const Color.fromARGB(179, 76, 175, 79)
                    : Colors.red)
                : (index != 3 ? Colors.black : Colors.red);
            return SizedBox(
              width: containerWidth / 4,
              height: 100,
              child: InkWell(
                onTap: () {
                  setState(() {
                    handleChangeState(index, keys);
                  });
                },
                child: Center(
                  child: Container(
                    height: 70,
                    width: 70,
                    decoration: BoxDecoration(
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.05),
                          spreadRadius: 0.1,
                          blurRadius: 0.5,
                          offset: const Offset(0, 1),
                        )
                      ],
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Center(
                        child: keys[index] == 'C'
                            ? const Icon(Icons.backspace_outlined,
                                size: 25, color: Colors.black)
                            : (keys[index] == 'R'
                                ? const Icon(Icons.refresh_outlined)
                                : Text(
                                    keys[index],
                                    style: TextStyle(
                                      fontFamily: 'OpenSans',
                                      fontSize: 28,
                                      fontWeight: FontWeight.w700,
                                      color: textColor,
                                    ),
                                  ))),
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
