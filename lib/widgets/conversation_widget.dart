import "package:flutter/material.dart";
import "package:vidar/configuration.dart";
import "package:vidar/utils/common_object.dart";
import "package:vidar/utils/contact.dart";
import "package:vidar/utils/conversation.dart";
import "package:vidar/utils/encryption.dart";
import "package:vidar/utils/settings.dart";
import "package:vidar/utils/sms.dart";
import "package:vidar/widgets/loading_screen.dart";
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
  late Future<List<SmsMessage?>?> _smsFuture;

  @override
  void initState() {
    super.initState();
    contact = widget.contact;
    conversation = Conversation(contact);
    _smsFuture = querySms(phoneNumber: contact.phoneNumber);
  }

  @override
  Widget build(final BuildContext context) {
    if (LoggingConfiguration.extraVerboseLogs && Settings.keepLogs) {
      CommonObject.logger!.info("Querying sms for contact ${contact.uuid}...");
    }
    return FutureBuilder<List<SmsMessage?>?>(
      future: _smsFuture,
      builder:
          (
            final BuildContext context,
            final AsyncSnapshot<List<SmsMessage?>?> snapshot,
          ) {
            if (!snapshot.hasData) {
              return ChatLoadingScreen(contact.name);
            } else {
              // snapshot.data == [null] does not work
              if (snapshot.data![0] == null) {
                if (Settings.keepLogs) {
                  CommonObject.logger!.info(
                    "SMS query failed for contact ${contact.uuid}",
                  );
                }
                return ColoredBox(
                  color: VidarColors.primaryDarkSpaceCadet,
                  child: Center(
                    child: SizedBox(
                      width: MediaQuery.of(context).size.width * 0.6,
                      child: const Center(
                        child: Text(
                          "SMS query failed, please ensure the phone number is correct.",
                          style: TextStyle(fontSize: 20, color: Colors.white),
                        ),
                      ),
                    ),
                  ),
                );
              } else {
                final List<SmsMessage> chatLogs = snapshot.data!
                    .whereType<SmsMessage>()
                    .toList();
                conversation.chatLogs = <SmsMessage>[];
                for (final SmsMessage chat in chatLogs) {
                  if (chat.status == SmsConstants.STATUS_FAILED) {
                    conversation.chatLogs.add(
                      chat.clone(newBody: "MESSAGE_FAILED"),
                    );
                  } else {
                    conversation.chatLogs.add(chat);
                  }
                }
                if (LoggingConfiguration.extraVerboseLogs &&
                    Settings.keepLogs) {
                  CommonObject.logger!.info(
                    "SMS query complete for contact ${contact.uuid}",
                  );
                }
                return ListenableBuilder(
                  listenable: conversation,
                  builder: (final BuildContext context, final Widget? child) {
                    if (LoggingConfiguration.extraVerboseLogs &&
                        Settings.keepLogs) {
                      CommonObject.logger!.info(
                        "Chat loaded for contact ${contact.uuid}",
                      );
                    }
                    final List<SmsMessage> messages = conversation.chatLogs;
                    final List<Widget> decryptedSpeechBubbles = <Widget>[];
                    for (final SmsMessage message in messages) {
                      decryptedSpeechBubbles.add(
                        FutureBuilder<String>(
                          future: decryptMessage(
                            message.body,
                            contact.encryptionKey,
                          ),
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
                                  if (LoggingConfiguration.extraVerboseLogs &&
                                      Settings.keepLogs) {
                                    CommonObject.logger!.info(
                                      "Snapshot has not data for contact ${contact.uuid}",
                                    );
                                  }
                                }
                                return const SizedBox.shrink();
                              },
                        ),
                      );
                    }
                    return ColoredBox(
                      color: VidarColors.primaryDarkSpaceCadet,
                      child: ListView(
                        reverse: true,
                        children: decryptedSpeechBubbles,
                      ),
                    );
                  },
                );
              }
            }
          },
    );
  }
}
