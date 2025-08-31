import "package:cryptography/cryptography.dart";
import "package:vidar/configuration.dart";
import "package:vidar/utils/common_object.dart";
import "package:vidar/utils/contact.dart";
import "package:vidar/utils/encryption.dart";
import "package:vidar/utils/encryption_exceptions.dart";
import "package:vidar/utils/extended_change_notifier.dart";
import "package:vidar/utils/settings.dart";
import "package:vidar/utils/sms.dart";

class Conversation extends ExtendedChangeNotifier {
  Conversation(this.contact) {
    smsNotifier = SmsNotifier();
    attach(smsNotifier);
  }

  final Contact contact;
  final List<SmsMessage> _decryptedChatLogs = <SmsMessage>[];
  // If there are a lot of chat logs then this can improve performance
  // by not requiring a complete count (e.g. +10K messages, etc)
  int _currentChatLogsLength = 0;
  late final SmsNotifier smsNotifier;

  List<SmsMessage> get decryptedChatLogs => _decryptedChatLogs;
  int get chatLogsLength => _currentChatLogsLength;

  /// This queries all chat logs from contact, use should be minimized. Instead use updateChatLogs
  Future<ConversationStatus> queryChatLogs() async {
    final List<SmsMessage?> chatLogs = await querySms(
      phoneNumber: contact.phoneNumber,
    );

    if (chatLogs[0] == null) {
      if (Settings.keepLogs) {
        CommonObject.logger!.info(
          "Failed to query chat logs for contact ${contact.uuid}",
        );
      }
      return ConversationStatus.FAILURE;
    }

    // Maybe in the future SMS messages will be mutable and not require cloning but for now,
    // I'm unsure if i should do it.
    // So for the moment it still clones.
    _currentChatLogsLength = chatLogs.length;
    for (final SmsMessage chat in chatLogs as List<SmsMessage>) {
      if (chat.status == SmsConstants.STATUS_FAILED) {
        _decryptedChatLogs.add(chat.clone(newBody: "Message failed"));
      } else {
        String res;
        Exception? err;
        (res, err) = await decryptMessage(
          chat.body,
          contact.encryptionKey,
          algorithm: AesGcm.with256bits(
            nonceLength: CryptographicConfiguration.nonceLength,
          ),
        );
        if (err != null && err.runtimeType != NoEncryptionPrefixException) {
          switch (err.runtimeType) {
            case const (DecryptionException):
              res = "Decryption failed";
            default:
              res = err.message;
          }
        }
        _decryptedChatLogs.add(
          chat.clone(
            newBody: res,
            newStatus: err != null ? SmsConstants.STATUS_FAILED : chat.status,
          ),
        );
      }
    }
    return ConversationStatus.SUCCESS;
  }

  /// Only checks "latestN" number of chats from contact to update
  /// Returns true on success
  Future<ConversationStatus> updateChatLogs({required int latestN}) async {
    if (_currentChatLogsLength == 0) {
      return queryChatLogs();
    }
    if (latestN > _currentChatLogsLength) {
      latestN = _currentChatLogsLength;
    }

    final List<SmsMessage?> chatLogs = await querySms(
      phoneNumber: contact.phoneNumber,
      latestN: latestN,
    );

    if (chatLogs[0] == null) {
      if (Settings.keepLogs) {
        CommonObject.logger!.info(
          "Failed to query chat logs for contact ${contact.uuid}",
        );
      }
      return ConversationStatus.FAILURE;
    }

    // Maybe in the future SMS messages will be mutable and not require cloning but for now,
    // I'm unsure if i should do it.
    // So for the moment it still clones.
    final List<DateTime> latestMessageDates = <DateTime>[];
    for (final SmsMessage? chat in _decryptedChatLogs.sublist(
      0,
      _currentChatLogsLength < ChatConfiguration.numCheckDuringUpdate
          ? _currentChatLogsLength
          : ChatConfiguration.numCheckDuringUpdate,
    )) {
      latestMessageDates.add(chat!.date!);
    }

    for (final SmsMessage chat in chatLogs as List<SmsMessage>) {
      // Checks to avoid duplicates
      if (latestMessageDates.contains(chat.date)) {
        continue;
      } else {
        ++_currentChatLogsLength;
      }
      if (chat.status == SmsConstants.STATUS_FAILED) {
        _decryptedChatLogs.insert(0, chat.clone(newBody: "Message failed"));
      } else {
        String res;
        Exception? err;
        (res, err) = await decryptMessage(
          chat.body,
          contact.encryptionKey,
          algorithm: AesGcm.with256bits(
            nonceLength: CryptographicConfiguration.nonceLength,
          ),
        );
        if (err != null) {
          switch (err.runtimeType) {
            case const (DecryptionException):
              res = "Decryption failed";
            default:
              res = err.toString();
          }
        }
        _decryptedChatLogs.insert(
          0,
          chat.clone(
            newBody: res,
            newStatus: err != null ? SmsConstants.STATUS_FAILED : chat.status,
          ),
        );
      }
    }
    return ConversationStatus.SUCCESS;
  }
}

// If child of Exception has a "message" attribute then it will use that
// If it does not have such an attribute it will use this.
extension on Exception {
  String get message => toString();
}

enum ConversationStatus { FAILURE, SUCCESS }
