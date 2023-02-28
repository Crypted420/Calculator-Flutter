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
      backgroundColor: darkmode ? Colors.black : Colors.white,
      body: Column(
        children: [
          Container(
              height: containerHeight / 2.5,
              color: darkmode ? Colors.black : Colors.white,
              child: resultDisplay(containerWidth, containerHeight)),
          Expanded(child: keyPads(containerWidth, containerHeight))
        ],
      ),
    );
  }

  bool darkmode = true;

  final keyPadsValue = [
    ['C', '^', '%', '÷'],
    ['7', '8', '9', '×'],
    ['4', '5', '6', '−'],
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
        decoration: BoxDecoration(
          color:
              darkmode ? Colors.black : const Color.fromRGBO(249, 249, 249, 1),
          borderRadius: const BorderRadius.only(
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

      bool checkResult = result % 1 == 0 ? true : false;
      if (checkResult) {
        return result.round();
      } else {
        return result;
      }
    } catch (e) {
      log(e.toString());
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
    } else if (inputs.length > 15) {
      inputs = inputs;
    } else if (keys[index] == '+' ||
        keys[index] == '−' ||
        keys[index] == '÷' ||
        keys[index] == '^' ||
        keys[index] == '×' ||
        keys[index] == '%') {
      inputs += '${keys[index]}';
      expression +=
          '${keys[index] == '×' ? '*' : (keys[index] == '÷' ? '/' : (keys[index] == '−' ? '-' : keys[index]))}';
    } else if (keys[index] == '=') {
      if (inputs.isNotEmpty) {
        previousCal = expression;
        inputs = evaluateExpression().toString();
        expression = inputs;
      } else {
        previousCal = '';
        inputs = '';
        expression = '';
      }
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
                  blurRadius: darkmode ? 1 : 2,
                  offset: darkmode ? const Offset(0, 0) : const Offset(0, 2),
                )
              ],
              color: darkmode
                  ? const Color.fromRGBO(0, 0, 0, .5)
                  : Colors.grey[100],
              borderRadius: BorderRadius.circular(15),
            ),
            child: Row(
              children: [
                Expanded(
                  child: InkWell(
                    onTap: () {
                      setState(() {
                        darkmode = !darkmode;
                      });
                    },
                    child: Icon(Icons.light_mode_outlined,
                        color: darkmode ? Colors.grey[800] : Colors.black,
                        size: darkmode ? 14 : 18),
                  ),
                ),
                Expanded(
                  child: InkWell(
                    onTap: () {
                      setState(() {
                        darkmode = true;
                      });
                    },
                    child: Icon(
                      Icons.dark_mode_outlined,
                      color: darkmode ? Colors.grey[300] : Colors.grey[500],
                      size: darkmode ? 18 : 14,
                    ),
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
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Expanded(
                  child: Container(
                    alignment: Alignment.bottomRight,
                    child: Text(
                      previousCal,
                      style: const TextStyle(
                          color: Colors.grey,
                          fontFamily: 'OpenSans',
                          // fontSize: 25 - (inputs.length / 10).clamp(0, 3) * 5,
                          fontSize: 25,
                          fontWeight: FontWeight.w400,
                          textBaseline: TextBaseline.alphabetic),
                    ),
                  ),
                ),
                Expanded(
                  child: Container(
                    alignment: Alignment.bottomRight,
                    child: Text(
                      inputs,
                      style: TextStyle(
                          fontFamily: 'OpenSans',
                          // fontSize: 40 - (inputs.length / 10).clamp(0, 3) * 5,
                          fontSize: inputs.length > 15 ? 40 : 50,
                          fontWeight: FontWeight.w400,
                          color: darkmode ? Colors.white : Colors.black),
                    ),
                  ),
                ),
              ],
            ),
          ),
        )
      ]),
    );
  }

  Expanded keyPadsContainer(final arrIndex, keys, containerWidth) {
    return Expanded(
      child: Wrap(
        runSpacing: 10,
        children: List.generate(
          keys.length,
          (index) {
            Color textColor = arrIndex == 0
                ? (index != 3
                    ? const Color.fromRGBO(0, 192, 0, 1)
                    : const Color.fromRGBO(255, 32, 0, 1))
                : (index != 3
                    ? (darkmode ? Colors.white : Colors.black)
                    : const Color.fromRGBO(255, 32, 0, 1));
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
                                size: 35, color: Color.fromRGBO(0, 192, 0, 1))
                            : (keys[index] == 'R'
                                ? Icon(
                                    Icons.refresh_outlined,
                                    color:
                                        darkmode ? Colors.white : Colors.black,
                                  )
                                : Text(
                                    keys[index],
                                    style: TextStyle(
                                      fontFamily: 'OpenSans',
                                      fontSize: 35,
                                      fontWeight: FontWeight.w400,
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
