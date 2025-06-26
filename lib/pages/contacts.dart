import 'package:flutter/material.dart';
import 'package:vidar/commonobject.dart';
import 'package:vidar/configuration.dart';
import 'package:vidar/pages/chat.dart';
import 'package:vidar/pages/edit_contact.dart';
import 'package:vidar/pages/settings.dart';

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
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: VidarColors.secondaryMetallicViolet,
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      floatingActionButton: Container(
        decoration: BoxDecoration(
          color: VidarColors.secondaryMetallicViolet,
          border: Border.all(color: Colors.white, width: 2),
          borderRadius: BorderRadius.circular(10),
        ),
        child: FloatingActionButton(
          onPressed: () {
            final newContact = Contact("", "", "");
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => EditContactPage(newContact, "newcontact"),
              ),
            );
          },
          backgroundColor: Colors.transparent,
          foregroundColor: Colors.white,
          child: const Icon(Icons.add_comment),
        ),
      ),

      body: ListenableBuilder(
        listenable: CommonObject.contactList,
        builder: (context, child) {
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
        actions: [
          Container(
            margin: const EdgeInsets.only(right: 10),
            child: IconButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => SettingsPage()),
                );
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
  Widget build(BuildContext context) {
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
          children: [
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
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => ChatPage(contact)),
        );
      },
      onLongPress: () {
        print('Long hold on contact "${contact.name}"');
        // alert dialog
      },
    );
  }
}

class Contact {
  Contact(this.name, this.encryptionKey, this.phoneNumber);
  String name;
  String encryptionKey;
  String phoneNumber;

  Map<String, String> toMap() {
    return {
      "name": name,
      "encryptionKey": encryptionKey,
      "phoneNumber": phoneNumber,
    };
  }

  factory Contact.fromMap(Map<String, dynamic> map) {
    return Contact(
      map["name"]! as String,
      map["encryptionKey"]! as String,
      map["phoneNumber"]! as String,
    );
  }
}

class ContactList extends ChangeNotifier {
  ContactList(this.listOfContacts);

  List<Contact> listOfContacts;

  /// Returns true upon success
  bool addContact(Contact contact) {
    if (findContactIndexByName(contact.name) != -1) {
      return false;
    }
    listOfContacts.add(contact);
    notifyListeners();
    return true;
  }

  /// Returns true upon success
  bool addContactByParams(
    String name,
    String encryptionKey,
    String phoneNumber,
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
  bool removeContactByName(String name) {
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
  int findContactIndexByName(String name) {
    for (final (index, contact) in listOfContacts.indexed) {
      if (contact.name == name) {
        return index;
      }
    }
    return -1;
  }

  /// Expects that you know that the contact does indeed exist
  /// Returns true if it was found in the list and thus removed
  bool removeContactByContact(Contact contact) {
    final bool wasSuccess = listOfContacts.remove(contact);
    notifyListeners();
    return wasSuccess;
  }

  /// Change types are case-insensitive
  /// Change types: "name", "encryptionKey"
  /// Returns true on success
  bool modifyContactByName(
    String contactName,
    String changeType,
    String newValue,
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
    Contact contact,
    String changeType,
    String newValue,
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
    final contactBadges = <ContactBadge>[];
    for (final contact in listOfContacts) {
      contactBadges.add(ContactBadge(contact));
    }
    return contactBadges;
  }

  ContactBadge getContactBadgeAtIndex(int index) {
    return ContactBadge(listOfContacts[index]);
  }
}

/// True if it is invalid
bool isInvalidContactByParams(
  String? name,
  String? encryptionKey,
  String? phoneNumber,
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

bool isInvalidContact(Contact contact) {
  return isInvalidContactByParams(
    contact.name,
    contact.encryptionKey,
    contact.phoneNumber,
  );
}
