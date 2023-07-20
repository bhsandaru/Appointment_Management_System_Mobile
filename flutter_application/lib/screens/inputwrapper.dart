import 'package:flutter/material.dart';

import 'button.dart';
import 'inputfield.dart';

class InputWrapper extends StatelessWidget {
  const InputWrapper({super.key});
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(30),
      child: Column(
        children: <Widget>[
          const SizedBox(
            height: 40,
          ),
          Container(
            decoration: BoxDecoration(
                color: Colors.white, borderRadius: BorderRadius.circular(10)),
            child: const InputField(),
          ),
          const SizedBox(
            height: 40,
          ),
          const Button()
        ],
      ),
    );
  }
}
