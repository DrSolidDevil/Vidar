import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:vidar/commonobject.dart';
import 'package:vidar/fakesms.dart';
import 'package:vidar/pages/contacts.dart';
import 'package:vidar/pages/settings.dart';
import 'package:vidar/popuphandler.dart';
import 'package:vidar/save.dart';
import 'package:vidar/sms.dart';

/*
Notes:
You can't have multiple people with the same name

if contact has no key then no encryption is done (i.e it sends plain text)
*/

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final contactList = ContactList([]);
  final settings = Settings();
  CommonObject.contactList = contactList;
  CommonObject.settings = settings;

  if (defaultTargetPlatform == TargetPlatform.android) {
      loadData(contactList, settings);
    } else {
      print("(No implementation) Loading fake contacts...");
      contactList.listOfContacts = fakeListOfContacts;
    }

  print("Fetching sms constants...");
  SmsConstants(await retrieveSmsConstantsMap());
  print("Sms constants fetched");
  await Permission.sms.request();
  runApp(App());
}

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Vidar', 
      home: ListenableBuilder(
        listenable: PopupHandler.popupUpdater, 
        builder: (BuildContext context, Widget? widget) {
          if (PopupHandler.showPopup && PopupHandler.popup != null) {
            PopupHandler.showPopup = false;
            return PopupHandler.popup!;
          } else {
            return ContactListPage();
          }
        }
      )
    );
  }
}
