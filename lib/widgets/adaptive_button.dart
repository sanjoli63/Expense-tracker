import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

class AdaptiveFlatButton extends StatelessWidget {
  final Icon icon;
  final Function handler;

  AdaptiveFlatButton(this.icon, this.handler);

  @override
  Widget build(BuildContext context) {
    return Platform.isWindows
        ? CupertinoButton(
            child: icon,
            onPressed: handler,
          )
        : TextButton(
            child: icon,
            onPressed: handler,
          );
  }
}
