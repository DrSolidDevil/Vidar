import "package:flutter/material.dart";
import "package:vidar/utils/colors.dart";
import "package:vidar/utils/settings.dart";

// ignore: must_be_immutable
class ColorSetSelect extends StatefulWidget {
  ColorSetSelect({required this.selectedSet, super.key});

  String selectedSet;

  @override
  _ColorSetSelectState createState() => _ColorSetSelectState();
}

class _ColorSetSelectState extends State<ColorSetSelect> {
  _ColorSetSelectState();

  late final String settingText;

  @override
  Widget build(final BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(top: 40),
      color: Settings.colorSet.primary,
      child: Material(
        color: Colors.transparent,
        child: SizedBox(
          width: MediaQuery.of(context).size.width * 0.7,
          child: DecoratedBox(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10.0),
              color: Settings.colorSet.secondary,
            ),
            child: DropdownButtonHideUnderline(
              child: DropdownButton<String>(
                isExpanded: true,
                borderRadius: BorderRadius.circular(10.0),
                padding: EdgeInsets.only(
                  left: MediaQuery.of(context).size.width * 0.1,
                  right: MediaQuery.of(context).size.width * 0.05,
                ),
                dropdownColor: Settings.colorSet.secondary,
                focusColor: Settings.colorSet.dropdownFocus,
                icon: Icon(
                  Icons.arrow_circle_down_sharp,
                  color: Settings.colorSet.text,
                ),

                style: TextStyle(color: Settings.colorSet.text),
                value: widget.selectedSet,
                items: availableColorSets
                    .map<DropdownMenuItem<String>>(
                      (final String value) => DropdownMenuItem<String>(
                        value: value,
                        child: Text(value),
                      ),
                    )
                    .toList(),
                onChanged: (final String? value) {
                  if (value != null) {
                    setState(() {
                      widget.selectedSet = value;
                    });
                  }
                },
              ),
            ),
          ),
        ),
      ),
    );
  }
}
