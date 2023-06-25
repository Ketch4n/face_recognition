import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class WillPop extends StatelessWidget {
  const WillPop({super.key});

  @override
  Widget build(BuildContext context) {
    return CupertinoAlertDialog(
      title: const Text(
        "Confirm Exit",
        style: TextStyle(color: Colors.black, fontFamily: "NexaBold"),
      ),
      content: const Text(
        'Are you sure you want to exit ?',
        style: TextStyle(color: Colors.black, fontFamily: "NexaRegular"),
      ),
      actions: <Widget>[
        TextButton(
          child: const Text('No'),
          onPressed: () {
            Navigator.of(context).pop(false);
          },
        ),
        TextButton(
          child: const Text('Yes'),
          onPressed: () {
            Navigator.of(context).pop(true);
          },
        ),
      ],
    );
  }
}
