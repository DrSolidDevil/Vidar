import "package:flutter/material.dart";
import "package:vidar/pages/contact_list.dart";
import "package:vidar/utils/log.dart";
import "package:vidar/utils/navigation.dart";
import "package:vidar/utils/settings.dart";

/// Alert dialog template for errors
class ErrorPopup extends StatefulWidget {
  const ErrorPopup({
    required this.title,
    required this.body,
    required this.enableReturn,
    super.key,
  });

  /// Title of the error popup, try to keep it short and simple.
  final String title;

  /// Text body of the error popup, explains the error that occured.
  final String body;

  /// Enable return button for the error popup
  /// (i.e return to page where error occured)
  final bool enableReturn;

  @override
  _ErrorPopupState createState() => _ErrorPopupState();
}

class _ErrorPopupState extends State<ErrorPopup> {
  _ErrorPopupState();
  late final String title;
  late final String body;
  late final bool enableReturn;

  List<Widget> actions(final BuildContext context) {
    final List<Widget> list = <Widget>[
      TextButton(
        onPressed: () {
          clearNavigatorAndPush(context, const ContactListPage());
        },
        child: const Text("Home"),
      ),
    ];
    if (Settings.keepLogs) {
      list.add(
        TextButton(
          onPressed: () {
            exportLogs();
            clearNavigatorAndPush(context, const ContactListPage());
          },
          child: const Text("Export logs"),
        ),
      );
    }
    list.add(
      TextButton(
        onPressed: () {
          Navigator.of(context).pop();
        },
        child: const Text("Back"),
      ),
    );
    return list;
  }

  @override
  void initState() {
    super.initState();
    title = widget.title;
    body = widget.body;
    enableReturn = widget.enableReturn;
  }

  @override
  Widget build(final BuildContext context) {
    return Stack(
      children: <Widget>[
        // Be aware of error infinite loops if the error comes from ContactListPage
        const ContactListPage(),
        Center(
          child: AlertDialog(
            title: Text(title),
            content: Text(body),
            actions: actions(context),
          ),
        ),
      ],
    );
  }
}
