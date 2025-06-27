import "package:flutter/material.dart";
import "package:vidar/commonobject.dart";
import "package:vidar/configuration.dart";
import "package:vidar/pages/contacts.dart";
import "package:vidar/save.dart";

/// Static class for storing the active user settings of the program.
class Settings {
  /// Send unencrypted messages when contact has no key.
  static bool allowUnencryptedMessages = false;

  /// Get map of the state of all instance variable of Settings.
  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      "allowUnencryptedMessages": allowUnencryptedMessages,
    };
  }

  /// Set state of all instance variables of Settings from map.
  void fromMap(final Map<String, dynamic> map) {
    allowUnencryptedMessages = map["allowUnencryptedMessages"]! as bool;
  }
}

// ignore: public_member_api_docs
class SettingsPage extends StatefulWidget {
  // ignore: public_member_api_docs
  const SettingsPage({super.key});

  @override
  _SettingsPageState createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  _SettingsPageState();

  BooleanSetting allowUnencryptedMessages = BooleanSetting(
    setting: Settings.allowUnencryptedMessages,
    settingText: "Send unencrypted messages when contact has no key",
  );

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(final BuildContext context) {
    return ColoredBox(
      color: VidarColors.primaryDarkSpaceCadet,
      child: Column(
        children: <Widget>[
          Column(children: <Widget>[allowUnencryptedMessages]),
          Container(
            margin: const EdgeInsets.only(top: 60),
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
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (final BuildContext context) =>
                              const ContactListPage(),
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
                        child: const Text(
                          "Save",
                          style: TextStyle(fontSize: 24, color: Colors.white),
                        ),
                      ),
                    ),
                    onTap: () {
                      Settings.allowUnencryptedMessages =
                          allowUnencryptedMessages.setting;
                      saveData(CommonObject.contactList, CommonObject.settings);

                      debugPrint("=========== New Settings ===========");
                      debugPrint(
                        "allowUnencryptedMessages: ${Settings.allowUnencryptedMessages}",
                      );

                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (final BuildContext context) =>
                              const ContactListPage(),
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
  BooleanSetting({required this.setting, required this.settingText, super.key});

  /// The initial state of the setting,
  /// will be updated to reflect changes in the setting.
  bool setting;

  /// The text shown to the user explaining the setting.
  final String settingText;

  @override
  _BooleanSettingState createState() => _BooleanSettingState();
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
  Widget build(final BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(top: 40),
      color: VidarColors.primaryDarkSpaceCadet,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
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
                onChanged: (final bool value) {
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
              style: const TextStyle(
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
