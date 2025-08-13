import "package:vidar/utils/colors.dart";

/// Static class for storing the active user settings of the program.
class Settings {
  // The init value is the default value for each setting
  /// Send unencrypted messages when contact has no key.
  static bool allowUnencryptedMessages = false;

  static bool keepLogs = false;

  static bool showEncryptionKeyInEditContact = false;

  static bool allowWipeoutTime = false;

  static int wipeoutTime = 0;

  static bool showMessageBarHints = true;

  static ColorSet colorSet = vidarColorSet;

  static bool allowUserFeedbackDialog = true;

  static bool use12HourClock = false;

  /// Get map of the state of all instance variable of Settings.
  static Map<String, dynamic> toMap() {
    return <String, dynamic>{
      "allowUnencryptedMessages": allowUnencryptedMessages,
      "keepLogs": keepLogs,
      "showEncryptionKeyInEditContact": showEncryptionKeyInEditContact,
      "allowWipeoutTime": allowWipeoutTime,
      "wipeoutTime": wipeoutTime,
      "showMessageBarHints": showMessageBarHints,
      "colorSet": colorSet.name,
      "allowUserFeedbackDialog": allowUserFeedbackDialog,
      "use12HourClock": use12HourClock,
    };
  }

  /// Set state of all instance variables of Settings from map.
  /// If setting is not found then it goes to the default setting
  static void fromMap(final Map<String, dynamic> map) {
    keepLogs = map["keepLogs"] as bool? ?? keepLogs;
    showEncryptionKeyInEditContact =
        map["showEncryptionKeyInEditContact"] as bool? ??
        showEncryptionKeyInEditContact;
    showMessageBarHints =
        map["showMessageBarHints"] as bool? ?? showMessageBarHints;
    allowWipeoutTime = map["allowWipeoutTime"] as bool? ?? allowWipeoutTime;
    wipeoutTime = map["wipeoutTime"] as int? ?? wipeoutTime;
    colorSet = getColorSetFromName(map["colorSet"] as String? ?? "default");
    allowUnencryptedMessages =
        map["allowUnencryptedMessages"]! as bool? ?? allowUnencryptedMessages;
    allowUserFeedbackDialog = map["allowUserFeedbackDialog"] as bool? ?? allowUserFeedbackDialog;
    use12HourClock = map["use12HourClock"] as bool? ?? use12HourClock;
  }
}
