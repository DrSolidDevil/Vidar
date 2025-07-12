import "package:flutter/material.dart";
import "package:go_router/go_router.dart";
import "package:vidar/configuration.dart";
import "package:vidar/pages/contact_list.dart";
import "package:vidar/pages/contact_qr.dart";
import "package:vidar/utils/common_object.dart";
import "package:vidar/utils/contact.dart";
import "package:vidar/utils/generate_contact_uri.dart";
import "package:vidar/utils/navigation.dart";
import "package:vidar/utils/random_key.dart";
import "package:vidar/utils/settings.dart";
import "package:vidar/utils/storage.dart";
import "package:vidar/widgets/buttons.dart";
import "package:vidar/widgets/error_popup.dart";

class EditContactPage extends StatefulWidget {
  const EditContactPage(this.caller, {super.key});
  final String caller;

  @override
  _EditContactPageState createState() => _EditContactPageState();
}

class _EditContactPageState extends State<EditContactPage> {
  _EditContactPageState();
  Contact contact = CommonObject.currentContact!;
  late String caller;
  final TextEditingController encryptionKeyController = TextEditingController();

  String? newName;
  String? newKey;
  String? newPhoneNumber;

  @override
  void initState() {
    super.initState();
    caller = widget.caller;
    // If no phone number was provided to EditContactPage then
    // newKey and newPhoneNumber will be null and it will be as usual.
  }

  @override
  void dispose() {
    encryptionKeyController.dispose();
    super.dispose();
  }

  void discard() {
    switch (caller) {
      case "qrModify":
      case "newContact":
        context.goNamed("ContactListPage");
        break;
      case "chatPage":
        CommonObject.currentContact = contact;
        context.goNamed("ChatPage");
        break;
    }
  }

  void save() {
    if (Settings.keepLogs) {
      if (LoggingConfiguration.extraVerboseLogs &&
          caller == "newContact") {
        CommonObject.logger!.info("Saving new contact ${contact.uuid}...");
      } else {
        CommonObject.logger!.info("Editing contact ${contact.uuid}...");
      }
    }

    // Ensures non-edited settings are not changed.
    newName = newName == "" ? null : newName;
    newKey = newKey == "" ? null : newKey;
    newPhoneNumber = newPhoneNumber == "" ? null : newPhoneNumber;

    newName = newName ?? contact.name;

    if (Settings.allowUnencryptedMessages && newKey == "0") {
      if (LoggingConfiguration.extraVerboseLogs && Settings.keepLogs) {
        CommonObject.logger!.info("newKey is 0 -> no key");
      }
      newKey = "";
    } else {
      newKey = newKey ?? contact.encryptionKey;
    }

    // Remove all non-numeric characters
    newPhoneNumber = newPhoneNumber?.replaceAll(RegExp(r"[^\d]"), "");

    if (newPhoneNumber != null) {
      newPhoneNumber = "+$newPhoneNumber";
    } else if (caller == "chatPage") {
      newPhoneNumber = contact.phoneNumber;
    }

    saveData(CommonObject.contactList, CommonObject.settings);

    switch (caller) {
      case "qrModify":
      case "chatPage":
        if (isInvalidContactByParams(newName, newKey, newPhoneNumber)) {
          if (LoggingConfiguration.extraVerboseLogs && Settings.keepLogs) {
            CommonObject.logger!.info(
              "Invalid details for existing contact ${contact.uuid}",
            );
          }
          showDialog<void>(
            context: context,
            builder: (final BuildContext context) {
              return AlertDialog(
                title: const Text("Invalid details"),
                content: const Text("Please ensure edited details are correct"),
                actions: <Widget>[
                  TextButton(
                    onPressed: () {
                      context.goNamed("ContactListPage");
                    },
                    child: const Text("OK"),
                  ),
                ],
              );
            },
          );
        } else {
          contact.name = newName!;
          contact.encryptionKey = newKey!;
          contact.phoneNumber = newPhoneNumber!;
          CommonObject.currentContact = contact;
          context.goNamed("ChatPage");
        }

      case "newContact":
        if (isInvalidContactByParams(newName, newKey, newPhoneNumber)) {
          if (LoggingConfiguration.extraVerboseLogs && Settings.keepLogs) {
            CommonObject.logger!.info(
              "Invalid details for new contact ${contact.uuid}",
            );
          }
          showDialog<void>(
            context: context,
            builder: (final BuildContext context) {
              return AlertDialog(
                title: const Text("Invalid details"),
                content: const Text(
                  "Please enter all details correctly to create a new contact",
                ),
                actions: <Widget>[
                  TextButton(
                    onPressed: () {
                      context.goNamed("ContactListPage");
                    },
                    child: const Text("OK"),
                  ),
                ],
              );
            },
          );
        } else {
          final bool success = CommonObject.contactList.addContact(contact);
          if (Settings.keepLogs) {
            if (success) {
              if (LoggingConfiguration.extraVerboseLogs) {
                CommonObject.logger!.info(
                  "New contact ${contact.uuid} has been saved",
                );
              }
            } else {
              CommonObject.logger!.warning(
                "Failed to add contact ${contact.uuid}",
              );
            }
          }
          if (!success) {
            showDialog<void>(
              context: context,
              builder: (final BuildContext context) {
                return const ErrorPopup(
                  title: "Failed to save contact",
                  body: "addContact failed",
                  enableReturn: false,
                );
              },
            );
          } else {
            contact.name = newName!;
            contact.encryptionKey = newKey!;
            contact.phoneNumber = newPhoneNumber!;
            context.goNamed("ContactListPage");
          }
        }
    }
  }

