import "package:vidar/pages/contacts.dart" show Contact, ContactList;
import "package:vidar/pages/settings.dart";

class CommonObject {
  static ContactList contactList = ContactList(<Contact>[]);
  static Settings settings = Settings();
}
