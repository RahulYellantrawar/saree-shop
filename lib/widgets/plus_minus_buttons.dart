import 'package:flutter/material.dart';

class PlusMinusButtons extends StatelessWidget {
  final Function addQuantity;
  final Function deleteQuantity;
  final String text;

  PlusMinusButtons({
    required this.addQuantity,
    required this.deleteQuantity,
    required this.text,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 120,
      decoration: const BoxDecoration(),
      child: Row(
        children: [
          Expanded(
            child: InkWell(
              onTap: deleteQuantity as void Function()?,
              child: Container(
                height: 30,
                decoration: const BoxDecoration(
                  color: Colors.white,
                  boxShadow: [
                    BoxShadow(
                      blurRadius: 1,
                    ),
                  ],
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(5),
                    bottomLeft: Radius.circular(5),
                  ),
                ),
                child: const Center(
                  child: Text(
                    '-',
                    style: TextStyle(
                      fontSize: 24,
                    ),
                  ),
                ),
              ),
            ),
          ),
          Expanded(
            child: Container(
              height: 30,
              decoration: const BoxDecoration(
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    blurRadius: 1,
                  ),
                ],
              ),
              child: Center(
                child: Text(text),
              ),
            ),
          ),
          Expanded(
            child: InkWell(
              onTap: addQuantity as void Function()?,
              child: Container(
                height: 30,
                decoration: const BoxDecoration(
                  color: Colors.white,
                  boxShadow: [
                    BoxShadow(
                      blurRadius: 1,
                    ),
                  ],
                  borderRadius: BorderRadius.only(
                    topRight: Radius.circular(5),
                    bottomRight: Radius.circular(5),
                  ),
                ),
                child: const Center(
                  child: Text(
                    '+',
                    style: TextStyle(
                      fontSize: 24,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
