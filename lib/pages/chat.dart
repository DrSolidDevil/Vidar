import "package:flutter/material.dart";
import "package:vidar/configuration.dart";
import "package:vidar/encrypt.dart";
import "package:vidar/pages/contacts.dart";
import "package:vidar/pages/edit_contact.dart";
import "package:vidar/sms.dart";
import "package:vidar/utils.dart";

class ChatPage extends StatefulWidget {
  const ChatPage(this.contact, {super.key});
  final Contact contact;

  @override
  _ChatPageState createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  _ChatPageState();
  late Contact contact;
  final Updater updater = Updater();

  @override
  void initState() {
    super.initState();
    contact = widget.contact;
  }

  @override
  Widget build(final BuildContext context) => Scaffold(
    appBar: AppBar(
      backgroundColor: VidarColors.secondaryMetallicViolet,
      title: Text(
        contact.name,
        style: const TextStyle(
          fontSize: 18,
          color: Colors.white,
          decoration: TextDecoration.none,
        ),
      ),

      leading: Container(
        margin: const EdgeInsets.only(left: 10),
        child: IconButton(
          onPressed: () {
            clearNavigatorAndPush(context, const ContactListPage());
          },
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          tooltip: "Go back",
        ),
      ),

      actions: <Widget>[
        Container(
          margin: const EdgeInsets.only(right: 10),
          child: IconButton(
            onPressed: () {
              clearNavigatorAndPush(
                context,
                EditContactPage(contact, "chatpage"),
              );
            },
            icon: const Icon(Icons.edit, color: Colors.white),
            tooltip: "Edit",
          ),
        ),
      ],
    ),
    body: ListenableBuilder(
      listenable: updater,
      builder: (final BuildContext context, final Widget? child) {
        return ConversationWidget(contact);
      },
    ),
    bottomNavigationBar: MessageBar(contact, updater),
  );
}

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

class MessageBar extends StatefulWidget {
  const MessageBar(this.contact, this.updater, {super.key});
  final Contact contact;
  final Updater updater;

  @override
  _MessageBarState createState() => _MessageBarState();
}

class _MessageBarState extends State<MessageBar> {
  _MessageBarState();
  late Contact contact;
  late Updater updater;
  String? message;
  bool error = false;
  String errorMessage = "";
  Updater failUpdater = Updater();

  @override
  void initState() {
    super.initState();
    contact = widget.contact;
    updater = widget.updater;
  }

