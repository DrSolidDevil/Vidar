import 'package:flutter/material.dart';
import 'package:vidar/pages/contacts.dart';
import 'package:vidar/pages/settings.dart';
import 'package:vidar/save.dart';



class ShutdownHandler extends WidgetsBindingObserver {
  ShutdownHandler(this.settings, this.contactList);
  final Settings settings;
  final ContactList contactList;

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    print('App state changed: $state');
    if (state == AppLifecycleState.detached) {
      saveData(contactList, settings);
    }
  }
}