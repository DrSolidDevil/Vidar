class NoKeyException implements Exception {
  @override
  String toString() => "NoKeyException";
}

class NoEncryptionPrefixException implements Exception {
  @override
  String toString() => "NoEncryptionPrefixException";
}

class EncryptionException implements Exception {
  const EncryptionException([this.message = ""]);
  final String message;
  @override
  String toString() =>
      message == "" ? "EncryptionException" : "EncryptionException: $message";
}

class DecryptionException implements Exception {
  const DecryptionException([this.message = ""]);
  final String message;
  @override
  String toString() =>
      message == "" ? "DecryptionException" : "DecryptionException: $message";
}
