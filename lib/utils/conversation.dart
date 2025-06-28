import "package:flutter/material.dart";
import "package:vidar/utils/contact.dart";
import "package:vidar/utils/sms.dart";

class Conversation extends ChangeNotifier {
  Conversation(this.contact) {
    smsNotifier = SmsNotifier();
    smsNotifier.addListener(notifyListeners);
  }

  final Contact contact;
  late List<SmsMessage> chatLogs;
  late final SmsNotifier smsNotifier;

  Future<void> updateChatLogs() async {
    chatLogs = (await querySms(phoneNumber: contact.phoneNumber))!.toList();
    debugPrint("chatlogs updated");
    notifyListeners();
  }

  Future<void> closeConversation() async {
    smsNotifier.removeListener(notifyListeners);
  }

  void externalNotify() {
    debugPrint("External notify");
    notifyListeners();
  }
}
