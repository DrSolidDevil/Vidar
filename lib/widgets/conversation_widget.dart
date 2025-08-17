import "package:flutter/material.dart";
import "package:vidar/configuration.dart";
import "package:vidar/utils/common_object.dart";
import "package:vidar/utils/contact.dart";
import "package:vidar/utils/conversation.dart";
import "package:vidar/utils/settings.dart";
import "package:vidar/widgets/info_text_widget.dart";
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
  bool chatLoaded = false;
  String loadMessage = "Loading...";

  @override
  void initState() {
    super.initState();
    contact = widget.contact;
    CommonObject.currentConversation = Conversation(contact);
  }

  @override
  void dispose() {
    CommonObject.currentConversation?.dispose();
    super.dispose();
  }

  @override
  Widget build(final BuildContext context) {
    if (LoggingConfiguration.extraVerboseLogs && Settings.keepLogs) {
      CommonObject.logger!.info("Querying sms for contact ${contact.uuid}...");
    }
    return ListenableBuilder(
      listenable: CommonObject.currentConversation!,
      builder: (final BuildContext context, final Widget? child) {
        return FutureBuilder<ConversationStatus>(
          future: CommonObject.currentConversation!.updateChatLogs(latestN: 5),
          builder:
              (
                final BuildContext context,
                final AsyncSnapshot<ConversationStatus> snapshot,
              ) {
                if (!snapshot.hasData) {
                  return ChatLoadingScreen(contact.name);
                } else {
                  // snapshot.data == [null] does not work
                  switch (snapshot.data) {
                    case ConversationStatus.FAILURE:
                      if (Settings.keepLogs) {
                        CommonObject.logger!.info(
                          "SMS query failed for contact ${contact.uuid}",
                        );
                      }
                      return const InfoText(
                        text:
                            "SMS query failed, please ensure the phone number is correct.",
                        textWidthFactor: 0.8,
                        fontSize: 20,
                      );

                    case ConversationStatus.SUCCESS:
                      if (LoggingConfiguration.extraVerboseLogs &&
                          Settings.keepLogs) {
                        CommonObject.logger!.info(
                          "SMS query complete for contact ${contact.uuid}",
                        );
                      }
                      return ColoredBox(
                        color: Settings.colorSet.primary,
                        child: ListView.builder(
                          reverse: true,
                          itemCount:
                              CommonObject.currentConversation!.chatLogsLength,
                          itemBuilder:
                              (final BuildContext context, final int index) =>
                                  SpeechBubble(
                                    CommonObject
                                        .currentConversation!
                                        .decryptedChatLogs[index],
                                  ),
                        ),
                      );

                    default:
                      if (Settings.keepLogs) {
                        CommonObject.logger!.info(
                          "Unexpected case (${snapshot.data}) when loading chat logs for contact ${contact.uuid}",
                        );
                      }
                      return InfoText(
                        text:
                            "Unexpected case (${snapshot.data}) when loading chat logs",
                        textWidthFactor: 0.6,
                      );
                  }
                }
              },
        );
      },
    );
  }
}
