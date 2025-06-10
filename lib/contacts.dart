import 'package:flutter/material.dart';
import 'configuration.dart';



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
          borderRadius: BorderRadius.all(Radius.circular(10.0))
        ),
        child: FloatingActionButton(
          onPressed: () {print("FloatingActionButton was pressed");},
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
              onPressed: () {print("Settingg button pressed");},
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
  const ContactBadge(this.contact, {super.key});
  final Contact contact;

  @override
  Widget build(BuildContext context) {
    return InkWell( 
      child: Container(
        height: 70,
        width: 100, // MediaQuery.sizeOf(context).width
        alignment: Alignment.center,
        padding: const EdgeInsets.only(top: 10, bottom: 10),
        margin: EdgeInsets.only(top: 5, bottom: 5, left: 10, right: 10),
        decoration: BoxDecoration(
          color: VidarColors.primaryDarkSpaceCadet,
          borderRadius: BorderRadius.all(Radius.circular(10.0))
        ),
      
        child: Text(
          contact.name,
          style: const TextStyle(
            fontSize: 32,
            color: Colors.white,
            decoration: TextDecoration.none
          ),
        ),
      ),
      onTap: () {
        print("Go to contact \"" + contact.name + "\"");
      },
      onLongPress: () {
        print("Long hold on contact \"" + contact.name + "\"");
      },
    );
  }
}

class Contact {
  Contact(this.name, this.encryptionKey, this.phoneNumber);
  String name;
  String encryptionKey;
  final String phoneNumber;
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
      print("(removeContactByName) Contact name \"$name\" not found");
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
      contactBadges.add(ContactBadge(contact));
    }
    return contactBadges;
  }

  ContactBadge getContactBadgeAtIndex(final int index) {
    return ContactBadge(listOfContacts[index]);
  }
}
