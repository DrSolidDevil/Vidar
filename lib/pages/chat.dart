import '../sms.dart';

import '../encrypt.dart';
import 'package:flutter/material.dart';
import '../utils.dart';
import 'contacts.dart';
import '../configuration.dart';
import 'edit_contact.dart';

class ChatPage extends StatefulWidget {
  const ChatPage(this.contact, {super.key});
  final Contact contact;

  @override
  createState() => _ChatPageState();
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
  Widget build(BuildContext context) {
    return Scaffold(
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
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ContactListPage(),
                ),
              );
            },
            icon: const Icon(Icons.arrow_back, color: Colors.white),
            tooltip: "Go back",
          ),
        ),

        actions: [
          Container(
            margin: const EdgeInsets.only(right: 10),
            child: IconButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) =>
                        EditContactPage(contact, "chatpage"),
                  ),
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
        builder: (BuildContext context, Widget? child) {
          return ConversationWidget(contact);
        },
      ),
      bottomNavigationBar: MesssageBar(contact, updater),
    );
  }
}

class ConversationWidget extends StatefulWidget {
  const ConversationWidget(this.contact, {super.key});
  final Contact contact;

  @override
  createState() => _ConversationWidgetState();
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
  Widget build(BuildContext context) {
    print("Querying sms for ${contact.name}...");
    querySms(phoneNumber: contact.phoneNumber).then((queryResponse) {
      if (queryResponse == null) {
        loadMessage =
            "SMS query failed, please ensure the phone number is correct.";
        print("SMS query failed, please ensure the phone number is correct.");
      } else {
        conversation.chatLogs = queryResponse.toList();
        chatLoaded = true;
        print("Sms query complete");
      }
      conversation.externalNotify();
    });

    return ListenableBuilder(
      listenable: conversation,
      builder: (BuildContext context, Widget? child) {
        if (!chatLoaded) {
          print("Chat not loaded");
          return Container(
            color: VidarColors.primaryDarkSpaceCadet,
            child: Center(
              child: SizedBox(
                width: MediaQuery.of(context).size.width * 0.6,
                child: Center(
                  child: Text(
                    loadMessage,
                    style: TextStyle(fontSize: 20.0, color: Colors.white),
                  ),
                ),
              ),
            ),
          );
        }
        print("Chat loaded");
        List<SmsMessage> messages = conversation.chatLogs;
        List<Widget> decryptedSpeechBubbles = [];
        for (final message in messages) {
          decryptedSpeechBubbles.add(
            FutureBuilder(
              future: decryptMessage(message.body, contact.encryptionKey),
              builder: (BuildContext context, AsyncSnapshot snapshot) {
                if (snapshot.hasData) {
                  return SpeechBubble(message.clone(newBody: snapshot.data));
                } else {
                  print("Snapshot has no data, body: ${message.body}");
                }
                return SizedBox.shrink();
              },
            ),
          );
        }
        return Container(
          color: VidarColors.primaryDarkSpaceCadet,
          child: ListView(
            reverse: true,
            children: decryptedSpeechBubbles
          ),
        );
      },
    );
  }
}

class Conversation extends ChangeNotifier {
  final Contact contact;
  late List<SmsMessage> chatLogs;
  late final SmsNotifier smsNotifier;

  Conversation(this.contact) {
    smsNotifier = SmsNotifier();
    smsNotifier.addListener(notifyListeners);
  }

  void updateChatLogs() async {
    chatLogs = (await querySms(
      phoneNumber: contact.phoneNumber,
    ))!.toList();
    print("chatlogs updated");
    notifyListeners();
  }

  void closeConversation() async {
    smsNotifier.removeListener(notifyListeners);
  }

  void externalNotify() {
    print("External notify");
    notifyListeners();
  }
}

class MesssageBar extends StatefulWidget {
  const MesssageBar(this.contact, this.updater, {super.key});
  final Contact contact;
  final Updater updater;

  @override
  createState() => _MesssageBarState();
}

class _MesssageBarState extends State<MesssageBar> {
  _MesssageBarState();
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

  Widget buildErrorMessageWidget(BuildContext context, String text) {
    return Container(
      color: VidarColors.secondaryMetallicViolet,
      child: Row(
        children: [
          Text(text, style: TextStyle(color: Colors.white)),
          IconButton(
            onPressed: () => failUpdater.update,
            icon: Icon(Icons.sms, color: Colors.white),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: failUpdater,
      builder: (BuildContext context, Widget? child) {
        if (error) {
          error = false;
          Future.delayed(
            Duration(seconds: TimeConfiguration.messageWidgetErrorDisplayTime),
          ).then((value) => failUpdater.update());
          switch (errorMessage) {
            case "MESSAGE_FAILED":
              print("MESSAGE_FAILED");
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
            padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom > 50 ? MediaQuery.of(context).viewInsets.bottom : 50),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Container(
                  decoration: BoxDecoration(
                    color: VidarColors.secondaryMetallicViolet,
                    borderRadius: BorderRadius.circular(4.0),
                  ),
                  padding: EdgeInsets.only(left: 10),
                  width:
                      MediaQuery.sizeOf(context).width -
                      SizeConfiguration.sendMessageIconSize * 2.5,
                  child: TextField(
                    style: TextStyle(color: Colors.white),
                    decoration: InputDecoration(border: InputBorder.none),
                    onChanged: (value) => message = value,
                  ),
                ),
                SizedBox(
                  width: 50,
                  height: 60,
                  child: Center(
                    child: IconButton(
                      onPressed: () async {
                        print("Sending message: $message");
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
                          // On average it takes about 5 seconds for an sms to be sent
                          await Future.delayed(Duration(seconds: 5));
                          updater.update();
                          //await Future.delayed(Duration(seconds: 4));
                          //updater.update();
                        }
                      },
                      icon: Icon(
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
  Widget build(BuildContext context) {
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
          children: [
            ConstrainedBox(
              constraints: BoxConstraints(
                maxWidth: MediaQuery.of(context).size.width * 0.75,
              ),
              child: Container(
                padding: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                decoration: BoxDecoration(
                  color: isMe
                      ? VidarColors.secondaryMetallicViolet
                      : VidarColors.tertiaryGold,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(10),
                    topRight: Radius.circular(10),
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
