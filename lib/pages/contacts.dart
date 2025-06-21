import 'package:flutter/material.dart';
import 'package:vidar/pages/chat.dart';
import 'package:vidar/pages/edit_contact.dart';
import '../configuration.dart';



class ContactListPage extends StatefulWidget {
  const ContactListPage(this.contactList, {super.key});
  final ContactList contactList;

  @override
  createState() => _ContactListPageState();
}

class _ContactListPageState extends State<ContactListPage> {
  _ContactListPageState();
  late ContactList contactList;

  @override
  void initState() {
    super.initState();
    contactList = widget.contactList;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: VidarColors.secondaryMetallicViolet,
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      floatingActionButton: Container(
        decoration: BoxDecoration(
          color: VidarColors.secondaryMetallicViolet,
          border: Border.all(
            color: Colors.white, 
            width: 2
          ),
          borderRadius: BorderRadius.circular(10.0),
        ),
        child: FloatingActionButton(
          onPressed: () {
            Contact newContact = Contact("", "", "");
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => EditContactPage(newContact, contactList, "newcontact")),
            );
          },
          backgroundColor: Colors.transparent,
          foregroundColor: Colors.white,
          child: Icon(Icons.add_comment),
        ),
      ),

      body: ListenableBuilder(
        listenable: contactList, 
        builder: (context, child) {
          return Material(
            color:  Colors.transparent,
            child: ListView(
              children: contactList.getContactBadges(),
            ),
          );
        },
      ),
      
      appBar: AppBar(
        backgroundColor: VidarColors.primaryDarkSpaceCadet,
        title: Text(
          "Vidar - For Privacy's Sake",
          style: const TextStyle(
            fontSize: 18,
            color: Colors.white,
            decoration: TextDecoration.none
          ),
        ),
        actions: [
          Container(
            margin: EdgeInsets.only(right: 10),
            child: IconButton(
              onPressed: () {print("Settings button pressed");},
              icon: const Icon(
                Icons.settings,
                color: Colors.white,
              ),
              tooltip: "Settings",
            ),
          )
        ],
      ),
    );
  }
}

class ContactBadge extends StatelessWidget {
  const ContactBadge(this.contact, this.contactList, {super.key});
  final Contact contact;
  final ContactList contactList;

  @override
  Widget build(BuildContext context) {
    return InkWell( 
      child: Container(
        alignment: Alignment.center,
        padding: const EdgeInsets.only(top: 10, bottom: 10),
        margin: EdgeInsets.only(top: 5, bottom: 5, left: 10, right: 10),
        decoration: BoxDecoration(
          color: VidarColors.primaryDarkSpaceCadet,
          borderRadius: BorderRadius.circular(10.0),
        ),
      
        child: Column(
          children: [
            Text(
              contact.name,
              style: const TextStyle(
                fontSize: 32,
                color: Colors.white,
                decoration: TextDecoration.none
              ),
            ),
            Text(
              contact.phoneNumber,
              style: const TextStyle(
                fontSize: 12,
                color: Colors.white,
                decoration: TextDecoration.none
              ),
            )
          ],
        ),
      ),
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => ChatPage(contact, contactList)),
        );
      },
      onLongPress: () {
        print("Long hold on contact \"${contact.name}\"");
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
}

class ContactList extends ChangeNotifier {
  ContactList(this.listOfContacts);

  final List<Contact> listOfContacts;

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
  bool addContactByParams(final String name, final String encryptionKey, final String phoneNumber) {
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
    for (final (index, contact) in listOfContacts.indexed) {
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
  bool modifyContactByName(final String contactName, final String changeType, final String newValue) {
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

  bool modifyContactByContact(final Contact contact, final String changeType, final String newValue) {
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
    final List<ContactBadge> contactBadges = [];
    for (final Contact contact in listOfContacts) {
      contactBadges.add(ContactBadge(contact, this));
    }
    return contactBadges;
  }

  ContactBadge getContactBadgeAtIndex(final int index) {
    return ContactBadge(listOfContacts[index], this);
  }
}

/// True if it is invalid
bool isInvalidContactByParams(String? name, String? encryptionKey, String? phoneNumber) {
  if (name == null || phoneNumber == null) {
    return true;
  }
  if (name == "" || phoneNumber == "") {
    return true;
  }
  // phone number contains non numberic characters
  if (phoneNumber.contains(RegExp(r"[^\d]"))) {
    return true;
  }
  return false;
}

bool isInvalidContact(Contact contact) {
  return isInvalidContactByParams(contact.name, contact.encryptionKey, contact.phoneNumber);
}
