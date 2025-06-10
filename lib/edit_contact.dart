import 'package:flutter/material.dart';
import 'package:vidar/chat.dart';
import 'contacts.dart';
import 'configuration.dart';


class EditContactPage extends StatefulWidget {
  const EditContactPage(this.contact, this.contactList, this.caller, {super.key});
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
  Widget build(BuildContext context) {
    return Container(
      color: VidarColors.primaryDarkSpaceCadet,
      child: Column(
        children: [
          Column(
            children: [
              Container(
                margin: EdgeInsets.only(left: 50, right: 50, top: 30, bottom: 30),
                child: Material(
                  child: Container(
                    decoration: BoxDecoration(
                      color: VidarColors.secondaryMetallicViolet,
                    ),
                    padding: EdgeInsets.only(left: 10),
                    child: TextField(
                      decoration: InputDecoration(
                        hintText: "Name",
                        hintStyle: const TextStyle(
                          color: Colors.white,
                        ),
                        border: InputBorder.none,
                      ),
                      style: const TextStyle(
                        color: Colors.white,
                      ),
                      onChanged: (String value) {
                            newName = value;
                      },
                    ),
                  ),
                ),
              ),
              Container(
                margin: EdgeInsets.only(left: 50, right: 50, top: 30, bottom: 30),
                child: Material(
                  child: Container(
                    decoration: BoxDecoration(
                      color: VidarColors.secondaryMetallicViolet,
                    ),
                    padding: EdgeInsets.only(left: 10),
                    child: TextField(
                      decoration: InputDecoration(
                        hintText: "Encryption Key",
                        hintStyle: const TextStyle(
                          color: Colors.white,
                        ),
                        border: InputBorder.none,
                      ),
                      style: const TextStyle(
                        color: Colors.white,
                      ),
                      onChanged: (String value) {
                        newKey = value;
                      },
                    ),
                  ),
                ),
              ),
              Container(
                margin: EdgeInsets.only(left: 50, right: 50, top: 30, bottom: 30),
                child: Material(
                  child: Container(
                    decoration: BoxDecoration(
                      color: VidarColors.secondaryMetallicViolet,
                    ),
                    padding: EdgeInsets.only(left: 10),
                    child: TextField(
                      decoration: InputDecoration(
                        hintText: "Phone Number",
                        hintStyle: const TextStyle(
                          color: Colors.white,
                        ),
                        border: InputBorder.none,
                      ),
                      style: TextStyle(
                        color: Colors.white,
                      ),
                      onChanged: (String value) {
                        newPhoneNumber = value;
                      },
                    ),
                  ),
                ),
              )
            ],
          ),
          Container(
            margin: EdgeInsets.only(top: 20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Material(
                  child: InkWell(
                    child: SizedBox(
                      width: 100,
                      height: 50,
                      child: Container(
                        alignment: Alignment.center,
                        color: VidarColors.secondaryMetallicViolet,
                        child: Text(
                          "Discard",
                          style: TextStyle(
                            fontSize: 24,
                            color: Colors.white
                          ),
                        ),
                      ),
                    ),
                    onTap: () {
                      switch (caller.toLowerCase()) {
                        case "chatpage":
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => ChatPage(contact, contactList)),
                          );
                        case "contactpage":
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => ContactListPage(contactList)),
                          );
                        case "newcontact":
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => ContactListPage(contactList)),
                          );
                      }
                    },
                  ),
                ),

                Material(
                  child: InkWell(
                    child: SizedBox(
                      width: 100,
                      height: 50,
                      child: Container(
                        alignment: Alignment.center,
                        color: VidarColors.secondaryGold,
                        child: Text(
                          "Save",
                          style: TextStyle(
                            fontSize: 24,
                            color: Colors.white
                          ),
                        ),
                      ),
                    ),
                    onTap: () {
                      if (newName == "") {newName = null;}
                      if (newKey == "") {newKey = null;}
                      if (newPhoneNumber == "") {newPhoneNumber = null;}

                      contact.name = newName ?? contact.name;
                      contact.encryptionKey = newKey ?? contact.encryptionKey;
                      contact.phoneNumber = newPhoneNumber ?? contact.phoneNumber;
                      print("contact.name="+contact.name);
                      print("contact.encryptionKey="+contact.encryptionKey);
                      print("contact.phoneNumber="+contact.phoneNumber);

                      switch (caller.toLowerCase()) {
                        case "chatpage":
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => ChatPage(contact, contactList)),
                          );
                        case "contactpage":
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => ContactListPage(contactList)),
                          );
                        case "newcontact":
                          // Remove all non-numeric characters
                          newPhoneNumber = newPhoneNumber?.replaceAll(RegExp(r"[^\d]"), "");
                          if (isInvalidContactByParams(newName, newKey, newPhoneNumber)) {
                            showDialog(
                              context: context, 
                              builder: (BuildContext context) {
                                return AlertDialog(
                                  title: const Text("Missing details"),
                                  content: const Text("Please enter all details to create a new contact"),
                                  actions: [
                                    TextButton(
                                      onPressed: () {
                                        Navigator.push(
                                          context,
                                            MaterialPageRoute(builder: (context) => ContactListPage(contactList)),
                                        );
                                      }, 
                                      child: const Text("OK")
                                    )
                                  ],
                                );
                              }
                            );
                          } else {
                            contactList.addContactByParams(newName!, newKey!, newPhoneNumber!);
                            print("goto page");
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => ContactListPage(contactList)),
                            );
                          }
                      }
                    },
                  ),
                )
              ],
            ),
          )
        ]          
      )
    );
  }
}

