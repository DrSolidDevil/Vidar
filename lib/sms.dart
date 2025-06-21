// ignore_for_file: non_constant_identifier_names, constant_identifier_names

import 'dart:core';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/foundation.dart';

// Only for testing
import 'fakesms.dart';

const MAIN_SMS_CHANNEL = MethodChannel("flutter.native/helper");

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
    String? newBody,
    String? newPhoneNumber, 
    int? newThreadId, 
    int? newType, 
    DateTime? newDate, 
    DateTime? newDateSent, 
    bool? newSeen, 
    bool? newRead, 
    int? newProtocol, 
    int? newStatus, 
    int? newSubscriptionId, 
    String? newSubject,
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
SmsMessage? _queryMapToSms(Map<String, String> smsMap) {
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
  final int protocol = int.parse(smsMap[SmsConstants.COLUMN_NAME_PROTOCOL]!);
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
Future<List<SmsMessage>?> querySms({String? phoneNumber}) async {
  if (defaultTargetPlatform == TargetPlatform.android) {
    try {
      final List<Map<String, String>>? result = await MAIN_SMS_CHANNEL
          .invokeMethod<List<Map<String, String>>>('querySms');

      if (result == null) {
        return null;
      }

      final List<SmsMessage> smsMessages = [];
      for (final Map<String, String> mapMessage in result) {
        smsMessages.add(_queryMapToSms(mapMessage)!);
      }
      return smsMessages;
    } on PlatformException catch (e) {
      stderr.writeln(e.message);
      return null;
    }
  } else {
    
    print("(No implementation) Querying sms...");
    print("========SMS========");
    for (final SmsMessage sms in fakesms) {
      print("Body: ${sms.body} | Phone Number: ${sms.phoneNumber} | Date: ${sms.date} | Date Sent: ${sms.dateSent} | Type:${sms.type}");
    }
    return fakesms;
  }
}

/// The phone number is that of the other party
void sendSms(String body, String phoneNumber) async {
  if (defaultTargetPlatform == TargetPlatform.android) {
    await MAIN_SMS_CHANNEL.invokeMethod('sendSms', {
      "body": body,
      "phoneNumber": phoneNumber,
    });
  } else {
    print(
      "(No implementation) Sending sms... body:$body  phoneNumber:$phoneNumber",
    );
    fakesms.add(SmsMessage(body, phoneNumber, dateSent: DateTime.now(), type: SmsConstants.MESSAGE_TYPE_SENT, status: SmsConstants.STATUS_COMPLETE));
  }
}

Future<Map<String, dynamic>> retrieveSmsConstantsMap() async {
  final Map<String, dynamic> smsConstants;
  if (defaultTargetPlatform == TargetPlatform.android) {
    smsConstants = await MAIN_SMS_CHANNEL.invokeMethod('smsConstants');
  } else {
    smsConstants = {
      "MESSAGE_TYPE_ALL": 0,
      "MESSAGE_TYPE_DRAFT": 3,
      "MESSAGE_TYPE_SENT": 2,
      "MESSAGE_TYPE_INBOX": 1,
      "MESSAGE_TYPE_FAILED": 5,
      "MESSAGE_TYPE_OUTBOX": 4,
      "MESSAGE_TYPE_QUEUED": 6,
      "STATUS_NONE": -1,
      "STATUS_FAILED": 64,
      "STATUS_PENDING": 32,
      "STATUS_COMPLETE": 0,
      "THREAD_ID": "thread_id",
      "TYPE": "type",
      "ADDRESS": "address",
      "DATE": "date",
      "DATE_SENT": "date_sent",
      "READ": "read",
      "SEEN": "seen",
      "PROTOCOL": "protocol",
      "STATUS": "status",
      "SUBSCRIPTION_ID": "sub_id",
      "SUBJECT": "subject",
      "BODY": "body",
    };
    print("(No implementation) Fetching sms constants... $smsConstants");
  }
  return smsConstants;
}

/// To use you need to initialize it
class SmsConstants {
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

  SmsConstants(final Map<String, dynamic>? mapConstantsParam) {
    if (mapConstantsParam != null) {
      mapConstants = mapConstantsParam;
    }
    MESSAGE_TYPE_ALL = mapConstants!["MESSAGE_TYPE_ALL"];
    MESSAGE_TYPE_DRAFT = mapConstants!["MESSAGE_TYPE_DRAFT"];
    MESSAGE_TYPE_SENT = mapConstants!["MESSAGE_TYPE_SENT"];
    MESSAGE_TYPE_INBOX = mapConstants!["MESSAGE_TYPE_INBOX"];
    MESSAGE_TYPE_FAILED = mapConstants!["MESSAGE_TYPE_FAILED"];
    MESSAGE_TYPE_OUTBOX = mapConstants!["MESSAGE_TYPE_OUTBOX"];
    MESSAGE_TYPE_QUEUED = mapConstants!["MESSAGE_TYPE_QUEUED"];

    STATUS_NONE = mapConstants!["STATUS_NONE"];
    STATUS_FAILED = mapConstants!["STATUS_FAILED"];
    STATUS_PENDING = mapConstants!["STATUS_PENDING"];
    STATUS_COMPLETE = mapConstants!["STATUS_COMPLETE"];

    COLUMN_NAME_THREAD_ID = mapConstants!["THREAD_ID"];
    COLUMN_NAME_TYPE = mapConstants!["TYPE"];
    COLUMN_NAME_ADDRESS = mapConstants!["ADDRESS"];
    COLUMN_NAME_DATE = mapConstants!["DATE"];
    COLUMN_NAME_DATE_SENT = mapConstants!["DATE_SENT"];
    COLUMN_NAME_READ = mapConstants!["READ"];
    COLUMN_NAME_SEEN = mapConstants!["SEEN"];
    COLUMN_NAME_PROTOCOL = mapConstants!["PROTOCOL"];
    COLUMN_NAME_STATUS = mapConstants!["STATUS"];
    COLUMN_NAME_SUBSCRIPTION_ID = mapConstants!["SUBSCRIPTION_ID"];
    COLUMN_NAME_SUBJECT = mapConstants!["SUBJECT"];
    COLUMN_NAME_BODY = mapConstants!["BODY"];
  }
}

/// Notifies when (any) sms is recieved
class SmsNotifier extends ChangeNotifier {
  // if later you can choose the specific phone number then this can't be static
  static const SMS_NOTIFIER_CHANNEL = EventChannel(
    "flutter.native/smsnotifier",
  );
  SmsNotifier() {
    SMS_NOTIFIER_CHANNEL.receiveBroadcastStream((event) {
      if (event is String && event == "smsreceived") {
        notifyListeners();
      }
    });
  }
}
