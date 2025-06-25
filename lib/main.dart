import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:vidar/commonobjs.dart';
import 'package:vidar/error.dart';
import 'package:vidar/fakesms.dart';
import 'package:vidar/pages/settings.dart';
import 'package:vidar/save.dart';
import 'package:vidar/shutdownhandling.dart';
import 'pages/contacts.dart';
import 'sms.dart';

/*
Notes:
You can't have multiple people with the same name
Use the edit contact page to create new ones by just entering a blank contact
If a part is missing then do an alert

if contact has no key then no encryption is done (i.e it sends plain text)

to format phone numbers maybe use the "phone_numbers_parser" package

have a "generate key" button beside the key field 
*/

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  print("Fetching sms constants...");
  SmsConstants(await retrieveSmsConstantsMap());
  print("Sms constants fetched");
  runApp(App());
}

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    final ContactList contactList = ContactList([]);
    final Settings settings = Settings();

    if (defaultTargetPlatform == TargetPlatform.android) {
      loadData(contactList, settings);
      WidgetsBinding.instance.addObserver(
        ShutdownHandler(settings, contactList),
      );
    } else {
      print("(No implementation) Loading fake contacts...");
      contactList.listOfContacts = fakeListOfContacts;
    }
    CommonObject.contactList = contactList;

    return MaterialApp(
      title: 'Vidar', 
      home: ListenableBuilder(
        listenable: ErrorHandler.errorUpdater, 
        builder: (BuildContext context, Widget? widget) {
          if (ErrorHandler.hasError && ErrorHandler.errorPopup != null) {
            ErrorHandler.hasError = false;
            // ignore:return_of_invalid_type_from_closure
            return ErrorHandler.errorPopup;
          } else {
            return ContactListPage();
          }
        }
      )
    );
  }
}
