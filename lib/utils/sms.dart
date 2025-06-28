// ignore_for_file: non_constant_identifier_names

import "dart:core";

import "package:flutter/foundation.dart";
import "package:flutter/services.dart";

const MethodChannel MAIN_SMS_CHANNEL = MethodChannel("flutter.native/helper");

class SmsMessage {
  const SmsMessage(
    this.body,
    this.phoneNumber, {
    this.threadId,
    this.type,
    this.date,
    this.dateSent,
    this.seen,
    this.read,
    this.protocol,
    this.status,
    this.subscriptionId,
    this.subject,
  });

  /// The thread ID of the message.
  final int? threadId;

  /// The type of message. (all, draft, failed, inbox, outbox, queued, sent)
  final int? type;
  final String phoneNumber;

  /// The date the message was received.
  final DateTime? date;

  /// The date the message was sent.
  final DateTime? dateSent;

  /// Has the message been seen by the user? The "seen" flag determines whether we need to show a notification.
  final bool? seen;

  /// Has the message been read?
  final bool? read;

  /// Messaging protocol, ex. SMS or MMS
  /// https://en.wikipedia.org/wiki/GSM_03.40#Protocol_Identifier
  final int? protocol;

  /// TP-Status value for the message, or -1 if no status has been received.
  /// See TS 23.040, 9.2.3.15 TP-Status for a description of values.
  /// CDMA: For not interfering with status codes from GSM, the value is shifted to the bits 31-16.
  /// The value is composed of an error class (bits 25-24) and a status code (bits 23-16).
  /// Possible codes are described in C.S0015-B, v2.0, 4.5.21.
  final int? status;

  /// The subscription to which the message belongs to. Its value will be < 0 if the sub id cannot be determined.
  final int? subscriptionId;

  /// The subject of the message, if present.
  final String? subject;
  final String body;

  SmsMessage clone({
    final String? newBody,
    final String? newPhoneNumber,
    final int? newThreadId,
    final int? newType,
    final DateTime? newDate,
    final DateTime? newDateSent,
    final bool? newSeen,
    final bool? newRead,
    final int? newProtocol,
    final int? newStatus,
    final int? newSubscriptionId,
    final String? newSubject,
  }) {
    return SmsMessage(
      newBody ?? body,
      newPhoneNumber ?? phoneNumber,
      threadId: newThreadId ?? threadId,
      type: newType ?? type,
      date: newDate ?? date,
      dateSent: newDateSent ?? dateSent,
      seen: newSeen ?? seen,
      read: newRead ?? read,
      protocol: newProtocol ?? protocol,
      status: newStatus ?? status,
      subscriptionId: newSubscriptionId ?? subscriptionId,
      subject: newSubject ?? subject,
    );
  }
}

/// Requires an initialization of SmsConstants beforehand
SmsMessage? _queryMapToSms(final Map<String, String?> smsMap) {
  if (SmsConstants.mapConstants == null) {
    return null;
  }
  final int? threadId = int.tryParse(
    smsMap[SmsConstants.COLUMN_NAME_THREAD_ID]!,
  );
  final int? type = int.tryParse(smsMap[SmsConstants.COLUMN_NAME_TYPE]!);
  final String phoneNumber = smsMap[SmsConstants.COLUMN_NAME_ADDRESS]!;
  final DateTime date = DateTime.fromMicrosecondsSinceEpoch(
    int.parse(smsMap[SmsConstants.COLUMN_NAME_DATE]!),
  );
  final DateTime dateSent = DateTime.fromMicrosecondsSinceEpoch(
    int.parse(smsMap[SmsConstants.COLUMN_NAME_DATE_SENT]!),
  );
  final bool seen = int.parse(smsMap[SmsConstants.COLUMN_NAME_SEEN]!) != 0;
  final bool read = int.parse(smsMap[SmsConstants.COLUMN_NAME_READ]!) != 0;
  final int? protocol = smsMap[SmsConstants.COLUMN_NAME_PROTOCOL] == null
      ? null
      : int.parse(smsMap[SmsConstants.COLUMN_NAME_PROTOCOL]!);
  final int status = int.parse(smsMap[SmsConstants.COLUMN_NAME_STATUS]!);
  final int subscriptionId = int.parse(
    smsMap[SmsConstants.COLUMN_NAME_SUBSCRIPTION_ID]!,
  );
  final String? subject = smsMap[SmsConstants.COLUMN_NAME_SUBJECT];
  final String body = smsMap[SmsConstants.COLUMN_NAME_BODY]!;

  final SmsMessage smsMessage = SmsMessage(
    body,
    phoneNumber,
    threadId: threadId,
    type: type,
    date: date,
    dateSent: dateSent,
    seen: seen,
    read: read,
    protocol: protocol,
    status: status,
    subscriptionId: subscriptionId,
    subject: subject,
  );
  return smsMessage;
}

/// Requires an initialization of SmsConstants beforehand
/// SMS are returned oldest to newest
/// Returns [null] upon failure (this is to ensure compatibility with FutureBuilder)
Future<List<SmsMessage?>> querySms({final String? phoneNumber}) async {
  try {
    debugPrint("phonenumber = $phoneNumber");
    final dynamic rawResult = await MAIN_SMS_CHANNEL.invokeMethod(
      "querySms",
      <String, String?>{"phoneNumber": phoneNumber},
    );
    if (rawResult == null) {
      debugPrint("sms query is null");
      return <SmsMessage?>[null];
    }
    debugPrint(rawResult.toString());
    final List<Map<String, String?>> result = <Map<String, String?>>[];
    for (final dynamic resultEntry in rawResult as Iterable<dynamic>) {
      result.add(
        Map<String, String?>.from(resultEntry as Map<dynamic, dynamic>),
      );
    }
    final List<SmsMessage> smsMessages = <SmsMessage>[];
    for (final Map<String, String?> mapMessage in result) {
      smsMessages.add(_queryMapToSms(mapMessage)!);
    }
    if (smsMessages.isEmpty) {
      debugPrint("(querySms) smsMessages is empty");
    }
    await Future<void>.delayed(const Duration(seconds: 10));
    return smsMessages;
  } on PlatformException catch (e) {
    debugPrint(e.message);
    return <SmsMessage?>[null];
  }
 
}

