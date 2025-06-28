/// Static class for storing the active user settings of the program.
class Settings {
  /// Send unencrypted messages when contact has no key.
  static bool allowUnencryptedMessages = false;

  /// Get map of the state of all instance variable of Settings.
  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      "allowUnencryptedMessages": allowUnencryptedMessages,
    };
  }

  /// Set state of all instance variables of Settings from map.
  void fromMap(final Map<String, dynamic> map) {
    allowUnencryptedMessages = map["allowUnencryptedMessages"]! as bool;
  }
}
