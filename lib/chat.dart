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
      body: Conversation(contact),
    );
  }
}




class Conversation extends StatefulWidget {
  const Conversation(this.contact, {super.key});
  final Contact contact;

  @override
  createState() => _ConversationState();
}



class _ConversationState extends State<Conversation> {
  _ConversationState();
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


