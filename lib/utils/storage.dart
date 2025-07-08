import "dart:convert";
import "package:flutter/material.dart";
import "package:flutter_secure_storage/flutter_secure_storage.dart";
import "package:shared_preferences/shared_preferences.dart";
import "package:vidar/configuration.dart";
import "package:vidar/utils/common_object.dart";
import "package:vidar/utils/contact.dart";
import "package:vidar/utils/log.dart";
import "package:vidar/utils/settings.dart";
import "package:vidar/widgets/error_popup.dart";

Future<void> saveData(
  final ContactList contactList,
  final Settings settings, {
  final BuildContext? context,
}) async {
  try {
    if (LoggingConfiguration.extraVerboseLogs && Settings.keepLogs) {
      CommonObject.logger!.info("Saving data...");
    }

    final SharedPreferences prefs = await SharedPreferences.getInstance();

    final List<String> jsonContacts = <String>[];
    for (final Contact contact in contactList.listOfContacts) {
      jsonContacts.add(jsonEncode(contact.toMap()));
    }

    _saveKeys(contactList);
    saveSettings(settings, sharedPreferences: prefs);

    await prefs.setStringList("contacts", jsonContacts);

    if (LoggingConfiguration.extraVerboseLogs && Settings.keepLogs) {
      CommonObject.logger!.info("Data saved");
    }
  } on Exception catch (error, stackTrace) {
    if (context != null && context.mounted) {
      showDialog<void>(
        context: context,
        builder: (final BuildContext context) => ErrorPopup(
          title: "Failed to save data",
          body: "$error",
          enableReturn: false,
        ),
      );
    }
    if (Settings.keepLogs) {
      CommonObject.logger!.finest("Failed to save data ", error, stackTrace);
    }
  }
}

Future<void> loadData(
  final ContactList contactList,
  final Settings settings, {
  final BuildContext? context,
}) async {
  try {
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    final List<String> jsonContacts =
        prefs.getStringList("contacts") ?? <String>[];

    final String? jsonSettings = prefs.getString("settings");

    final List<Contact> listOfContacts = <Contact>[];

    for (final String jsonContact in jsonContacts) {
      listOfContacts.add(
        Contact.fromMap(jsonDecode(jsonContact) as Map<String, dynamic>),
      );
    }

    contactList.listOfContacts = listOfContacts;
    _loadKeys(contactList);

    if (jsonSettings != null) {
      settings.fromMap(jsonDecode(jsonSettings) as Map<String, dynamic>);
    }

    if (Settings.keepLogs) {
      createLogger();
    }
  } on Exception catch (error, stackTrace) {
    if (context != null && context.mounted) {
      showDialog<void>(
        context: context,
        builder: (final BuildContext context) => ErrorPopup(
          title: "Failed to load data",
          body: "$error",
          enableReturn: false,
        ),
      );
    }
    if (Settings.keepLogs) {
      CommonObject.logger!.finest("Failed to load data ", error, stackTrace);
    }
  }
}

/// Only saves settings, to save settings and contacts use [saveData]
Future<void> saveSettings(
  final Settings settings, {
  final SharedPreferences? sharedPreferences,
  final BuildContext? context,
}) async {
  try {
    final SharedPreferences prefs =
        sharedPreferences ?? await SharedPreferences.getInstance();
    await prefs.setString("settings", jsonEncode(settings.toMap()));
    if (Settings.keepLogs) {
      CommonObject.logger!.info("Settings: ${jsonEncode(settings.toMap())}");
    }
  } on Exception catch (error, stackTrace) {
    if (context != null && context.mounted) {
      showDialog<void>(
        context: context,
        builder: (final BuildContext context) => ErrorPopup(
          title: "Failed to save settings",
          body: "$error",
          enableReturn: false,
        ),
      );
    }
    if (Settings.keepLogs) {
      CommonObject.logger!.finest("Failed to save settings", error, stackTrace);
    }
  }
}

void wipeSecureStorage() => const FlutterSecureStorage().deleteAll();

// Only keys are stored encrypted because storing the rest of the information is pretty much worthless to an intruder.
Future<void> _saveKeys(final ContactList contactList) async {
  const FlutterSecureStorage storage = FlutterSecureStorage();

  if (LoggingConfiguration.extraVerboseLogs && Settings.keepLogs) {
    CommonObject.logger!.info("Saving keys...");
  }

  await storage.deleteAll(); // prevents keys of removed contacts remaining after contact is deleted
  for (final Contact contact in contactList.listOfContacts) {
    storage.write(key: contact.name, value: contact.encryptionKey);
  }

  if (LoggingConfiguration.extraVerboseLogs && Settings.keepLogs) {
    CommonObject.logger!.info("Keys saved");
  }
}

Future<void> _loadKeys(final ContactList contactList) async {
  final Map<String, String> allEncryptionKeys =
      await const FlutterSecureStorage().readAll();

  if (LoggingConfiguration.extraVerboseLogs && Settings.keepLogs) {
    CommonObject.logger!.info("Loading keys");
  }

  for (final MapEntry<String, String> encryptionKey
      in allEncryptionKeys.entries) {
    final bool success = contactList.modifyContactByName(
      encryptionKey.key,
      ContactListChangeType.encryptionKey,
      encryptionKey.value,
    );
    if (!success) {
      if (Settings.keepLogs) {
        CommonObject.logger!.finer("Failed to modify contact to have key");
      }
    }
  }
  if (LoggingConfiguration.extraVerboseLogs && Settings.keepLogs) {
    CommonObject.logger!.info("Keys loaded");
  }
}
