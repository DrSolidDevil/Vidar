import "package:flutter/material.dart";
import "package:vidar/configuration.dart";
import "package:vidar/pages/chat.dart";
import "package:vidar/pages/contact_list.dart";
import "package:vidar/utils/common_object.dart";
import "package:vidar/utils/contact.dart";
import "package:vidar/utils/navigation.dart";
import "package:vidar/utils/random_key.dart";
import "package:vidar/utils/settings.dart";
import "package:vidar/utils/storage.dart";
import "package:vidar/utils/updater.dart";

class EditContactPage extends StatefulWidget {
  const EditContactPage(this.contact, this.caller, {super.key});
  final Contact contact;
  final String caller;

  @override
  _EditContactPageState createState() => _EditContactPageState();
}

class _EditContactPageState extends State<EditContactPage> {
  _EditContactPageState();
  late Contact contact;
  late String caller;
  final Updater updater = Updater();
  final TextEditingController encryptionKeyController = TextEditingController();

  String? newName;
  String? newKey;
  String? newPhoneNumber;

  @override
  void initState() {
    super.initState();
    contact = widget.contact;
    caller = widget.caller;
  }

  @override
  void dispose() {
    // Clean up the controller when the widget is removed from the
    // widget tree.
    encryptionKeyController.dispose();
    super.dispose();
  }

