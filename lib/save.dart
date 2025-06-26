import 'package:vidar/configuration.dart';
import 'package:vidar/errorpopup.dart';
import 'package:vidar/popuphandler.dart';

import 'pages/contacts.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'pages/settings.dart';
import 'dart:convert';

void saveData(ContactList contactList, Settings settings) async {
  try {
    print("Saving data...");

    final SharedPreferences prefs = await SharedPreferences.getInstance();

    final List<String> jsonContacts = [];
    for (final Contact contact in contactList.listOfContacts) {
      jsonContacts.add(jsonEncode(contact.toMap()));
      print("contact:" + jsonEncode(contact.toMap()));
    }

    await prefs.setStringList("contacts", jsonContacts);
    await prefs.setString("settings", jsonEncode(settings.toMap()));
    print("settings:" +jsonEncode(settings.toMap()));

    print("Data saved");
  } catch (error, stackTrace) {
    if (ErrorHandlingConfiguration.reportErrorOnFailedSave) {
      PopupHandler.popup = ErrorPopup(
        "Failed to load data", 
        "$error", 
        false
      );
      PopupHandler.showPopup = true;
      PopupHandler.popupUpdater.update();
    }
    print("Loading data failed: $error");
    print("Stacktrace:\n$stackTrace");
  }
}

void loadData(ContactList contactList, Settings settings) async {
  try {
    print("Loading data...");

    final SharedPreferences prefs = await SharedPreferences.getInstance();

    final List<String> jsonContacts = prefs.getStringList("contacts") ?? [];
    print("Contacts: $jsonContacts");
    final String? jsonSettings = prefs.getString("settings");
    print("Settings: $jsonSettings");
    final List<Contact> listOfContacts = [];

    for (final String jsonContact in jsonContacts) {
      listOfContacts.add(Contact.fromMap(jsonDecode(jsonContact)));
    }

    contactList.listOfContacts = listOfContacts;
    if (jsonSettings != null) {
      settings.fromMap(jsonDecode(jsonSettings));
    } else {
      print("Could not fetch settings");
    }

    print("Data loaded");
  } catch (error, stackTrace) {
    if (ErrorHandlingConfiguration.reportErrorOnFailedLoad) {
      PopupHandler.popup = ErrorPopup(
        "Failed to load data", 
        "$error", 
        false
      );
      PopupHandler.showPopup = true;
      PopupHandler.popupUpdater.update();
    }
    print("Loading data failed: $error");
    print("Stacktrace:\n$stackTrace");
  }
}
