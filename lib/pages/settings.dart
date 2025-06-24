import 'package:flutter/material.dart';
import 'package:vidar/configuration.dart';
import 'contacts.dart';

class Settings {
  static bool allowUnencryptedMessages = false;

  Map<String, dynamic> toMap() {
    return {"allowUnencryptedMessages": allowUnencryptedMessages};
  }

  void fromMap(Map<String, dynamic> map) {
    allowUnencryptedMessages = map["allowUnencryptedMessages"]!;
  }
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

  BooleanSetting allowUnencryptedMessages = BooleanSetting(
    Settings.allowUnencryptedMessages,
    "Send unencrypted messages when contact has no key",
  );

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
          Column(children: [allowUnencryptedMessages]),
          Container(
            margin: EdgeInsets.only(top: 60),
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
                      Settings.allowUnencryptedMessages =
                          allowUnencryptedMessages.setting;

                      print("=========== New Settings ===========");
                      print(
                        "allowUnencryptedMessages: ${Settings.allowUnencryptedMessages}",
                      );

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

// ignore: must_be_immutable
class BooleanSetting extends StatefulWidget {
  BooleanSetting(this.setting, this.settingText, {super.key});
  bool setting;
  final String settingText;

  @override
  createState() => _BooleanSettingState();
}

class _BooleanSettingState extends State<BooleanSetting> {
  _BooleanSettingState();

  late String settingText;

  @override
  void initState() {
    super.initState();
    settingText = widget.settingText;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: 40),
      color: VidarColors.primaryDarkSpaceCadet,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            margin: EdgeInsets.only(
              right: MediaQuery.of(context).size.width * 0.1,
            ),
            child: Material(
              color: Colors.transparent,
              child: Switch(
                activeColor: VidarColors.tertiaryGold,
                inactiveThumbColor: VidarColors.secondaryMetallicViolet,
                inactiveTrackColor: VidarColors.extraMidnightPurple,
                trackOutlineColor: WidgetStateProperty.resolveWith(
                  (final Set<WidgetState> states) =>
                      states.contains(WidgetState.selected)
                      ? null
                      : VidarColors.secondaryMetallicViolet,
                ),
                value: widget.setting,
                onChanged: (bool value) {
                  setState(() {
                    widget.setting = value;
                  });
                },
              ),
            ),
          ),

          SizedBox(
            width: MediaQuery.of(context).size.width * 0.6,
            child: Text(
              settingText,
              style: TextStyle(
                color: Colors.white,
                fontSize: SizeConfiguration.settingInfoText,
                decoration: TextDecoration.none,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
