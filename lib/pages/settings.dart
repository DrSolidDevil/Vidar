import 'package:flutter/material.dart';
import 'package:vidar/configuration.dart';
import 'package:vidar/contacts.dart';

class Settings {
  static bool allowUnencryptedMessages = false;
}

class SettingsPage extends StatefulWidget {
  const SettingsPage(this.contactList, {super.key});
  
  final ContactList contactList;

  @override
  createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  _SettingsPageState();
  
  late ContactList contactList;


  @override
  void initState() {
    super.initState();
    
    contactList = widget.contactList;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: VidarColors.primaryDarkSpaceCadet,
      child: Column(
        children: [
          Column(children: [

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
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ContactListPage(contactList),
                        ),
                      );
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
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ContactListPage(contactList),
                        ),
                      );
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
