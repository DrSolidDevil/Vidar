import "package:flutter/material.dart";
import "package:permission_handler/permission_handler.dart";
import "package:shared_preferences/shared_preferences.dart";
import "package:vidar/configuration.dart";
import "package:vidar/pages/contact_list.dart";
import "package:vidar/utils/common_object.dart";
import "package:vidar/utils/settings.dart";
import "package:vidar/utils/sms.dart";
import "package:vidar/utils/storage.dart";
import "package:vidar/widgets/info_text_widget.dart";
import "package:vidar/widgets/loading_screen.dart";

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  externalConfiguration();
  await loadData(CommonObject.contactList);

  // If last logon is past the wipeout time -> wipe keys
  if (Settings.allowWipeoutTime &&
      CommonObject.lastLogon != null &&
      DateTime.now().difference(CommonObject.lastLogon!).inDays >
          Settings.wipeoutTime) {
    if (Settings.keepLogs) {
      CommonObject.logger!.info(
        "Last logon was more than ${Settings.wipeoutTime} days, wiping all keys...",
      );
    }
    CommonObject.contactList.wipeKeys();
    wipeSecureStorage();
  }
  SmsConstants(await retrieveSmsConstantsMap());
  CommonObject.lastLogon = DateTime.now();
  await (await SharedPreferences.getInstance()).setString(
    "lastlogon",
    CommonObject.lastLogon!.toIso8601String(),
  );

  runApp(const VidarApp());
}

class VidarApp extends StatelessWidget {
  const VidarApp({super.key});

  @override
  Widget build(final BuildContext context) => MaterialApp(
    title: "Vidar",
    home: FutureBuilder<PermissionStatus>(
      future: Permission.sms.request(),
      builder:
          (
            final BuildContext context,
            final AsyncSnapshot<PermissionStatus> snapshot,
          ) {
            if (snapshot.hasData) {
              if (snapshot.data!.isGranted) {
                return const ContactListPage();
              } else {
                return const InfoText(
                  text:
                      "To use Vidar you need to enable SMS permissions. Enable SMS permissions in the app settings then restart the app.",
                  textWidthFactor: 0.8,
                  fontSize: 20,
                );
              }
            } else {
              return const LoadingScreen(<String>[
                "Requesting",
                "SMS",
                "permission",
              ]);
            }
          },
    ),
  );
}
