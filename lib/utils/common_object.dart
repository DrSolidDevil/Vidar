import "package:logging/logging.dart";
import "package:vidar/utils/contact.dart";
import "package:vidar/utils/conversation.dart";

class CommonObject {
  static ContactList contactList = ContactList(<Contact>[]);
  static Logger? logger;
  static List<String> logs = <String>[];
  static Conversation? currentConversation;
  static DateTime? lastLogon;
}
