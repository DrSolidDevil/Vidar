import "package:flutter/material.dart";
import "package:go_router/go_router.dart";
import "package:permission_handler/permission_handler.dart";
import "package:vidar/main.dart" show phoneStatus;
import "package:vidar/utils/common_object.dart";
import "package:vidar/utils/contact.dart";

/// CommonObject.ownPhoneNumber need to not be null
String? generateContactUri({
  required final Contact contact,
  required final BuildContext context,
}) {
  if (phoneStatus.isDenied) {
    showDialog<void>(
      context: context,
      builder: (final BuildContext context) => AlertDialog(
        title: const Text("Read phone state permission is denied"),
        content: const Text(
          "To share contact QR-codes you need to enable this permission.",
        ),
        actions: <Widget>[
          TextButton(
            onPressed: () => context.goNamed("ChatPage"),
            child: const Text("Dismiss"),
          ),
        ],
      ),
    );
    return null;
  } else {
    if (CommonObject.ownPhoneNumber == null) {
      CommonObject.logger!.info("ownPhoneNumber is null");
      return null;
    } else {
      return "app://vidar/updatecontact/${CommonObject.ownPhoneNumber!.replaceFirst("+", "")}/${contact.encryptionKey}";
    }
  }
}
