import "package:flutter/material.dart";
import "package:vidar/configuration.dart";
import "package:vidar/pages/contact_list.dart";
import "package:vidar/utils/common_object.dart";
import "package:vidar/utils/settings.dart";
import "package:vidar/utils/storage.dart";
import "package:vidar/widgets/boolean_setting.dart";
import "package:vidar/widgets/buttons.dart";

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

  void save() {
    Settings.allowUnencryptedMessages = allowUnencryptedMessages.setting;
    saveSettings(CommonObject.settings);
    debugPrint(
      "allowUnencryptedMessages: ${Settings.allowUnencryptedMessages}",
    );
    Navigator.push(
      context,
      MaterialPageRoute<void>(
        builder: (final BuildContext context) => const ContactListPage(),
      ),
    );
  }

  void discard() {
    Navigator.push(
      context,
      MaterialPageRoute<void>(
        builder: (final BuildContext context) => const ContactListPage(),
      ),
    );
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
                BasicButton(
                  buttonText: "Discard",
                  textColor: Colors.white,
                  buttonColor: VidarColors.secondaryMetallicViolet,
                  onPressed: discard,
                ),
                BasicButton(
                  buttonText: "Save",
                  textColor: Colors.white,
                  buttonColor: VidarColors.tertiaryGold,
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
