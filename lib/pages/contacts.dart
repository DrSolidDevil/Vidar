import "package:flutter/material.dart";
import "package:vidar/commonobject.dart";
import "package:vidar/configuration.dart";
import "package:vidar/pages/chat.dart";
import "package:vidar/pages/edit_contact.dart";
import "package:vidar/pages/settings.dart";
import "package:vidar/utils.dart";

// ignore: public_member_api_docs
class ContactListPage extends StatefulWidget {
  // ignore: public_member_api_docs
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
              EditContactPage(newContact, "newcontact"),
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
          color: VidarColors.primaryDarkSpaceCadet,
          borderRadius: BorderRadius.circular(10),
        ),

        child: Column(
          children: <Widget>[
            Text(
              contact.name,
              style: const TextStyle(
                fontSize: 32,
                color: Colors.white,
                decoration: TextDecoration.none,
              ),
            ),
            Text(
              contact.phoneNumber,
              style: const TextStyle(
                fontSize: 12,
                color: Colors.white,
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
        debugPrint('Long hold on contact "${contact.name}"');
        // alert dialog
      },
    );
  }
}

class Contact {
  Contact(this.name, this.encryptionKey, this.phoneNumber);

  factory Contact.fromMap(final Map<String, dynamic> map) {
    return Contact(
      map["name"]! as String,
      map["encryptionKey"]! as String,
      map["phoneNumber"]! as String,
    );
  }

  String name;
  String encryptionKey;
  String phoneNumber;

  Map<String, String> toMap() {
    return <String, String>{
      "name": name,
      "encryptionKey": encryptionKey,
      "phoneNumber": phoneNumber,
    };
  }
}

class ContactList extends ChangeNotifier {
  ContactList(this.listOfContacts);

  List<Contact> listOfContacts;

  /// Returns true upon success
  bool addContact(final Contact contact) {
    if (findContactIndexByName(contact.name) != -1) {
      return false;
    }
    listOfContacts.add(contact);
    notifyListeners();
    return true;
  }

  /// Returns true upon success
  bool addContactByParams(
    final String name,
    final String encryptionKey,
    final String phoneNumber,
  ) {
    if (findContactIndexByName(name) != -1) {
      return false;
    }
    listOfContacts.add(Contact(name, encryptionKey, phoneNumber));
    notifyListeners();
    return true;
  }

  /// Expects that you know that the contact does indeed exist
  /// Returns true if it was found in the list and thus removed
  bool removeContactByName(final String name) {
    final int index = findContactIndexByName(name);
    if (index != -1) {
      listOfContacts.removeAt(index);
      notifyListeners();
      return true;
    } else {
      return false;
    }
  }

  /// Returns -1 if not found
  int findContactIndexByName(final String name) {
    for (final (int index, Contact contact) in listOfContacts.indexed) {
      if (contact.name == name) {
        return index;
      }
    }
    return -1;
  }

  /// Expects that you know that the contact does indeed exist
  /// Returns true if it was found in the list and thus removed
  bool removeContactByContact(final Contact contact) {
    final bool wasSuccess = listOfContacts.remove(contact);
    notifyListeners();
    return wasSuccess;
  }

  /// Change types are case-insensitive
  /// Change types: "name", "encryptionKey"
  /// Returns true on success
  bool modifyContactByName(
    final String contactName,
    final String changeType,
    final String newValue,
  ) {
    final int index = findContactIndexByName(contactName);
    if (index == -1) {
      return false;
    }
    switch (changeType.toLowerCase()) {
      case "name":
        listOfContacts[index].name = newValue;
      case "encryptionkey":
        listOfContacts[index].encryptionKey = newValue;
    }
    notifyListeners();
    return true;
  }

  bool modifyContactByContact(
    final Contact contact,
    final String changeType,
    final String newValue,
  ) {
    final int index = listOfContacts.indexOf(contact);
    if (index == -1) {
      return false;
    }
    switch (changeType.toLowerCase()) {
      case "name":
        listOfContacts[index].name = newValue;
      case "encryptionkey":
        listOfContacts[index].encryptionKey = newValue;
    }
    notifyListeners();
    return true;
  }

  List<ContactBadge> getContactBadges() {
    final List<ContactBadge> contactBadges = <ContactBadge>[];
    for (final Contact contact in listOfContacts) {
      contactBadges.add(ContactBadge(contact));
    }
    return contactBadges;
  }

  ContactBadge getContactBadgeAtIndex(final int index) {
    return ContactBadge(listOfContacts[index]);
  }
}

/// True if it is invalid
bool isInvalidContactByParams(
  final String? name,
  final String? encryptionKey,
  final String? phoneNumber,
) {
  if (name == null || phoneNumber == null) {
    return true;
  }
  if (name == "" || phoneNumber == "") {
    return true;
  }
  if (phoneNumber[0] != "+") {
    return true;
  }
  // phone number contains non numberic characters
  if (phoneNumber.contains(RegExp(r"[^\d+]"))) {
    return true;
  }
  return false;
}

bool isInvalidContact(final Contact contact) {
  return isInvalidContactByParams(
    contact.name,
    contact.encryptionKey,
    contact.phoneNumber,
  );
}
