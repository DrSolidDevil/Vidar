import "package:flutter/material.dart";

void clearNavigatorAndPush(
  final BuildContext currentContext,
  final Widget child,
) {
  Navigator.pushAndRemoveUntil(
    currentContext,
    MaterialPageRoute<void>(builder: (final BuildContext context) => child),
    (final Route<dynamic> route) => false,
  );
}
