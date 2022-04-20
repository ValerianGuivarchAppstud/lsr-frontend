import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

StatRow({required String statName, required String statValue, required Function() statOnPressed}) {
  return ElevatedButton.icon(
      icon: Image.asset(
        "assets/images/icons/$statName.png",
        fit: BoxFit.contain,
        height: 20,
        width: 20,
      ),
      onPressed: () {
        statOnPressed();
      },
      label:  Text(" $statName : $statValue"),
  );
}
