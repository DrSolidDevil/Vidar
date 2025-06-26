



import 'package:flutter/material.dart';
import 'package:vidar/pages/contacts.dart';


class ErrorPopup extends StatefulWidget {
  const ErrorPopup(this.title, this.body, this.enableReturn, {super.key});

  final String title;
  final String body;
  final bool enableReturn;

  @override
  createState() => _ErrorPopupState();
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
        ContactListPage(),
        Center(
          child: AlertDialog(
            title: Text(
              title
            ),
            content: Text(
              body
            ),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) => ContactListPage(),),);
                }, 
                child: Text("Home")
              ),
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                }, 
                child: Text("Back")
              ),
            ],
          ),
        )
      ],
    );
  }
}