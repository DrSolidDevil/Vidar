import "package:flutter/material.dart";
import "package:uuid/uuid.dart";
import "package:vidar/widgets/contact_badge.dart";

class Contact {
  Contact(this.name, this.encryptionKey, this.phoneNumber);

  factory Contact.fromMap(
    final Map<String, dynamic> map, {
    final bool withKey = false,
  }) {
    return Contact(
      map["name"]! as String,
      withKey ? map["encryptionKey"]! as String : "",
      map["phoneNumber"]! as String,
    );
  }

  // Used for anonymizing user logs
  final String uuid = const Uuid().v4();

  String name;
  String encryptionKey;
  String phoneNumber;

  Map<String, String> toMap({final bool withKey = false}) {
    final Map<String, String> map = <String, String>{
      "name": name,
      "phoneNumber": phoneNumber,
    };
    if (withKey) {
      map.addEntries(<String, String>{"encryptionKey": encryptionKey}.entries);
    }
    return map;
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
    // listOfContacts.firstWhere is written in dart so it's pointless to use it
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

  /// Returns true on success
  bool modifyContactByName(
    final String contactName,
    final ContactListChangeType changeType,
    final String newValue,
  ) {
    final int index = findContactIndexByName(contactName);
    if (index == -1) {
      return false;
    }
    switch (changeType) {
      case ContactListChangeType.name:
        listOfContacts[index].name = newValue;
        break;
      case ContactListChangeType.encryptionKey:
        listOfContacts[index].encryptionKey = newValue;
        break;
      case ContactListChangeType.phoneNumber:
        listOfContacts[index].phoneNumber = newValue;
        break;
    }
    notifyListeners();
    return true;
  }

  bool modifyContactByContact(
    final Contact contact,
    final ContactListChangeType changeType,
    final String newValue,
  ) {
    final int index = listOfContacts.indexOf(contact);
    if (index == -1) {
      return false;
    }
    switch (changeType) {
      case ContactListChangeType.name:
        listOfContacts[index].name = newValue;
      case ContactListChangeType.encryptionKey:
        listOfContacts[index].encryptionKey = newValue;
      case ContactListChangeType.phoneNumber:
        listOfContacts[index].phoneNumber = newValue;
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

  void wipeKeys() {
    for (final Contact contact in listOfContacts) {
      contact.encryptionKey = "";
    }
  }
}

enum ContactListChangeType { name, encryptionKey, phoneNumber }

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
