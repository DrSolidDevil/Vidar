import "package:flutter/material.dart";
import "package:logging/logging.dart";
import "package:permission_handler/permission_handler.dart";
import "package:vidar/configuration.dart";
import "package:vidar/pages/contact_list.dart";
import "package:vidar/utils/common_object.dart";
import "package:vidar/utils/contact.dart";
import "package:vidar/utils/popup_handler.dart";
import "package:vidar/utils/settings.dart";
import "package:vidar/utils/sms.dart";
import "package:vidar/utils/storage.dart";

/*
Notes:
You can't have multiple people with the same name

if contact has no key then no encryption is done (i.e it sends plain text)
*/

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final ContactList contactList = ContactList(<Contact>[]);
  final Settings settings = Settings();
  CommonObject.contactList = contactList;
  CommonObject.settings = settings;

  await loadData(contactList, settings);
  SmsConstants(await retrieveSmsConstantsMap());
  await Permission.sms.request();
  if (Settings.keepLogs) {
    CommonObject.logger = Logger(LoggingConfiguration.loggerName);
    CommonObject.logger!.onRecord.listen((final LogRecord log) {
      debugPrint(LoggingConfiguration.errorMessage(log));
      CommonObject.logs.add(LoggingConfiguration.errorMessage(log));
    });
  }
  runApp(const App());
}

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(final BuildContext context) {
    return MaterialApp(
      title: "Vidar",
      home: ListenableBuilder(
        listenable: PopupHandler.popupUpdater,
        builder: (final BuildContext context, final Widget? widget) {
          if (PopupHandler.showPopup && PopupHandler.popup != null) {
            PopupHandler.showPopup = false;
            return PopupHandler.popup!;
          } else {
            return const ContactListPage();
          }
        },
      ),
    );
  }
}
