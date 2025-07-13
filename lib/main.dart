import "package:flutter/material.dart";
import "package:permission_handler/permission_handler.dart";
import "package:vidar/configuration.dart";
import "package:vidar/pages/contact_list.dart";
import "package:vidar/pages/no_sms_permission.dart";
import "package:vidar/utils/common_object.dart";
import "package:vidar/utils/sms.dart";
import "package:vidar/utils/storage.dart";

late PermissionStatus smsStatus;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  externalConfiguration();

  await loadData(CommonObject.contactList, CommonObject.settings);
  SmsConstants(await retrieveSmsConstantsMap());
  smsStatus = await Permission.sms.request();
  
  runApp(const VidarApp());
}

class VidarApp extends StatelessWidget {
  const VidarApp({super.key});

  @override
  Widget build(final BuildContext context) {
    if (smsStatus.isGranted) {
      return const MaterialApp(title: "Vidar", home: ContactListPage());
    } else {
      return const MaterialApp(title: "Vidar", home: NoSmsPermissionPage());
    }
  }
}