  @override
  Widget build(final BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(top: 30),
      color: VidarColors.primaryDarkSpaceCadet,
      child: Column(
        children: <Widget>[
          Column(
            children: <Widget>[
              Container(
                margin: const EdgeInsets.only(
                  left: 50,
                  right: 50,
                  top: 30,
                  bottom: 30,
                ),
                child: Material(
                  color: VidarColors.secondaryMetallicViolet,
                  child: Container(
                    height: 50,
                    decoration: const BoxDecoration(
                      color: VidarColors.secondaryMetallicViolet,
                    ),
                    padding: const EdgeInsets.only(left: 10),
                    child: TextField(
                      decoration: const InputDecoration(
                        hintText: "Name",
                        hintStyle: TextStyle(color: Colors.white),
                        border: InputBorder.none,
                      ),
                      style: const TextStyle(color: Colors.white),
                      onChanged: (final String value) {
                        newName = value;
                      },
                    ),
                  ),
                ),
              ),
              Container(
                margin: const EdgeInsets.only(
                  left: 50,
                  right: 50,
                  top: 30,
                  bottom: 30,
                ),
                child: Row(
                  children: <Widget>[
                    SizedBox(
                      width:
                          MediaQuery.of(context).size.width -
                          160, // -100 for margins, -50 for button and -10 for button margin
                      height: 50,
                      child: Material(
                        color: VidarColors.secondaryMetallicViolet,
                        child: Container(
                          height: 50,
                          decoration: const BoxDecoration(
                            color: VidarColors.secondaryMetallicViolet,
                          ),
                          padding: const EdgeInsets.only(left: 10),
                          child: ListenableBuilder(
                            listenable: updater,
                            builder:
                                (
                                  final BuildContext context,
                                  final Widget? child,
                                ) {
                                  return TextField(
                                    controller: encryptionKeyController,
                                    decoration: InputDecoration(
                                      hintText:
                                          "Encryption Key${Settings.allowUnencryptedMessages ? ", 0=No Key" : ""}",
                                      hintStyle: const TextStyle(
                                        color: Colors.white,
                                      ),
                                      border: InputBorder.none,
                                    ),
                                    style: const TextStyle(color: Colors.white),
                                    onChanged: (final String value) {
                                      newKey = value;
                                    },
                                  );
                                },
                          ),
                        ),
                      ),
                    ),
                    Container(
                      height: 50,
                      margin: const EdgeInsets.only(left: 10),
                      child: SizedBox(
                        width: 50,
                        child: IconButton(
                          onPressed: () async {
                            newKey = await generateRandomKey();
                            encryptionKeyController.text = newKey ?? "";
                          },
                          style: IconButton.styleFrom(
                            backgroundColor:
                                VidarColors.secondaryMetallicViolet,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadiusGeometry.circular(10),
                            ),
                          ),
                          icon: const Icon(
                            Icons.change_circle_outlined,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              Container(
                margin: const EdgeInsets.only(
                  left: 50,
                  right: 50,
                  top: 30,
                  bottom: 30,
                ),
                child: Material(
                  color: VidarColors.secondaryMetallicViolet,
                  child: Container(
                    height: 50,
                    decoration: const BoxDecoration(
                      color: VidarColors.secondaryMetallicViolet,
                    ),
                    padding: const EdgeInsets.only(left: 10),
                    child: TextField(
                      decoration: const InputDecoration(
                        hintText: "Phone Number (international)",
                        hintStyle: TextStyle(color: Colors.white),
                        border: InputBorder.none,
                      ),
                      style: const TextStyle(color: Colors.white),
                      onChanged: (final String value) {
                        newPhoneNumber = value;
                      },
                    ),
                  ),
                ),
              ),
            ],
          ),
          Container(
            margin: const EdgeInsets.only(top: 20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                Material(
                  color: VidarColors.secondaryMetallicViolet,
                  child: InkWell(
                    child: SizedBox(
                      width: 100,
                      height: 50,
                      child: Container(
                        alignment: Alignment.center,
                        color: VidarColors.secondaryMetallicViolet,
                        child: const Text(
                          "Discard",
                          style: TextStyle(fontSize: 24, color: Colors.white),
                        ),
                      ),
                    ),
                    onTap: () {
                      switch (caller.toLowerCase()) {
                        case "chatpage":
                          clearNavigatorAndPush(context, ChatPage(contact));
                        case "contactpage":
                          clearNavigatorAndPush(
                            context,
                            const ContactListPage(),
                          );
                        case "newcontact":
                          clearNavigatorAndPush(
                            context,
                            const ContactListPage(),
                          );
                      }
                    },
                  ),
                ),

                Material(
                  color: VidarColors.tertiaryGold,
                  child: InkWell(
                    child: SizedBox(
                      width: 100,
                      height: 50,
                      child: Container(
                        alignment: Alignment.center,
                        color: VidarColors.tertiaryGold,
                        child: const Text(
                          "Save",
                          style: TextStyle(fontSize: 24, color: Colors.white),
                        ),
                      ),
                    ),
                    onTap: () {
                      if (newName == "") {
                        newName = null;
                      }
                      if (newKey == "") {
                        newKey = null;
                      }
                      if (newPhoneNumber == "") {
                        newPhoneNumber = null;
                      }

                      contact.name = newName ?? contact.name;

                      if (Settings.allowUnencryptedMessages && newKey == "0") {
                        contact.encryptionKey = "";
                      } else {
                        contact.encryptionKey = newKey ?? contact.encryptionKey;
                      }

                      // Remove all non-numeric characters
                      newPhoneNumber = newPhoneNumber?.replaceAll(
                        RegExp(r"[^\d+]"),
                        "",
                      );

                      contact.phoneNumber =
                          newPhoneNumber ?? contact.phoneNumber;
                      saveData(CommonObject.contactList, CommonObject.settings);

                      switch (caller.toLowerCase()) {
                        case "chatpage":
                          clearNavigatorAndPush(context, ChatPage(contact));
                        case "contactpage":
                          clearNavigatorAndPush(
                            context,
                            const ContactListPage(),
                          );
                        case "newcontact":
                          if (isInvalidContactByParams(
                            newName,
                            newKey,
                            newPhoneNumber,
                          )) {
                            // ignore: inference_failure_on_function_invocation
                            showDialog(
                              context: context,
                              builder: (final BuildContext context) {
                                return AlertDialog(
                                  title: const Text("Missing details"),
                                  content: const Text(
                                    "Please enter all details to create a new contact",
                                  ),
                                  actions: <Widget>[
                                    TextButton(
                                      onPressed: () {
                                        clearNavigatorAndPush(
                                          context,
                                          const ContactListPage(),
                                        );
                                      },
                                      child: const Text("OK"),
                                    ),
                                  ],
                                );
                              },
                            );
                          } else {
                            CommonObject.contactList.addContactByParams(
                              newName!,
                              newKey!,
                              newPhoneNumber!,
                            );
                            clearNavigatorAndPush(
                              context,
                              const ContactListPage(),
                            );
                          }
                      }
                    },
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
