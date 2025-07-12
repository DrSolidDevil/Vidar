import "package:flutter/material.dart";
import "package:go_router/go_router.dart";
import "package:vidar/pages/contact_list.dart";
import "package:vidar/utils/common_object.dart";
import "package:vidar/utils/contact.dart";
import "package:vidar/utils/navigation.dart";
import "package:vidar/utils/settings.dart";
import "package:vidar/widgets/conversation_widget.dart";
import "package:vidar/widgets/message_bar.dart";

class ChatPage extends StatefulWidget {
  const ChatPage({super.key});

  @override
  _ChatPageState createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  _ChatPageState();
  Contact contact = CommonObject.currentContact!;

  @override
  void initState() {
    super.initState();
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
            context.goNamed("ContactListPage");
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
              CommonObject.currentContact = contact;
              context.goNamed(
                "EditContactPage",
                pathParameters: {"caller": "chatPage"},
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
