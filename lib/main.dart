import "package:flutter/material.dart";
import "package:go_router/go_router.dart";
import "package:permission_handler/permission_handler.dart";
import "package:vidar/pages/chat.dart";
import "package:vidar/pages/contact_list.dart";
import "package:vidar/pages/contact_qr.dart";
import "package:vidar/pages/edit_contact.dart";
import "package:vidar/pages/no_sms_permission.dart";
import "package:vidar/pages/settings_page.dart";
import "package:vidar/utils/common_object.dart";
import "package:vidar/utils/contact.dart";
import "package:vidar/utils/settings.dart";
import "package:vidar/utils/sms.dart";
import "package:vidar/utils/storage.dart";

late PermissionStatus smsStatus;
late PermissionStatus phoneStatus;

final GoRouter _routerConfig = GoRouter(
  routes: <RouteBase>[
    GoRoute(
      name: "ContactListPage",
      path: "/",
      builder: (final BuildContext context, final GoRouterState state) {
        if (smsStatus.isGranted) {
          return const ContactListPage();
        } else {
          return const NoSmsPermissionPage();
        }
      },
    ),
    GoRoute(
      name: "ChatPage",
      path: "/chatpage",
      builder: (final BuildContext context, final GoRouterState state) =>
          const ChatPage(),
    ),
    GoRoute(
      name: "EditContactPage",
      path: "/editcontactpage/:caller",
      builder: (final BuildContext context, final GoRouterState state) =>
          EditContactPage(state.pathParameters["caller"]!),
    ),
    GoRoute(
      name: "ContactQrPage",
      path: "/contactqrpage/:uri",
      builder: (final BuildContext context, final GoRouterState state) =>
          ContactQrPage(uri: state.pathParameters["uri"]!),
    ),
    GoRoute(
      name: "SettingsPage",
      path: "/settingspage",
      builder: (final BuildContext context, final GoRouterState state) =>
          const SettingsPage()
    ),
    GoRoute(
      name: "UpdateContact",
      path: "/updatecontact/:phonenumber/:encryptionkey",
      builder: (final BuildContext context, final GoRouterState state) {
        if (smsStatus.isGranted) {
          return updateContact(
            phoneNumber: "+${state.pathParameters["phonenumber"]!}",
            encryptionKey: state.pathParameters["encryptionkey"]!,
          );
        } else {
          return const NoSmsPermissionPage();
        }
      },
    ),
  ],
);

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final ContactList contactList = ContactList(<Contact>[]);
  final Settings settings = Settings();
  CommonObject.contactList = contactList;
  CommonObject.settings = settings;

  await loadData(contactList, settings);
  SmsConstants(await retrieveSmsConstantsMap());
  smsStatus = await Permission.sms.request();
  phoneStatus = await Permission.phone.request();
  if (phoneStatus.isDenied) {
    if (Settings.keepLogs) {
      CommonObject.logger!.info("PERMISSION_GROUP_PHONE is denied");
    }
  } else {
    CommonObject.ownPhoneNumber = await getOwnPhoneNumber();
  }

  runApp(const VidarApp());
}

class VidarApp extends StatelessWidget {
  const VidarApp({super.key});

  @override
  Widget build(final BuildContext context) {
    return MaterialApp.router(title: "Vidar", routerConfig: _routerConfig);
  }
}
