import "package:flutter/material.dart";
import "package:vidar/configuration.dart";
import "package:vidar/utils/settings.dart";

// ignore: must_be_immutable
class IntSetting extends StatefulWidget {
  IntSetting({
    required this.setting,
    required this.settingText,
    this.maxLength,
    super.key,
  });

  /// The initial state of the setting,
  /// will be updated to reflect changes in the setting.
  int setting;

  /// The text shown to the user explaining the setting.
  final String settingText;
  final int? maxLength;

  @override
  _IntSettingState createState() => _IntSettingState();
}

class _IntSettingState extends State<IntSetting> {
  _IntSettingState();

  late final String settingText;
  late final int? maxLength;

  @override
  void initState() {
    super.initState();
    settingText = widget.settingText;
    maxLength = widget.maxLength;
  }

  @override
  Widget build(final BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(top: 40),
      color: Settings.colorSet.primary,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Container(
            margin: EdgeInsets.only(
              right: MediaQuery.of(context).size.width * 0.1,
            ),
            child: SizedBox(
              width: MediaQuery.of(context).size.width * 0.15,
              child: Material(
                color: Colors.transparent,
                child: TextField(
                  keyboardType: TextInputType.number,
                  maxLength: maxLength,
                  controller: TextEditingController(
                    text: widget.setting.toString(),
                  ),
                  style: TextStyle(color: Settings.colorSet.text),
                  decoration: InputDecoration(
                    fillColor: Settings.colorSet.intSettingFill,
                    filled: true,
                    counter: const SizedBox.shrink(),

                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(5.0),
                      borderSide: BorderSide(
                        color: Settings.colorSet.secondary,
                      ),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(5.0),
                      borderSide: BorderSide(color: Settings.colorSet.tertiary),
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(5.0),
                      borderSide: BorderSide(color: Settings.colorSet.tertiary),
                    ),
                  ),
                  onChanged: (final String value) {
                    widget.setting = int.tryParse(value) ?? widget.setting;
                  },
                ),
              ),
            ),
          ),

          SizedBox(
            width: MediaQuery.of(context).size.width * 0.6,
            child: Text(
              settingText,
              style: TextStyle(
                color: Settings.colorSet.text,
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
