import "package:logging/logging.dart";
import "package:vidar/utils/contact.dart";
import "package:vidar/utils/conversation.dart";
import "package:vidar/utils/settings.dart";

class CommonObject {
  static ContactList contactList = ContactList(<Contact>[]);
  static Settings settings = Settings();
  static Logger? logger;
  static List<String> logs = <String>[];

  static Conversation? currentConversation;
}
