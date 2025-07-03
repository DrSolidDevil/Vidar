import "package:flutter/material.dart";
import "package:vidar/configuration.dart";
import "package:vidar/pages/contact_list.dart";
import "package:vidar/pages/edit_contact.dart";
import "package:vidar/utils/contact.dart";
import "package:vidar/utils/navigation.dart";
import "package:vidar/utils/updater.dart";
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
                EditContactPage(contact, ContactPageCaller.chatPage),
              );
            },
            icon: const Icon(Icons.edit, color: Colors.white),
            tooltip: "Edit",
          ),
        ),
      ],
    ),
    body: ConversationWidget(contact),
    bottomNavigationBar: MessageBar(contact),
  );
}