/// The phone number is that of the other party
Future<void> sendSms(final String body, final String phoneNumber) async {
  /// 0 = success, for now not used
  final dynamic result = await MAIN_SMS_CHANNEL.invokeMethod(
    "sendSms",
    <String, String>{"body": body, "phoneNumber": phoneNumber},
  );
  debugPrint("Sending result: $result");
}

Future<Map<String, dynamic>> retrieveSmsConstantsMap() async {
  final dynamic rawConstants = await MAIN_SMS_CHANNEL.invokeMethod(
    "smsConstants",
  );
  return Map<String, dynamic>.from(rawConstants as Map<dynamic, dynamic>);
}

/// To use you need to initialize it
class SmsConstants {
  SmsConstants(final Map<String, dynamic>? mapConstantsParam) {
    if (mapConstantsParam != null) {
      mapConstants = mapConstantsParam;
    }
    MESSAGE_TYPE_ALL = int.parse(mapConstants!["MESSAGE_TYPE_ALL"] as String);
    MESSAGE_TYPE_DRAFT = int.parse(
      mapConstants!["MESSAGE_TYPE_DRAFT"] as String,
    );
    MESSAGE_TYPE_SENT = int.parse(mapConstants!["MESSAGE_TYPE_SENT"] as String);
    MESSAGE_TYPE_INBOX = int.parse(
      mapConstants!["MESSAGE_TYPE_INBOX"] as String,
    );
    MESSAGE_TYPE_FAILED = int.parse(
      mapConstants!["MESSAGE_TYPE_FAILED"] as String,
    );
    MESSAGE_TYPE_OUTBOX = int.parse(
      mapConstants!["MESSAGE_TYPE_OUTBOX"] as String,
    );
    MESSAGE_TYPE_QUEUED = int.parse(
      mapConstants!["MESSAGE_TYPE_QUEUED"] as String,
    );

    STATUS_NONE = int.parse(mapConstants!["STATUS_NONE"] as String);
    STATUS_FAILED = int.parse(mapConstants!["STATUS_FAILED"] as String);
    STATUS_PENDING = int.parse(mapConstants!["STATUS_PENDING"] as String);
    STATUS_COMPLETE = int.parse(mapConstants!["STATUS_COMPLETE"] as String);

    COLUMN_NAME_THREAD_ID = mapConstants!["THREAD_ID"] as String;
    COLUMN_NAME_TYPE = mapConstants!["TYPE"] as String;
    COLUMN_NAME_ADDRESS = mapConstants!["ADDRESS"] as String;
    COLUMN_NAME_DATE = mapConstants!["DATE"] as String;
    COLUMN_NAME_DATE_SENT = mapConstants!["DATE_SENT"] as String;
    COLUMN_NAME_READ = mapConstants!["READ"] as String;
    COLUMN_NAME_SEEN = mapConstants!["SEEN"] as String;
    COLUMN_NAME_PROTOCOL = mapConstants!["PROTOCOL"] as String;
    COLUMN_NAME_STATUS = mapConstants!["STATUS"] as String;
    COLUMN_NAME_SUBSCRIPTION_ID = mapConstants!["SUBSCRIPTION_ID"] as String;
    COLUMN_NAME_SUBJECT = mapConstants!["SUBJECT"] as String;
    COLUMN_NAME_BODY = mapConstants!["BODY"] as String;
  }

  static late final Map<String, dynamic>? mapConstants;

  static late final int MESSAGE_TYPE_ALL;
  static late final int MESSAGE_TYPE_DRAFT;
  static late final int MESSAGE_TYPE_SENT;
  static late final int MESSAGE_TYPE_INBOX;
  static late final int MESSAGE_TYPE_FAILED;
  static late final int MESSAGE_TYPE_OUTBOX;
  static late final int MESSAGE_TYPE_QUEUED;

  static late final int STATUS_NONE;
  static late final int STATUS_FAILED;
  static late final int STATUS_PENDING;
  static late final int STATUS_COMPLETE;

  static late final String COLUMN_NAME_THREAD_ID;
  static late final String COLUMN_NAME_TYPE;
  static late final String COLUMN_NAME_ADDRESS;
  static late final String COLUMN_NAME_DATE;
  static late final String COLUMN_NAME_DATE_SENT;
  static late final String COLUMN_NAME_READ;
  static late final String COLUMN_NAME_SEEN;
  static late final String COLUMN_NAME_PROTOCOL;
  static late final String COLUMN_NAME_STATUS;
  static late final String COLUMN_NAME_SUBSCRIPTION_ID;
  static late final String COLUMN_NAME_SUBSCRIPT;
  static late final String COLUMN_NAME_SUBJECT;
  static late final String COLUMN_NAME_BODY;
}

/// Notifies when (any) sms is recieved
class SmsNotifier extends ChangeNotifier {
  SmsNotifier() {
    SMS_NOTIFIER_CHANNEL.receiveBroadcastStream((final dynamic event) {
      if (event is String && event == "smsreceived") {
        notifyListeners();
      }
    });
  }
  // if later you can choose the specific phone number then this can't be static
  static const EventChannel SMS_NOTIFIER_CHANNEL = EventChannel(
    "flutter.native/smsnotifier",
  );
}
