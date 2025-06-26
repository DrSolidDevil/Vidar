import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:vidar/configuration.dart';
import 'package:vidar/errorpopup.dart';
import 'package:vidar/pages/contacts.dart';
import 'package:vidar/pages/settings.dart';
import 'package:vidar/popuphandler.dart';

Future<void> saveData(ContactList contactList, Settings settings) async {
  try {
    print("Saving data...");

    final prefs = await SharedPreferences.getInstance();

    final jsonContacts = <String>[];
    for (final contact in contactList.listOfContacts) {
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
        title: "Failed to load data", 
        body: "$error", 
        enableReturn: false
      );
      PopupHandler.showPopup = true;
      PopupHandler.popupUpdater.update();
    }
    print("Loading data failed: $error");
    print("Stacktrace:\n$stackTrace");
  }
}

Future<void> loadData(ContactList contactList, Settings settings) async {
  try {
    print("Loading data...");

    final prefs = await SharedPreferences.getInstance();

    final jsonContacts = prefs.getStringList("contacts") ?? [];
    print("Contacts: $jsonContacts");
    final jsonSettings = prefs.getString("settings");
    print("Settings: $jsonSettings");
    final listOfContacts = <Contact>[];

    for (final jsonContact in jsonContacts) {
      listOfContacts.add(Contact.fromMap(jsonDecode(jsonContact) as Map<String, dynamic>));
    }

    contactList.listOfContacts = listOfContacts;
    if (jsonSettings != null) {
      settings.fromMap(jsonDecode(jsonSettings) as Map<String, dynamic>);
    } else {
      print("Could not fetch settings");
    }

    print("Data loaded");
  } catch (error, stackTrace) {
    if (ErrorHandlingConfiguration.reportErrorOnFailedLoad) {
      PopupHandler.popup = ErrorPopup(
        title: "Failed to load data", 
        body: "$error", 
        enableReturn: false
      );
      PopupHandler.showPopup = true;
      PopupHandler.popupUpdater.update();
    }
    print("Loading data failed: $error");
    print("Stacktrace:\n$stackTrace");
  }
}
