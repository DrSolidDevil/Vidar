import "package:flutter/material.dart";
import "package:vidar/widgets/contact_badge.dart";

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
