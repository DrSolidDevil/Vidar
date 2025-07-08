import "package:flutter/material.dart";
import "package:vidar/configuration.dart";
import "package:vidar/pages/edit_contact.dart";
import "package:vidar/pages/settings_page.dart";
import "package:vidar/utils/common_object.dart";
import "package:vidar/utils/contact.dart";
import "package:vidar/utils/navigation.dart";

class ContactListPage extends StatefulWidget {
  const ContactListPage({super.key});

  @override
  _ContactListPageState createState() => _ContactListPageState();
}

class _ContactListPageState extends State<ContactListPage> {
  _ContactListPageState();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(final BuildContext context) {
    return Scaffold(
      backgroundColor: VidarColors.secondaryMetallicViolet,
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      floatingActionButton: DecoratedBox(
        decoration: BoxDecoration(
          color: VidarColors.secondaryMetallicViolet,
          border: Border.all(color: Colors.white, width: 2),
          borderRadius: BorderRadius.circular(10),
        ),
        child: FloatingActionButton(
          onPressed: () {
            final Contact newContact = Contact("", "", "");
            clearNavigatorAndPush(
              context,
              EditContactPage(newContact, ContactPageCaller.newContact),
            );
          },
          backgroundColor: Colors.transparent,
          foregroundColor: Colors.white,
          child: const Icon(Icons.add_comment),
        ),
      ),

      body: ListenableBuilder(
        listenable: CommonObject.contactList,
        builder: (final BuildContext context, final Widget? child) {
          return Material(
            color: Colors.transparent,
            child: ListView(
              children: CommonObject.contactList.getContactBadges(),
            ),
          );
        },
      ),

      appBar: AppBar(
        backgroundColor: VidarColors.primaryDarkSpaceCadet,
        title: const Text(
          "Vidar - For Privacy's Sake",
          style: TextStyle(
            fontSize: 18,
            color: Colors.white,
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
              icon: const Icon(Icons.settings, color: Colors.white),
              tooltip: "Settings",
            ),
          ),
        ],
      ),
    );
  }
}
