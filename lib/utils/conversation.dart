import "package:flutter/material.dart";
import "package:vidar/utils/contact.dart";
import "package:vidar/utils/popup_handler.dart";
import "package:vidar/utils/sms.dart";
import "package:vidar/widgets/error_popup.dart";

class Conversation extends ChangeNotifier {
  Conversation(this.contact) {
    smsNotifier = SmsNotifier();
    smsNotifier.addListener(notifyListeners);
  }

  final Contact contact;
  late List<SmsMessage> chatLogs;
  late final SmsNotifier smsNotifier;

  Future<void> updateChatLogs() async {
    final List<SmsMessage?> updatedChatLogs = (await querySms(
      phoneNumber: contact.phoneNumber,
    )).toList();
    if (updatedChatLogs[0] == null) {
      // this is a stupid operation since there are no null elements but it makes the compiler shut up
      chatLogs = updatedChatLogs.whereType<SmsMessage>().toList();
    } else {
      PopupHandler.popup = const ErrorPopup(
        title: "Failed to update chat logs",
        body: "updatedChatLogs=[null]",
        enableReturn: false,
      );
      PopupHandler.showPopup = true;
      PopupHandler.popupUpdater.update();
    }
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
