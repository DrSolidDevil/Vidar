import "package:vidar/utils/colors.dart";
import "package:vidar/utils/common_object.dart";

/// Static class for storing the active user settings of the program.
class Settings {
  /// Send unencrypted messages when contact has no key.
  static bool allowUnencryptedMessages = false;

  static bool keepLogs = false;

  static bool showEncryptionKeyInEditContact = false;

  static bool showMessageBarHints = true;

  static ColorSet colorSet = vidarColorSet;

  /// Get map of the state of all instance variable of Settings.
  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      "allowUnencryptedMessages": allowUnencryptedMessages,
      "keepLogs": keepLogs,
      "showEncryptionKeyInEditContact": showEncryptionKeyInEditContact,
      "showMessageBarHints": showMessageBarHints,
      "colorSet": colorSet.name,
    };
  }

  /// Set state of all instance variables of Settings from map.
  /// If setting is not found then it goes to the default setting
  void fromMap(final Map<String, dynamic> map) {
    keepLogs = map["keepLogs"] as bool? ?? keepLogs;
    showEncryptionKeyInEditContact =
        map["showEncryptionKeyInEditContact"] as bool? ??
        showEncryptionKeyInEditContact;
    showMessageBarHints =
        map["showMessageBarHints"] as bool? ?? showMessageBarHints;
    colorSet = getColorSetFromName(map["colorSet"] as String? ?? "default");

    final bool? newAllowUnencryptedMessages =
        map["allowUnencryptedMessages"]! as bool?;
    if (newAllowUnencryptedMessages == null) {
      if (keepLogs) {
        CommonObject.logger!.info(
          "allowUnencryptedMessages was not in map, defaulting to $allowUnencryptedMessages",
        );
      }
    } else {
      allowUnencryptedMessages = newAllowUnencryptedMessages;
    }
  }
}
