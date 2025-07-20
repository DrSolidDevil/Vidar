// ignore_for_file: inference_failure_on_function_return_type, avoid_positional_boolean_parameters

import "package:flutter/material.dart";
import "package:vidar/configuration.dart";
import "package:vidar/utils/settings.dart";

// ignore: must_be_immutable
class BooleanSetting extends StatefulWidget {
  BooleanSetting({
    required this.setting,
    required this.settingText,
    this.onChanged,
    super.key,
  });

  /// The initial state of the setting,
  /// will be updated to reflect changes in the setting.
  bool setting;

  /// The text shown to the user explaining the setting.
  final String settingText;
  final Function(bool value)? onChanged;
  @override
  _BooleanSettingState createState() => _BooleanSettingState();
}

class _BooleanSettingState extends State<BooleanSetting> {
  _BooleanSettingState();

  late final String settingText;
  late final Function(bool value)? onChanged;

  @override
  void initState() {
    super.initState();
    settingText = widget.settingText;
    onChanged =
        (widget.onChanged ??
                (final bool value) {
                  widget.setting = value;
                })
            as Function(bool value)?;
  }

  @override
  Widget build(final BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(top: 40),
      color: Settings.colorSet.primary,
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
                activeColor: Settings.colorSet.tertiary,
                inactiveThumbColor: Settings.colorSet.secondary,
                inactiveTrackColor: Settings.colorSet.inactiveTrack,
                trackOutlineColor: WidgetStateProperty.resolveWith(
                  (final Set<WidgetState> states) =>
                      states.contains(WidgetState.selected)
                      ? null
                      : Settings.colorSet.secondary,
                ),
                value: widget.setting,
                onChanged: onChanged,
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

/// This version does not automate the setting handling
class LightBooleanSetting extends StatefulWidget {
  const LightBooleanSetting({
    required this.settingText,
    required this.onChanged,
    required this.initValue,
    super.key,
  });

  /// The text shown to the user explaining the setting.
  final String settingText;
  final bool initValue;
  final Function(bool value) onChanged;
  @override
  _LightBooleanSettingState createState() => _LightBooleanSettingState();
}

class _LightBooleanSettingState extends State<LightBooleanSetting> {
  _LightBooleanSettingState();

  late final String settingText;
  late final Function(bool value) onChanged;
  late bool value;

  @override
  void initState() {
    super.initState();
    settingText = widget.settingText;
    onChanged = widget.onChanged;
    value = widget.initValue;
  }

  @override
  Widget build(final BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(top: 40),
      color: Settings.colorSet.primary,
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
                activeColor: Settings.colorSet.tertiary,
                inactiveThumbColor: Settings.colorSet.secondary,
                inactiveTrackColor: Settings.colorSet.inactiveTrack,
                trackOutlineColor: WidgetStateProperty.resolveWith(
                  (final Set<WidgetState> states) =>
                      states.contains(WidgetState.selected)
                      ? null
                      : Settings.colorSet.secondary,
                ),
                value: value,
                onChanged: (final bool value) {
                  setState(() {
                    onChanged(value);
                    this.value = value;
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