  @override
  Widget build(final BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(top: 30),
      color: Settings.colorSet.primary,
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
                  color: Settings.colorSet.primary,
                  child: Container(
                    height: 50,
                    decoration: BoxDecoration(
                      color: Settings.colorSet.secondary,
                      borderRadius: BorderRadius.circular(7),
                      border: Border.all(color: Colors.transparent),
                    ),
                    padding: const EdgeInsets.only(left: 10),
                    child: TextField(
                      decoration: InputDecoration(
                        hintText: "Name",
                        hintStyle: TextStyle(color: Settings.colorSet.text),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(7),
                          borderSide: BorderSide.none,
                        ),
                      ),
                      style: TextStyle(
                        color: Settings.colorSet.text,
                        fontSize: 12,
                      ),
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
                        color: Settings.colorSet.primary,
                        child: Container(
                          height: 50,
                          decoration: BoxDecoration(
                            color: Settings.colorSet.secondary,
                            borderRadius: BorderRadius.circular(7),
                            border: Border.all(color: Colors.transparent),
                          ),
                          padding: const EdgeInsets.only(left: 10),
                          child: TextField(
                            controller: encryptionKeyController,
                            decoration: InputDecoration(
                              hintText:
                                  "Encryption Key${Settings.allowUnencryptedMessages ? ", 0=No Key" : ""}",
                              hintStyle: TextStyle(
                                color: Settings.colorSet.text,
                                fontSize: 12,
                              ),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(7),
                                borderSide: BorderSide.none,
                              ),
                            ),
                            style: TextStyle(color: Settings.colorSet.text),
                            onChanged: (final String value) {
                              newKey = value;
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
                            backgroundColor: Settings.colorSet.secondary,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadiusGeometry.circular(7),
                            ),
                          ),
                          icon: Icon(
                            Icons.change_circle_outlined,
                            color: Settings.colorSet.text,
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
                  color: Settings.colorSet.primary,
                  child: Container(
                    height: 50,
                    decoration: BoxDecoration(
                      color: Settings.colorSet.secondary,
                      borderRadius: BorderRadius.circular(7),
                      border: Border.all(color: Colors.transparent),
                    ),
                    padding: const EdgeInsets.only(left: 10),
                    child: TextField(
                      decoration: InputDecoration(
                        hintText: "Phone Number (international)",
                        hintStyle: TextStyle(color: Settings.colorSet.text),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(7),
                          borderSide: BorderSide.none,
                        ),
                      ),
                      style: TextStyle(
                        color: Settings.colorSet.text,
                        fontSize: 12,
                      ),
                      onChanged: (final String value) {
                        newPhoneNumber = value;
                      },
                    ),
                  ),
                ),
              ),
            ],
          ),

          Visibility(
            visible: caller == "chatPage",
            child: BasicButton(
              buttonText: "Share QR-code",
              textColor: Settings.colorSet.text,
              buttonColor:
                  Settings.colorSet.shareQrButton ??
                  Settings.colorSet.secondary,
              onPressed: () {
                final String? uri = generateContactUri(
                  contact: contact,
                  context: context,
                );
                if (uri != null) {
                  context.goNamed("ContactQrPage", pathParameters: {"uri": uri});
                }
              },
              width: 200,
            ),
          ),

          Container(
            margin: const EdgeInsets.only(top: 20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                BasicButton(
                  buttonText: "Discard",
                  textColor: Settings.colorSet.text,
                  buttonColor: Settings.colorSet.secondary,
                  onPressed: discard,
                ),
                BasicButton(
                  buttonText: "Save",
                  textColor: Settings.colorSet.text,
                  buttonColor: Settings.colorSet.tertiary,
                  onPressed: save,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
