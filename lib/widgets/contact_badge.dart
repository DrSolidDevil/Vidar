import "package:flutter/material.dart";
import "package:vidar/configuration.dart";
import "package:vidar/pages/chat.dart";
import "package:vidar/pages/contact_list.dart";
import "package:vidar/utils/common_object.dart";
import "package:vidar/utils/contact.dart";
import "package:vidar/utils/navigation.dart";
import "package:vidar/utils/settings.dart";
import "package:vidar/utils/storage.dart";

/// Badge button to contact, shows name and phone number.
class ContactBadge extends StatelessWidget {
  const ContactBadge(this.contact, {super.key});
  final Contact contact;

  @override
  Widget build(final BuildContext context) {
    return InkWell(
      child: Container(
        alignment: Alignment.center,
        padding: const EdgeInsets.only(top: 10, bottom: 10),
        margin: const EdgeInsets.only(top: 5, bottom: 5, left: 10, right: 10),
        decoration: BoxDecoration(
          color: Settings.colorSet.primary,
          borderRadius: BorderRadius.circular(10),
        ),

        child: Column(
          children: <Widget>[
            Text(
              contact.name,
              style: TextStyle(
                fontSize: 32,
                color: Settings.colorSet.text,
                decoration: TextDecoration.none,
              ),
            ),
            Text(
              contact.phoneNumber,
              style: TextStyle(
                fontSize: 12,
                color: Settings.colorSet.text,
                decoration: TextDecoration.none,
              ),
            ),
          ],
        ),
      ),
      onTap: () {
        clearNavigatorAndPush(context, ChatPage(contact));
      },
      onLongPress: () {
        showDialog<void>(
          context: context,
          builder: (final BuildContext dialogContext) {
            return Stack(
              children: <Widget>[
                const ContactListPage(),
                Center(
                  child: AlertDialog(
                    title: Text(
                      "Delete contact",
                      style: TextStyle(color: Settings.colorSet.dialogText),
                    ),
                    content: Text(
                      'Are you sure you want to delete "${contact.name}?"',
                      style: TextStyle(color: Settings.colorSet.dialogText),
                    ),
                    actions: <Widget>[
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
                      TextButton(
                        onPressed: () {
                          final bool success = CommonObject.contactList
                              .removeContactByContact(contact);
                          saveData(CommonObject.contactList);
                          if (LoggingConfiguration.extraVerboseLogs &&
                              Settings.keepLogs) {
                            CommonObject.logger!.info(
                              success
                                  ? "Contact ${contact.uuid} deleted"
                                  : "Contact ${contact.uuid} failed to delete",
                            );
                          }
                          clearNavigatorAndPush(
                            context,
                            const ContactListPage(),
                          );
                        },
                        child: Text(
                          "Delete",
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
          },
        );
      },
    );
  }
}
