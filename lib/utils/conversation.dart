import "package:flutter/material.dart";
import "package:vidar/configuration.dart";
import "package:vidar/utils/common_object.dart";
import "package:vidar/utils/contact.dart";
import "package:vidar/utils/settings.dart";
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

  Future<void> updateChatLogs({final BuildContext? context}) async {
    final List<SmsMessage?> updatedChatLogs = (await querySms(
      phoneNumber: contact.phoneNumber,
    )).toList();
    if (updatedChatLogs[0] == null) {
      // this is a stupid operation since there are no null elements but it makes the compiler shut up
      chatLogs = updatedChatLogs.whereType<SmsMessage>().toList();
    } else {
      if (context != null && context.mounted) {
        showDialog<void>(
          context: context,
          builder: (final BuildContext context) => const ErrorPopup(
            title: "Failed to update chat logs",
            body: "updatedChatLogs=[null]",
            enableReturn: false,
          ),
        );
      }
      if (Settings.keepLogs) {
        CommonObject.logger!.info("Failed to update chat logs");
      }
    }
    if (LoggingConfiguration.extraVerboseLogs && Settings.keepLogs) {
      CommonObject.logger!.info(
        "Chat logs updated for contact ${contact.uuid}",
      );
    }
    notifyListeners();
  }

  Future<void> closeConversation() async {
    smsNotifier.removeListener(notifyListeners);
  }

  void externalNotify() {
    if (LoggingConfiguration.extraVerboseLogs && Settings.keepLogs) {
      CommonObject.logger!.info("External notify for contact ${contact.uuid}");
    }
    notifyListeners();
  }
}
