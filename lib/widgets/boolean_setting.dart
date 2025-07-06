import "package:flutter/material.dart";
import "package:vidar/configuration.dart";

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

  late final String settingText;

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
