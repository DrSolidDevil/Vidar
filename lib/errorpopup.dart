import 'package:flutter/material.dart';
import 'package:vidar/pages/contacts.dart';

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

  @override
  void initState() {
    super.initState();
    title = widget.title;
    body = widget.body;
    enableReturn = widget.enableReturn;
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // Be aware of error infinite loops if the error comes from ContactListPage
        const ContactListPage(),
        Center(
          child: AlertDialog(
            title: Text(title),
            content: Text(body),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (BuildContext context) => const ContactListPage(),
                    ),
                  );
                },
                child: const Text("Home"),
              ),
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: const Text("Back"),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
