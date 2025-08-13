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
  final ScrollController _scrollController = ScrollController();

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
            title: Text(
              title,
              style: TextStyle(color: Settings.colorSet.dialogText),
            ),
            content: ConstrainedBox(
              constraints: BoxConstraints(
                maxHeight: MediaQuery.of(context).size.height / 2,
              ),
              child: RawScrollbar(
                thumbColor: Settings.colorSet.dialogScrollbar,
                controller: _scrollController,
                thumbVisibility: true,
                thickness: 2,
                interactive: true,
                padding: const EdgeInsets.only(left: 4),
                child: TextField(
                  readOnly: true,
                  scrollController: _scrollController,
                  controller: TextEditingController(text: body),
                  maxLines: null,
                  decoration: const InputDecoration(border: InputBorder.none),
                  style: TextStyle(color: Settings.colorSet.dialogText),
                ),
              ),
            ),
            actions: <Widget>[
              TextButton(
                onPressed: () {
                  clearNavigatorAndPush(context, const ContactListPage());
                },
                child: Text(
                  "Home",
                  style: TextStyle(
                    color: Settings.colorSet.dialogButtonText,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ),
              if (Settings.keepLogs)
                TextButton(
                  onPressed: () {
                    exportLogs();
                    clearNavigatorAndPush(context, const ContactListPage());
                  },
                  child: Text(
                    "Export logs",
                    style: TextStyle(
                      color: Settings.colorSet.dialogButtonText,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ),
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text(
                  "Back",
                  style: TextStyle(
                    color: Settings.colorSet.dialogButtonText,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ),
            ],
            backgroundColor: Settings.colorSet.dialogBackground,
          ),
        ),
      ],
    );
  }
}