/*
Scaffold(
      body: Material(
        child: Container(
          color: VidarColors.primaryDarkSpaceCadet,
          child: ListView(
            children: [
              Container(
                color: Colors.white,
                child: Row(
                  children: [
                    Text("Name"),
                    TextField(
                      onSubmitted: (String value) {
                        newName = value;
                      },
                    )
                  ],
                ),
              ),
              /// Formatting is irrelevant for the phone number, all non number characters will be removed if saved
              Row(
                children: [
                  Text("Encryption Key"),
                  TextField(
                    onSubmitted: (String value) {
                      newKey = value;
                    },
                  )
                ],
              ),
          
              Row(
                children: [
                  Text("Phone Number"),
                  TextField(
                    onSubmitted: (String value) {
                      newPhoneNumber = value;
                    },
                  )
                ],
              ),
          
              SaveOrDiscard(contact, contactList, caller, newName, newKey, newPhoneNumber)
            ],
          ),
        ),
      ),
    );
    
     */
/*
class SaveOrDiscard extends StatefulWidget {
  const SaveOrDiscard(this.contact, this.contactList, this.caller, this.newName, this.newKey, this.newPhoneNumber, {super.key});
  final Contact contact;
  final ContactList contactList;
  final String caller;
  final String? newName;
  final String? newKey;
  final String? newPhoneNumber;
  

  @override
  createState() => _SaveOrDiscardState();
}


class _SaveOrDiscardState extends State<SaveOrDiscard> {
  _SaveOrDiscardState();
  late Contact contact;
  late ContactList contactList;
  late String caller;

  late String? newName;
  late String? newKey;
  late String? newPhoneNumber;

  @override
  void initState() {
    super.initState();
    contact = widget.contact;
    contactList = widget.contactList;
    caller = widget.caller;
    newName = widget.newName;
    newKey = widget.newKey;
    newPhoneNumber = widget.newPhoneNumber;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        
        children: [
          Material(
            child: InkWell(
              child: SizedBox(
                width: 100,
                height: 50,
                child: Container(
                  alignment: Alignment.center,
                  color: VidarColors.secondaryMetallicViolet,
                  child: Text(
                    "Discard",
                    style: TextStyle(
                      fontSize: 24,
                      color: Colors.white
                    ),
                  ),
                ),
              ),
              onTap: () {
                switch (caller.toLowerCase()) {
                  case "chatpage":
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => ChatPage(contact, contactList)),
                    );
                  case "contactpage":
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => ContactListPage(contactList)),
                    );
                }
              },
            ),
          ),

          Material(
            child: InkWell(
              child: SizedBox(
                width: 100,
                height: 50,
                child: Container(
                  alignment: Alignment.center,
                  color: VidarColors.secondaryGold,
                  child: Text(
                    "Save",
                    style: TextStyle(
                      fontSize: 24,
                      color: Colors.white
                    ),
                  ),
                ),
              ),
              onTap: () {
                if (newName == "") {newName = null;}
                if (newKey == "") {newKey = null;}
                if (newPhoneNumber == "") {newPhoneNumber = null;}

                contact.name = newName ?? contact.name;
                contact.encryptionKey = newKey ?? contact.encryptionKey;
                contact.phoneNumber = newPhoneNumber ?? contact.phoneNumber;
                print("contact.name="+contact.name);
                print("contact.encryptionKey="+contact.encryptionKey);
                print("contact.phoneNumber="+contact.phoneNumber);

                switch (caller.toLowerCase()) {
                  case "chatpage":
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => ChatPage(contact, contactList)),
                    );
                  case "contactpage":
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => ContactListPage(contactList)),
                    );
                }
              },
            ),
          )
        ],
      ),
    );
  }
  
}







*/
