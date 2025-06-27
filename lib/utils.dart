import "package:flutter/material.dart";

class Updater extends ChangeNotifier {
  void update() {
    notifyListeners();
  }
}

void clearNavigatorAndPush(final BuildContext currentContext, final Widget child) {
  Navigator.pushAndRemoveUntil(
    currentContext,
    MaterialPageRoute(builder: (final BuildContext context) => child),
    (final Route<dynamic> route) => false,
  );
}
