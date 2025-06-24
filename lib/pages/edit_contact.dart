import 'package:flutter/material.dart';
import 'chat.dart';
import '../utils.dart';
import '../keys.dart';
import 'contacts.dart';
import '../configuration.dart';

class EditContactPage extends StatefulWidget {
  const EditContactPage(
    this.contact,
    this.contactList,
    this.caller, {
    super.key,
  });
  final Contact contact;
  final ContactList contactList;
  final String caller;

  @override
  createState() => _EditContactPageState();
}

class _EditContactPageState extends State<EditContactPage> {
  _EditContactPageState();
  late Contact contact;
  late ContactList contactList;
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
    contactList = widget.contactList;
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
  Widget build(BuildContext context) {
    return Container(
      color: VidarColors.primaryDarkSpaceCadet,
      child: Column(
        children: [
          Column(
            children: [
              Container(
                margin: EdgeInsets.only(
                  left: 50,
                  right: 50,
                  top: 30,
                  bottom: 30,
                ),
                child: Material(
                  color: VidarColors.secondaryMetallicViolet,
                  child: Container(
                    height: 50,
                    decoration: BoxDecoration(
                      color: VidarColors.secondaryMetallicViolet,
                    ),
                    padding: EdgeInsets.only(left: 10),
                    child: TextField(
                      decoration: InputDecoration(
                        hintText: "Name",
                        hintStyle: const TextStyle(color: Colors.white),
                        border: InputBorder.none,
                      ),
                      style: const TextStyle(color: Colors.white),
                      onChanged: (String value) {
                        newName = value;
                      },
                    ),
                  ),
                ),
              ),
              Container(
                margin: EdgeInsets.only(
                  left: 50,
                  right: 50,
                  top: 30,
                  bottom: 30,
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: Material(
                        color: VidarColors.secondaryMetallicViolet,
                        child: Container(
                          height: 50,
                          decoration: BoxDecoration(
                            color: VidarColors.secondaryMetallicViolet,
                          ),
                          padding: EdgeInsets.only(left: 10),
                          child: ListenableBuilder(
                            listenable: updater,
                            builder: (BuildContext context, Widget? child) {
                              return TextField(
                                controller: encryptionKeyController,
                                decoration: InputDecoration(
                                  hintText: "Encryption Key",
                                  hintStyle: const TextStyle(
                                    color: Colors.white,
                                  ),
                                  border: InputBorder.none,
                                ),
                                style: const TextStyle(color: Colors.white),
                                onChanged: (String value) {
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
                      margin: EdgeInsets.only(left: 10),
                      child: Expanded(
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
                          icon: Icon(
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
                margin: EdgeInsets.only(
                  left: 50,
                  right: 50,
                  top: 30,
                  bottom: 30,
                ),
                child: Material(
                  color: VidarColors.secondaryMetallicViolet,
                  child: Container(
                    height: 50,
                    decoration: BoxDecoration(
                      color: VidarColors.secondaryMetallicViolet,
                    ),
                    padding: EdgeInsets.only(left: 10),
                    child: TextField(
                      decoration: InputDecoration(
                        hintText: "Phone Number",
                        hintStyle: const TextStyle(color: Colors.white),
                        border: InputBorder.none,
                      ),
                      style: TextStyle(color: Colors.white),
                      onChanged: (String value) {
                        newPhoneNumber = value;
                      },
                    ),
                  ),
                ),
              ),
            ],
          ),
          Container(
            margin: EdgeInsets.only(top: 20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Material(
                  color: VidarColors.secondaryMetallicViolet,
                  child: InkWell(
                    child: SizedBox(
                      width: 100,
                      height: 50,
                      child: Container(
                        alignment: Alignment.center,
                        color: VidarColors.secondaryMetallicViolet,
                        child: Text(
                          "Discard",
                          style: TextStyle(fontSize: 24, color: Colors.white),
                        ),
                      ),
                    ),
                    onTap: () {
                      switch (caller.toLowerCase()) {
                        case "chatpage":
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  ChatPage(contact, contactList),
                            ),
                          );
                        case "contactpage":
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  ContactListPage(contactList),
                            ),
                          );
                        case "newcontact":
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  ContactListPage(contactList),
                            ),
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
                        child: Text(
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
                      contact.encryptionKey = newKey ?? contact.encryptionKey;
                      contact.phoneNumber =
                          newPhoneNumber ?? contact.phoneNumber;

                      switch (caller.toLowerCase()) {
                        case "chatpage":
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  ChatPage(contact, contactList),
                            ),
                          );
                        case "contactpage":
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  ContactListPage(contactList),
                            ),
                          );
                        case "newcontact":
                          // Remove all non-numeric characters
                          newPhoneNumber = newPhoneNumber?.replaceAll(
                            RegExp(r"[^\d]"),
                            "",
                          );
                          if (isInvalidContactByParams(
                            newName,
                            newKey,
                            newPhoneNumber,
                          )) {
                            showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return AlertDialog(
                                  title: const Text("Missing details"),
                                  content: const Text(
                                    "Please enter all details to create a new contact",
                                  ),
                                  actions: [
                                    TextButton(
                                      onPressed: () {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) =>
                                                ContactListPage(contactList),
                                          ),
                                        );
                                      },
                                      child: const Text("OK"),
                                    ),
                                  ],
                                );
                              },
                            );
                          } else {
                            contactList.addContactByParams(
                              newName!,
                              newKey!,
                              newPhoneNumber!,
                            );
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    ContactListPage(contactList),
                              ),
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
