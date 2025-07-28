// ignore_for_file: inference_failure_on_function_return_type, avoid_positional_boolean_parameters

import "package:flutter/material.dart";
import "package:vidar/configuration.dart";
import "package:vidar/utils/settings.dart";

// ignore: must_be_immutable
class BooleanSetting extends StatefulWidget {
  BooleanSetting({
    required this.setting,
    required this.settingText,
    this.customOnChanged,
    this.doSetState = true,
    super.key,
  });

  /// The initial state of the setting,
  /// will be updated to reflect changes in the setting.
  bool setting;

  /// The text shown to the user explaining the setting.
  final String settingText;

  /// Allows the implementation of additional actions beyond just changing the value
  final Function(bool value)? customOnChanged;

  /// If set to false then the BooleanSetting will not update when its value is changed.
  /// To make it update when doSetState is set to false you need to update it in a parent widget or use a builder.
  final bool doSetState;
  
  @override
  _BooleanSettingState createState() => _BooleanSettingState();
}

class _BooleanSettingState extends State<BooleanSetting> {
  _BooleanSettingState();

  late final String settingText;
  late final Function(bool value)? onChanged;
  late final bool doSetState;

  @override
  void initState() {
    super.initState();
    settingText = widget.settingText;
    onChanged = (final bool value) {
        (widget.customOnChanged ?? (_){})(value);
        if (doSetState) {
          setState(() {
            widget.setting = value;
          });
        } else {
          widget.setting = value;
        }
      };
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
