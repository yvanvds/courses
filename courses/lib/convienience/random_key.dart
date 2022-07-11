import 'dart:math';

import 'package:flutter/material.dart';

class RandomValues {
  static Random random = Random();

  static Key getKey() {
    return Key(getString(20));
  }

  static String getString(int length) {
    return String.fromCharCodes(
        List.generate(length, (index) => random.nextInt(33) + 89));
  }
}
