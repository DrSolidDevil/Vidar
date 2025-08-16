import "dart:math";

import "package:flutter/material.dart";
import "package:vidar/configuration.dart";
import "package:vidar/pages/edit_contact.dart";
import "package:vidar/pages/feedback_page.dart";
import "package:vidar/pages/settings_page.dart";
import "package:vidar/utils/common_object.dart";
import "package:vidar/utils/contact.dart";
import "package:vidar/utils/extended_change_notifier.dart";
import "package:vidar/utils/navigation.dart";
import "package:vidar/utils/settings.dart";

class ContactListPage extends StatefulWidget {
  const ContactListPage({super.key});

  @override
  _ContactListPageState createState() => _ContactListPageState();
}

class _ContactListPageState extends State<ContactListPage> {
  _ContactListPageState() {
    feedbackDialog = Stack(
      children: <Widget>[
        AlertDialog(
          title: Text(
            "Feedback",
            style: TextStyle(color: Settings.colorSet.dialogText),
          ),
          content: RichText(
            text: TextSpan(
              children: const <InlineSpan>[
                TextSpan(
                  text:
                      "Vidar is still in development. We would appreciate your help in making Vidar better. Please tell us what you think!",
                ),
                TextSpan(
                  text: "\n\nTo disable these popups, go to settings.",
                  style: TextStyle(
                    fontStyle: FontStyle.italic,
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
              style: TextStyle(color: Settings.colorSet.dialogText),
            ),
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                feedbackDialogVisible = false;
                changeNotifier.notifyListeners();
              },
              child: Text(
                "Dismiss",
                style: TextStyle(
                  color: Settings.colorSet.dialogButtonText,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ),
            TextButton(
              onPressed: () =>
                  clearNavigatorAndPush(context, const FeedbackPage()),
              child: Text(
                "Give Feedback",
                style: TextStyle(
                  color: Settings.colorSet.dialogButtonText,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ),
          ],
          backgroundColor: Settings.colorSet.dialogBackground,
        ),
      ],
    );
  }

  late final Widget feedbackDialog;
  final ExtendedChangeNotifier changeNotifier = ExtendedChangeNotifier();
  bool feedbackDialogVisible = true;

  @override
  Widget build(final BuildContext context) {
    return ListenableBuilder(
      listenable: changeNotifier,
      builder: (final BuildContext context, final Widget? value) {
        final bool displayFeedbackDialog =
            Settings.allowUserFeedbackDialog &&
            feedbackDialogVisible &&
            MiscellaneousConfiguration.userFeedbackDialogProbability >
                Random().nextDouble();

        return Stack(
          children: <Widget>[
            Scaffold(
              backgroundColor: Settings.colorSet.secondary,
              floatingActionButtonLocation:
                  FloatingActionButtonLocation.endFloat,
              floatingActionButton: DecoratedBox(
                decoration: BoxDecoration(
                  color: Settings.colorSet.floatingActionButton,
                  border: Border.all(color: Settings.colorSet.text, width: 2),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: FloatingActionButton(
                  elevation: 0,
                  highlightElevation: 0,
                  onPressed: () {
                    final Contact newContact = Contact("", "", "");
                    clearNavigatorAndPush(
                      context,
                      EditContactPage(newContact, ContactPageCaller.newContact),
                    );
                  },
                  backgroundColor: Colors.transparent,
                  foregroundColor: Settings.colorSet.text,
                  child: const Icon(Icons.add_comment),
                ),
              ),
              body: ListenableBuilder(
                listenable: CommonObject.contactList,
                builder: (final BuildContext context, final Widget? value) {
                  return Material(
                    color: Colors.transparent,
                    child: ListView(
                      children: CommonObject.contactList.getContactBadges(),
                    ),
                  );
                },
              ),

              appBar: AppBar(
                backgroundColor: Settings.colorSet.primary,
                title: Text(
                  "Vidar – For Privacy's Sake",
                  style: TextStyle(
                    fontSize: 18,
                    color: Settings.colorSet.text,
                    decoration: TextDecoration.none,
                  ),
                ),
                actions: <Widget>[
                  Container(
                    margin: const EdgeInsets.only(right: 10),
                    child: IconButton(
                      onPressed: () {
                        clearNavigatorAndPush(context, const SettingsPage());
                      },
                      icon: Icon(Icons.settings, color: Settings.colorSet.text),
                      tooltip: "Settings",
                    ),
                  ),
                ],
              ),
            ),
            if (displayFeedbackDialog)
              const ColoredBox(color: Colors.black54, child: SizedBox.expand()),
            if (displayFeedbackDialog) feedbackDialog,
          ],
        );
      },
    );
  }
}
