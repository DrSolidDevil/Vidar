import "package:flutter/material.dart";
import "package:logging/logging.dart";
import "package:permission_handler/permission_handler.dart";
import "package:vidar/configuration.dart";
import "package:vidar/pages/contact_list.dart";
import "package:vidar/utils/colors.dart";
import "package:vidar/utils/common_object.dart";
import "package:vidar/utils/log.dart";
import "package:vidar/utils/settings.dart";
import "package:vidar/utils/storage.dart";
import "package:vidar/widgets/boolean_setting.dart";
import "package:vidar/widgets/buttons.dart";
import "package:vidar/widgets/color_set_select.dart";

class SettingsPage extends StatefulWidget {
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

  BooleanSetting keepLogs = BooleanSetting(
    setting: Settings.keepLogs,
    settingText: "Keep Logs",
  );

  BooleanSetting showMessageBarHints = BooleanSetting(
    setting: Settings.showMessageBarHints,
    settingText: "Show message bar hints",
  );

  ColorSetSelect colorSetSelect = ColorSetSelect(
    selectedSet: Settings.colorSet.name,
  );

  @override
  void initState() {
    super.initState();
  }

  Future<void> _save() async {
    Settings.allowUnencryptedMessages = allowUnencryptedMessages.setting;
    Settings.keepLogs = keepLogs.setting;
    if (Settings.keepLogs) {
      final PermissionStatus manageExternalStorageStatus = await Permission
          .manageExternalStorage
          .request();
      if (manageExternalStorageStatus.isDenied) {
        if (mounted) {
          showDialog<void>(
            context: context,
            builder: (final BuildContext context) => AlertDialog(
              title: const Text("Can't keep logs"),
              content: const Text(
                "To keep logs you must allow Vidar to manage external storage.",
              ),
              actions: <Widget>[
                TextButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute<void>(
                        builder: (final BuildContext context) =>
                            const ContactListPage(),
                      ),
                    );
                  },
                  child: const Text("Continue"),
                ),
              ],
            ),
          );
        }
        Settings.keepLogs = false;
        return;
      } else {
        CommonObject.logger = Logger(LoggingConfiguration.loggerName);
        CommonObject.logger!.onRecord.listen((final LogRecord log) {
          createLogger();
        });
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
      saveSettings(CommonObject.settings, context: context);
      Navigator.push(
        context,
        MaterialPageRoute<void>(
          builder: (final BuildContext context) => const ContactListPage(),
        ),
      );
    }
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
      color: Settings.colorSet.primary,
      child: ListView(
        children: <Widget>[
          Column(
            spacing: 20,
            children: <Widget>[
              Column(
                children: <Widget>[
                  allowUnencryptedMessages,
                  keepLogs,
                  showMessageBarHints,
                  colorSetSelect,
                ],
              ),
              Container(
                margin: const EdgeInsets.only(top: 60),
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
            padding: const EdgeInsets.only(top: 100),
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
              ],
            ),
          ),
        ],
      ),
    );
  }
}
