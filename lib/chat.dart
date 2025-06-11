import 'package:flutter/material.dart';
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
      body: ConversationWidget(contact),
      bottomNavigationBar: MesssageBar(contact),
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
  }

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: conversation, 
      builder: (context, child) {
        return ListView(
          children: conversation.getSpeechBubbles(),
        );
      }
    );
  }
}

class Conversation extends ChangeNotifier {
  Conversation(this.contact) {
    // Insert message retrival code
  }
  final Contact contact;

  late List<Message> chatLogs;

  List<SpeechBubble> getSpeechBubbles() {
    List<SpeechBubble> speechBubbles = [];
    for (final message in chatLogs) {
      bool isMe = message.sender != contact.name;
      speechBubbles.add(SpeechBubble(message, isMe));
    }
    return speechBubbles;
  }
  

}

class Message {
  const Message(this.content, this.sender, this.time);
  final String content;
  final String sender;
  final DateTime time;
}

class MessageWidget extends StatelessWidget {
  const MessageWidget(this.message, this.isMe, {super.key});
  final Message message;
  final bool isMe;

  @override
  Widget build(BuildContext context) {
    return Container();
  }
}

class MesssageBar extends StatefulWidget {
  const MesssageBar(this.contact, {super.key});
  final Contact contact;

  @override
  createState() => _MesssageBarState();
}



class _MesssageBarState extends State<MesssageBar> {
  _MesssageBarState();
  late Contact contact;

  @override
  void initState() {
    super.initState();
    contact = widget.contact;
  }

  @override
  Widget build(BuildContext context) {
    return Container();
  }
}


class SpeechBubble extends StatelessWidget {
  const SpeechBubble(this.message, this.isMe, {super.key});
  final Message message;
  final bool isMe;

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: isMe ? Alignment.centerRight : Alignment.centerLeft,
      child: Column(
        children: [
          Container(
            margin: EdgeInsets.symmetric(vertical: 5, horizontal: 10),
            padding: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
            decoration: BoxDecoration(
              color: isMe ? VidarColors.secondaryMetallicViolet : VidarColors.tertiaryGold,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(10),
                topRight: Radius.circular(10),
                bottomLeft: Radius.circular(isMe ? 10 : 0),
                bottomRight: Radius.circular(isMe ? 0 : 10),
              ),
            ),
            child: Text(
              message.content,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 12,
              ),
            ),
          ),
          Text(
            (isMe ? "Sent at " : "Recived at ") + message.time.toIso8601String().replaceRange(0, 11, ""),
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

