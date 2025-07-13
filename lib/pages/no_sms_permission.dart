import "package:flutter/material.dart";
import "package:vidar/utils/settings.dart";

class NoSmsPermissionPage extends StatelessWidget {
  const NoSmsPermissionPage({super.key});

  @override
  Widget build(final BuildContext context) {
    return ColoredBox(
      color: Settings.colorSet.primary,
      child: Center(
        child: SizedBox(
          width: MediaQuery.of(context).size.width * 0.8,
          child: Text(
            "To use Vidar you need to enable SMS permissions. Enable SMS permissions in the app settings then restart the app.",
            style: TextStyle(
              color: Settings.colorSet.text,
              fontSize: 20,
              decoration: TextDecoration.none,
            ),
            textAlign: TextAlign.center,
          ),
        ),
      ),
    );
  }
}
