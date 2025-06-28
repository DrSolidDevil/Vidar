import "package:flutter/material.dart";
import "package:vidar/configuration.dart";
import "package:vidar/utils/contact.dart";
import "package:vidar/utils/conversation.dart";
import "package:vidar/utils/encryption.dart";
import "package:vidar/utils/sms.dart";
import "package:vidar/widgets/speech_bubble.dart";

class ConversationWidget extends StatefulWidget {
  const ConversationWidget(this.contact, {super.key});
  final Contact contact;

  @override
  _ConversationWidgetState createState() => _ConversationWidgetState();
}

class _ConversationWidgetState extends State<ConversationWidget> {
  _ConversationWidgetState();
  late Contact contact;
  late Conversation conversation;
  bool chatLoaded = false;
  String loadMessage = "Loading...";

  @override
  void initState() {
    super.initState();
    contact = widget.contact;
    conversation = Conversation(contact);
  }

  @override
  Widget build(final BuildContext context) {
    debugPrint("Querying sms for ${contact.name}...");
    // ignore: discarded_futures
    querySms(phoneNumber: contact.phoneNumber).then((
      final List<SmsMessage>? queryResponse,
    ) {
      if (queryResponse == null) {
        loadMessage =
            "SMS query failed, please ensure the phone number is correct.";
        debugPrint(
          "SMS query failed, please ensure the phone number is correct.",
        );
      } else {
        final List<SmsMessage> chatLogs = queryResponse.toList();
        conversation.chatLogs = <SmsMessage>[];
        for (final SmsMessage chat in chatLogs) {
          if (chat.status == SmsConstants.STATUS_FAILED) {
            conversation.chatLogs.add(chat.clone(newBody: "MESSAGE_FAILED"));
          } else {
            conversation.chatLogs.add(chat);
          }
        }
        chatLoaded = true;
        debugPrint("Sms query complete");
      }
      conversation.externalNotify();
    });

    return ListenableBuilder(
      listenable: conversation,
      builder: (final BuildContext context, final Widget? child) {
        if (!chatLoaded) {
          debugPrint("Chat not loaded");
          return ColoredBox(
            color: VidarColors.primaryDarkSpaceCadet,
            child: Center(
              child: SizedBox(
                width: MediaQuery.of(context).size.width * 0.6,
                child: Center(
                  child: Text(
                    loadMessage,
                    style: const TextStyle(fontSize: 20, color: Colors.white),
                  ),
                ),
              ),
            ),
          );
        }
        debugPrint("Chat loaded");
        final List<SmsMessage> messages = conversation.chatLogs;
        final List<Widget> decryptedSpeechBubbles = <Widget>[];
        for (final SmsMessage message in messages) {
          decryptedSpeechBubbles.add(
            FutureBuilder<String>(
              future: decryptMessage(message.body, contact.encryptionKey),
              builder:
                  (
                    final BuildContext context,
                    final AsyncSnapshot<String?> snapshot,
                  ) {
                    if (snapshot.hasData) {
                      return SpeechBubble(
                        message.clone(newBody: snapshot.data),
                      );
                    } else {
                      debugPrint("Snapshot has no data, body: ${message.body}");
                    }
                    return const SizedBox.shrink();
                  },
            ),
          );
        }
        return ColoredBox(
          color: VidarColors.primaryDarkSpaceCadet,
          child: ListView(reverse: true, children: decryptedSpeechBubbles),
        );
      },
    );
  }
}
