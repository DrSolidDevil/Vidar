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

  void _save() {
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

  void _discard() {
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
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            spacing: 60,
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
                      onPressed: _discard,
                    ),
                    BasicButton(
                      buttonText: "Save",
                      textColor: Colors.white,
                      buttonColor: VidarColors.tertiaryGold,
                      onPressed: _save,
                    ),
                  ],
                ),
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.only(bottom: 150),
            child: BasicButton(
              buttonText: "Wipe Keys",
              textColor: Colors.white,
              buttonColor: VidarColors.extraFireBrick,
              width: 200,
              onPressed: () {
                showDialog<void>(
                  context: context,
                  builder: (final BuildContext context) {
                    return AlertDialog(
                      title: const Text("Wipe all keys"),
                      content: const Text(
                        "Are you sure you want to wipe all keys? This is a permanent action which can not be undone.",
                      ),
                      actions: <Widget>[
                        TextButton(
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                          child: const Text("Cancel"),
                        ),
                        TextButton(
                          onPressed: () {
                            CommonObject.contactList.wipeKeys();
                            wipeSecureStorage();
                            Navigator.push(
                              context,
                              MaterialPageRoute<void>(
                                builder: (final BuildContext context) =>
                                    const ContactListPage(),
                              ),
                            );
                          },
                          child: const Text("Wipe Keys"),
                        ),
                      ],
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