  Widget buildErrorMessageWidget(
    final BuildContext context,
    final String text,
  ) {
    return ColoredBox(
      color: VidarColors.secondaryMetallicViolet,
      child: Row(
        children: <Widget>[
          Text(text, style: const TextStyle(color: Colors.white)),
          IconButton(
            onPressed: () => failUpdater.update,
            icon: const Icon(Icons.sms, color: Colors.white),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(final BuildContext context) {
    return ListenableBuilder(
      listenable: failUpdater,
      builder: (final BuildContext context, final Widget? child) {
        if (error) {
          error = false;
          Future<void>.delayed(
            const Duration(
              seconds: TimeConfiguration.messageWidgetErrorDisplayTime,
            ),
          ).then((_) => failUpdater.update());
          switch (errorMessage) {
            case "MESSAGE_FAILED":
              debugPrint("MESSAGE_FAILED");
              return buildErrorMessageWidget(context, "Failed to send message");
            case "NO_KEY":
              return buildErrorMessageWidget(
                context,
                "No key set for contact, either disable key requirement or set a key",
              );
            case "DECRYPTION_FAILED":
              return buildErrorMessageWidget(
                context,
                "Decryption of message failed, please ensure your key is correct",
              );
            case "ENCRYPTION_FAILED":
              return buildErrorMessageWidget(
                context,
                "Encryption of message failed",
              );
            default:
              return buildErrorMessageWidget(context, "Unknown error");
          }
        } else {
          return Container(
            color: VidarColors.tertiaryGold,
            padding: EdgeInsets.only(
              bottom: MediaQuery.of(context).viewInsets.bottom > 50
                  ? MediaQuery.of(context).viewInsets.bottom
                  : 50,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                Container(
                  decoration: BoxDecoration(
                    color: VidarColors.secondaryMetallicViolet,
                    borderRadius: BorderRadius.circular(4),
                  ),
                  padding: const EdgeInsets.only(left: 10),
                  width:
                      MediaQuery.sizeOf(context).width -
                      SizeConfiguration.sendMessageIconSize * 2.5,
                  child: TextField(
                    style: const TextStyle(color: Colors.white),
                    decoration: const InputDecoration(border: InputBorder.none),
                    onChanged: (final String value) => message = value,
                  ),
                ),
                SizedBox(
                  width: 50,
                  height: 60,
                  child: Center(
                    child: IconButton(
                      onPressed: () async {
                        debugPrint("Sending message: $message");
                        final String encryptedMessage = await encryptMessage(
                          message!,
                          contact.encryptionKey,
                        );
                        if (encryptedMessage.startsWith(
                          MiscellaneousConfiguration.errorPrefix,
                        )) {
                          errorMessage = encryptedMessage.replaceFirst(
                            MiscellaneousConfiguration.errorPrefix,
                            "",
                          );
                          error = true;
                          failUpdater.update();
                        } else {
                          sendSms(encryptedMessage, contact.phoneNumber);
                          await Future<void>.delayed(
                            const Duration(
                              seconds: TimeConfiguration.smsUpdateDelay,
                            ),
                          );
                          updater.update();
                        }
                      },
                      icon: const Icon(
                        size: SizeConfiguration.sendMessageIconSize,
                        Icons.send,
                        color: VidarColors.secondaryMetallicViolet,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          );
        }
      },
    );
  }
}

class SpeechBubble extends StatelessWidget {
  const SpeechBubble(this.message, {super.key});
  final SmsMessage message;

  @override
  Widget build(final BuildContext context) {
    final bool isMe = (message.type == SmsConstants.MESSAGE_TYPE_SENT);
    return Align(
      alignment: isMe ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: EdgeInsets.only(
          top: SizeConfiguration.messageVerticalSeperation,
          bottom: SizeConfiguration.messageVerticalSeperation,
          left: isMe ? 0 : SizeConfiguration.messageIndent,
          right: isMe ? SizeConfiguration.messageIndent : 0,
        ),
        child: Column(
          crossAxisAlignment: isMe
              ? CrossAxisAlignment.end
              : CrossAxisAlignment.start,
          children: <Widget>[
            ConstrainedBox(
              constraints: BoxConstraints(
                maxWidth: MediaQuery.of(context).size.width * 0.75,
              ),
              child: Container(
                padding: const EdgeInsets.symmetric(
                  vertical: 10,
                  horizontal: 10,
                ),
                decoration: BoxDecoration(
                  color: isMe
                      ? VidarColors.secondaryMetallicViolet
                      : VidarColors.tertiaryGold,
                  borderRadius: BorderRadius.only(
                    topLeft: const Radius.circular(10),
                    topRight: const Radius.circular(10),
                    bottomLeft: Radius.circular(isMe ? 10 : 0),
                    bottomRight: Radius.circular(isMe ? 0 : 10),
                  ),
                ),
                child: Text(
                  message.body,
                  style: const TextStyle(color: Colors.white, fontSize: 12),
                ),
              ),
            ),
            // Temporarily disabled until fix
            /*Container(
              margin: EdgeInsets.only(top: 2, bottom: 2),
              child: Text(
                (isMe ? "Sent at " : "Received at ") +
                    (isMe
                        ? message.dateSent!.toIso8601String().substring(11, 16)
                        : message.date!.toIso8601String().substring(11, 16)),
                style: const TextStyle(color: Colors.white, fontSize: 8),
              ),
            ),*/
          ],
        ),
      ),
    );
  }
}
