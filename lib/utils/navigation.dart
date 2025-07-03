import "package:flutter/material.dart";

void clearNavigatorAndPush(
  final BuildContext currentContext,
  final Widget destination,
) {
  Navigator.pushAndRemoveUntil(
    currentContext,
    MaterialPageRoute<void>(builder: (final BuildContext context) => destination),
    (final Route<dynamic> route) => false,
  );
}
