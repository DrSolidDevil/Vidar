import "package:flutter/material.dart";
import "package:permission_handler/permission_handler.dart";
import "package:vidar/pages/contact_list.dart";
import "package:vidar/utils/colors.dart";
import "package:vidar/utils/common_object.dart";
import "package:vidar/utils/log.dart";
import "package:vidar/utils/navigation.dart";
import "package:vidar/utils/settings.dart";
import "package:vidar/utils/storage.dart";
import "package:vidar/widgets/boolean_setting.dart";
import "package:vidar/widgets/buttons.dart";
import "package:vidar/widgets/color_set_select.dart";
import "package:vidar/widgets/int_setting.dart";

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  _SettingsPageState createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  _SettingsPageState() {
    allowWipeoutTime = BooleanSetting(
      setting: allowWipeoutTimeValue,
      settingText: "Require login every X days",
      customOnChanged: (final bool value) {
        setState(() {
          allowWipeoutTimeValue = !allowWipeoutTimeValue;
        });
      },
    );
  }

  late final BooleanSetting allowWipeoutTime;

  bool allowWipeoutTimeValue = Settings.allowWipeoutTime;

  final BooleanSetting allowUnencryptedMessages = BooleanSetting(
    setting: Settings.allowUnencryptedMessages,
    settingText: "Send unencrypted messages when contact has no key",
  );

  final BooleanSetting keepLogs = BooleanSetting(
    setting: Settings.keepLogs,
    settingText: "Keep Logs",
  );

  final BooleanSetting showEncryptionKeyInEditContact = BooleanSetting(
    setting: Settings.showEncryptionKeyInEditContact,
    settingText: "Show encryption key when editing contact",
  );

  final BooleanSetting showMessageBarHints = BooleanSetting(
    setting: Settings.showMessageBarHints,
    settingText: "Show message bar hints",
  );

  final BooleanSetting allowUserFeedbackDialog = BooleanSetting(
    setting: Settings.allowUserFeedbackDialog,
    settingText: "Allow feedback popups",
  );

  final ColorSetSelect colorSetSelect = ColorSetSelect(
    selectedSet: Settings.colorSet.name,
  );

  final IntSetting wipeoutTime = IntSetting(
    setting: Settings.wipeoutTime,
    settingText: "Max logon interval (days)",
    maxLength: 4,
  );

  @override
  void initState() {
    super.initState();
  }

  Future<void> _save() async {
    Settings.allowUnencryptedMessages = allowUnencryptedMessages.setting;
    Settings.keepLogs = keepLogs.setting;
    Settings.showEncryptionKeyInEditContact =
        showEncryptionKeyInEditContact.setting;
    Settings.allowUnencryptedMessages = allowUnencryptedMessages.setting;
    Settings.allowWipeoutTime = allowWipeoutTimeValue;
    Settings.allowUserFeedbackDialog = allowUserFeedbackDialog.setting;
    if (allowWipeoutTimeValue) {
      if (wipeoutTime.setting < 1) {
        Settings.allowWipeoutTime = false;
        Settings.wipeoutTime = 0;
      } else {
        Settings.allowWipeoutTime = true;
        Settings.wipeoutTime = wipeoutTime.setting;
      }
    }
    if (Settings.keepLogs) {
      final PermissionStatus manageExternalStorageStatus = await Permission
          .manageExternalStorage
          .request();
      if (manageExternalStorageStatus.isGranted) {
        createLogger();
      } else {
        if (mounted) {
          showDialog<void>(
            context: context,
            builder: (final BuildContext context) => AlertDialog(
              title: Text(
                "Can't keep logs",
                style: TextStyle(color: Settings.colorSet.dialogText),
              ),
              content: Text(
                "To keep logs you must allow Vidar to manage external storage.",
                style: TextStyle(color: Settings.colorSet.dialogText),
              ),
              actions: <Widget>[
                TextButton(
                  onPressed: () {
                    clearNavigatorAndPush(context, const ContactListPage());
                  },
                  child: Text(
                    "Continue",
                    style: TextStyle(
                      color: Settings.colorSet.dialogButtonText,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ),
              ],
              backgroundColor: Settings.colorSet.dialogBackground,
            ),
          );
        }
        Settings.keepLogs = false;
      }
    } else {
      if (CommonObject.logger != null) {
        CommonObject.logger!.clearListeners();
        CommonObject.logger = null;
      }
      CommonObject.logs = <String>[];
    }
    Settings.showMessageBarHints = showMessageBarHints.setting;
    Settings.colorSet = getColorSetFromName(colorSetSelect.selectedSet);

    if (mounted) {
      saveSettings(context: context);
      clearNavigatorAndPush(context, const ContactListPage());
    }
  }

  void _discard() {
    clearNavigatorAndPush(context, const ContactListPage());
  }

  @override
  Widget build(final BuildContext context) {
    return ColoredBox(
      color: Settings.colorSet.primary,
      child: ListView(
        children: <Widget>[
          Column(
            spacing: 20,
            children: <Widget>[
              Column(
                children: <Widget>[
                  allowUnencryptedMessages,
                  showEncryptionKeyInEditContact,
                  Column(
                    children: <Widget>[
                      allowWipeoutTime,
                      Visibility(
                        visible: allowWipeoutTimeValue,
                        child: wipeoutTime,
                      ),
                    ],
                  ),
                  keepLogs,
                  allowUserFeedbackDialog,
                  showMessageBarHints,
                  colorSetSelect,
                ],
              ),
              Container(
                margin: const EdgeInsets.only(top: 40),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    BasicButton(
                      buttonText: "Discard",
                      textColor: Settings.colorSet.text,
                      buttonColor: Settings.colorSet.secondary,
                      onPressed: _discard,
                    ),
                    BasicButton(
                      buttonText: "Save",
                      textColor: Settings.colorSet.text,
                      buttonColor: Settings.colorSet.tertiary,
                      onPressed: _save,
                      fontWeight: FontWeight.bold,
                    ),
                  ],
                ),
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.only(top: 60),
            child: Column(
              spacing: 50,
              children: <Widget>[
                Visibility(
                  visible: Settings.keepLogs,
                  child: BasicButton(
                    buttonText: "Export Logs",
                    textColor: Settings.colorSet.text,
                    buttonColor: Settings.colorSet.exportLogsButton,
                    onPressed: () => exportLogs(context: context),
                    width: 200,
                  ),
                ),
                BasicButton(
                  buttonText: "Wipe Keys",
                  textColor: Settings.colorSet.wipeKeyButtonText,
                  buttonColor: Settings.colorSet.wipeKeyButton,
                  width: 200,
                  onPressed: () {
                    showDialog<void>(
                      context: context,
                      builder: (final BuildContext context) {
                        return AlertDialog(
                          title: Text(
                            "Wipe all keys",
                            style: TextStyle(
                              color: Settings.colorSet.dialogText,
                            ),
                          ),
                          content: Text(
                            "Are you sure you want to wipe all keys? This is a permanent action which can not be undone.",
                            style: TextStyle(
                              color: Settings.colorSet.dialogText,
                            ),
                          ),
                          actions: <Widget>[
                            TextButton(
                              onPressed: () {
                                Navigator.of(context).pop();
                              },
                              child: Text(
                                "Cancel",
                                style: TextStyle(
                                  color: Settings.colorSet.dialogButtonText,
                                  fontWeight: FontWeight.w800,
                                ),
                              ),
                            ),
                            TextButton(
                              onPressed: () {
                                if (Settings.keepLogs) {
                                  CommonObject.logger!.info(
                                    "Wiping all keys...",
                                  );
                                }
                                CommonObject.contactList.wipeKeys();
                                wipeSecureStorage();
                                clearNavigatorAndPush(
                                  context,
                                  const ContactListPage(),
                                );
                              },
                              child: Text(
                                "Wipe Keys",
                                style: TextStyle(
                                  color: Settings.colorSet.dialogButtonText,
                                  fontWeight: FontWeight.w800,
                                ),
                              ),
                            ),
                          ],
                          backgroundColor: Settings.colorSet.dialogBackground,
                        );
                      },
                    );
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
