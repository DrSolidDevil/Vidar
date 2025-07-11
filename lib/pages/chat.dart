import "package:flutter/material.dart";
import "package:vidar/pages/contact_list.dart";
import "package:vidar/pages/edit_contact.dart";
import "package:vidar/utils/contact.dart";
import "package:vidar/utils/navigation.dart";
import "package:vidar/utils/settings.dart";
import "package:vidar/widgets/conversation_widget.dart";
import "package:vidar/widgets/message_bar.dart";

class ChatPage extends StatefulWidget {
  const ChatPage(this.contact, {super.key});
  final Contact contact;

  @override
  _ChatPageState createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  _ChatPageState();
  late Contact contact;

  @override
  void initState() {
    super.initState();
    contact = widget.contact;
  }

  @override
  Widget build(final BuildContext context) => Scaffold(
    appBar: AppBar(
      backgroundColor: Settings.colorSet.secondary,
      title: Text(
        contact.name,
        style: TextStyle(
          fontSize: 18,
          color: Settings.colorSet.text,
          decoration: TextDecoration.none,
        ),
      ),

      leading: Container(
        margin: const EdgeInsets.only(left: 10),
        child: IconButton(
          onPressed: () {
            clearNavigatorAndPush(context, const ContactListPage());
          },
          icon: Icon(Icons.arrow_back, color: Settings.colorSet.text),
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
                EditContactPage(contact, ContactPageCaller.chatPage),
              );
            },
            icon: Icon(Icons.edit, color: Settings.colorSet.text),
            tooltip: "Edit",
          ),
        ),
      ],
    ),
    body: ConversationWidget(contact),
    bottomNavigationBar: MessageBar(contact),
  );
}
