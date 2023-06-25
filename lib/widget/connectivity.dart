import 'dart:async';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';

Widget snack(String text, bool show) {
  if (show == true) {
    return Container(
      height: 50,
      padding: const EdgeInsets.all(10.00),
      color: Colors.black87,
      child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
        Container(
          margin: const EdgeInsets.only(right: 10.00),
          child: const Icon(Icons.wifi_off, color: Colors.white),
        ),
        Text(text, style: const TextStyle(color: Colors.white)),
      ]),
    );
  } else {
    return const SizedBox();
  }
}
