import 'dart:async';
import 'encrypt.dart';
import 'package:flutter/material.dart';
import 'package:vidar/utils.dart';
import 'contacts.dart';
import 'configuration.dart';
import 'edit_contact.dart';


class ChatPage extends StatefulWidget {
  const ChatPage(this.contact, this.contactList, {super.key});
  final Contact contact;
  final ContactList contactList;

  @override
  createState() => _ChatPageState();
}



class _ChatPageState extends State<ChatPage> {
  _ChatPageState();
  late Contact contact;
  late ContactList contactList;
  final Updater updater = Updater();

  @override
  void initState() {
    super.initState();
    contact = widget.contact;
    contactList = widget.contactList;
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
            decoration: TextDecoration.none
          ),
        ),

        leading: Container(
          margin: const EdgeInsets.only(left: 10),
          child: IconButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => ContactListPage(contactList)),
              );
            }, 
            icon: const Icon(
              Icons.arrow_back,
              color: Colors.white,
            ),
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
                  MaterialPageRoute(builder: (context) => EditContactPage(contact, contactList, "chatpage")),
                );
              }, 
              icon: const Icon(
                Icons.edit,
                color: Colors.white,
              ),
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

  @override
  void initState() {
    super.initState();
    contact = widget.contact;
    conversation = Conversation(contact);
    conversation.chatLogs = [
      SmsMessage("010101", "hello", date: DateTime(2025, 2, 4, 4, 5, 12)), 
      SmsMessage("010101", "world", date: DateTime(2025, 2, 4, 7, 1, 3)), 
      SmsMessage("010101", "i am a text message", date: DateTime(2025, 2, 4, 7, 3, 10)), 
      SmsMessage("010101", "ts is a linter", date: DateTime(2025, 2, 4, 7, 10, 3)), 
      SmsMessage("010101", "flutter is weird", date: DateTime(2025, 2, 4, 8, 9, 8)), 
    ];
  }

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: conversation, 
      builder: (BuildContext context, Widget? child) {
        List<SmsMessage> messages = conversation.chatLogs;
        List<Widget> decryptedSpeechBubbles = [];
        for (final message in messages) {
          decryptedSpeechBubbles.add(
            FutureBuilder(
              future: decryptMessage(message.body!, contact.encryptionKey), 
              builder: (BuildContext context, AsyncSnapshot snapshot) {
                if (snapshot.hasData) {
                  return SpeechBubble(copySmsMessage(message, body: snapshot.data as String));
                }
                return SizedBox.shrink();
              }
            )
          );
        }
        return ListView(
          children: decryptedSpeechBubbles,
        );
      }
    );
  }
}

class Conversation extends ChangeNotifier {
  final Contact contact;
  late List<SmsMessage> chatLogs;
  late final StreamSubscription<SmsMessage> receiver;

  Conversation(this.contact) {
    print("Constructing conversation...");
    receiver = SmsReceiver().onSmsReceived!.listen(
      (SmsMessage message) {
        if (message.address == contact.phoneNumber) {
          notifyListeners();
        }
      }
    );
    print("updating chatlogs...");
    print("chatlogs updated");
  }
  
  Future<List<SpeechBubble>> getSpeechBubbles() async {
    List<SpeechBubble> speechBubbles = [];
    for (SmsMessage message in chatLogs) {
      speechBubbles.add(
        SpeechBubble(
          SmsMessage(
            contact.phoneNumber, 
            await encryptMessage(message.body!, contact.encryptionKey), 
            date: message.date,
            kind: message.kind,
            id: message.id,
            read: message.isRead
          )
        )
      );
    }
    return speechBubbles;
  }

  void updateChatLogs() async {
    chatLogs = await querySms(address: contact.phoneNumber);
    print("chatlogs updated");
    notifyListeners();
  }

  void closeConversation() async {
    await receiver.cancel();
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
  bool messageFail = false;
  Updater failUpdater = Updater();

  @override
  void initState() {
    super.initState();
    contact = widget.contact;
    updater = widget.updater;
  }

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: failUpdater,
      builder: (BuildContext context, Widget? child) {
        if (messageFail) {
          print("message failed");
          messageFail = false;
          return Container(
            color: VidarColors.secondaryMetallicViolet,
            child: Row(
              children: [
                Text(
                  "Failed to send message",
                  style: TextStyle(
                    color: Colors.white
                  ),
                ),
                IconButton(
                  onPressed: () => failUpdater.update, 
                  icon: Icon(
                    Icons.sms,
                    color: Colors.white,
                  )
                )
              ],
            ),
          );
        } else {
          return Container(
            color: VidarColors.tertiaryGold,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Container(
                  decoration: BoxDecoration(
                    color: VidarColors.secondaryMetallicViolet,
                    borderRadius: BorderRadius.circular(4.0)
                  ),
                  padding: EdgeInsets.only(left: 10),
                  width: MediaQuery.sizeOf(context).width - SizeConfiguration.sendMessageIconSize*2.5,
                  child: TextField(
                    style: TextStyle(
                      color: Colors.white
                    ),
                    decoration: InputDecoration(
                        border: InputBorder.none,
                    ),
                  ),
                ),
                SizedBox(
                  width: 50,
                  height: 60,
                  child: Center(
                    child: IconButton(
                      onPressed: () async {
                        SmsMessage smsMessage = SmsMessage(contact.phoneNumber, await encryptMessage(message!, contact.encryptionKey));
                        smsMessage.onStateChanged.listen(
                          (SmsMessageState state) {
                            if (state == SmsMessageState.Sent || state == SmsMessageState.Delivered) {
                              updater.update();
                            } else if (state == SmsMessageState.Fail) {
                              messageFail = true;
                    
                            }
                          } 
                        );
                      }, 
                      icon: Icon(
                        size: SizeConfiguration.sendMessageIconSize,
                        Icons.send,
                        color: VidarColors.secondaryMetallicViolet,
                      )
                    ),
                  ),
                )
              ],
            ),
          );
        } 
      }
    );
  }
}


class SpeechBubble extends StatelessWidget {
  const SpeechBubble(this.message, {super.key});
  final SmsMessage message;

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: (message.kind == SmsMessageKind.Sent) ? Alignment.centerRight : Alignment.centerLeft,
      child: Column(
        children: [
          Container(
            margin: EdgeInsets.symmetric(vertical: 5, horizontal: 10),
            padding: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
            decoration: BoxDecoration(
              color: (message.kind == SmsMessageKind.Sent) ? VidarColors.secondaryMetallicViolet : VidarColors.tertiaryGold,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(10),
                topRight: Radius.circular(10),
                bottomLeft: Radius.circular((message.kind == SmsMessageKind.Sent) ? 10 : 0),
                bottomRight: Radius.circular((message.kind == SmsMessageKind.Sent) ? 0 : 10),
              ),
            ),
            child: Text(
              
              message.body!,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 12,
              ),
            ),
          ),
          Text(
            ((message.kind == SmsMessageKind.Sent) ? "Sent at " : "Received at ") + message.date!.toIso8601String().replaceRange(0, 11, ""),
            style: const TextStyle(
              color: Colors.white,
              fontSize: 8,
            ),
          )
        ],
      )
    );
  }
}

