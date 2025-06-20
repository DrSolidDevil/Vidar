// ignore_for_file: non_constant_identifier_names, constant_identifier_names

import 'dart:core';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

const MAIN_SMS_CHANNEL = MethodChannel("flutter.native/helper");


class SmsMessage {
  const SmsMessage(
    this.body, 
    this.phoneNumber, 
    {
      this.threadId,
      this.type, 
      this.date,
      this.dateSent, 
      this.seen, 
      this.read, 
      this.protocol, 
      this.status, 
      this.subscriptionId, 
      this.subject
    }
  );
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
}

/// Requires an initialization of SmsConstants beforehand
SmsMessage? queryMapToSms(Map<String, String> smsMap) {
  if (SmsConstants.mapConstants == null) {
    return null;
  }
  final int? threadId = int.tryParse(smsMap[SmsConstants.COLUMN_NAME_THREAD_ID]!);
  final int? type = int.tryParse(smsMap[SmsConstants.COLUMN_NAME_TYPE]!);
  final String phoneNumber = smsMap[SmsConstants.COLUMN_NAME_ADDRESS]!;
  final DateTime? date = DateTime.fromMicrosecondsSinceEpoch(int.parse(smsMap[SmsConstants.COLUMN_NAME_DATE]!));
  final DateTime? dateSent = DateTime.fromMicrosecondsSinceEpoch(int.parse(smsMap[SmsConstants.COLUMN_NAME_DATE_SENT]!));
  final bool? seen = int.parse(smsMap[SmsConstants.COLUMN_NAME_SEEN]!) != 0;
  final bool? read = int.parse(smsMap[SmsConstants.COLUMN_NAME_READ]!) != 0;
  final int? protocol = int.parse(smsMap[SmsConstants.COLUMN_NAME_PROTOCOL]!);
  final int? status = int.parse(smsMap[SmsConstants.COLUMN_NAME_STATUS]!);
  final int? subscriptionId = int.parse(smsMap[SmsConstants.COLUMN_NAME_SUBSCRIPTION_ID]!);
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
    subject: subject
  );
  return smsMessage;
}


/// Requires an initialization of SmsConstants beforehand
Future<List<SmsMessage>?> querySms({String? phoneNumber}) async {
  if (Platform.isAndroid) {
    try {
    final List<Map<String, String>>? result = await MAIN_SMS_CHANNEL.invokeMethod<List<Map<String, String>>>('querySms');
    
    if (result == null) {
      return null;
    }

    final List<SmsMessage> smsMessages = [];
    for (final Map<String, String> mapMessage in result) {
      smsMessages.add(queryMapToSms(mapMessage)!);
    }
    return smsMessages;
  } on PlatformException catch (e) {
    stderr.writeln(e.message);
    return null;
  }
  } else {
    final List<SmsMessage> fakesms = [
      SmsMessage("Hello", "123456789", date: DateTime(2025, 6, 20, 12, 0, 0), status: SmsConstants.STATUS_COMPLETE, type: SmsConstants.MESSAGE_TYPE_INBOX),
      SmsMessage("Hi, how are you", "987654321", date: DateTime(2025, 6, 20, 12, 1, 23), status: SmsConstants.STATUS_COMPLETE, type: SmsConstants.MESSAGE_TYPE_OUTBOX),
      SmsMessage("I'm fine", "123456789", date: DateTime(2025, 6, 20, 12, 5, 28), status: SmsConstants.STATUS_COMPLETE, type: SmsConstants.MESSAGE_TYPE_INBOX),
      SmsMessage("You know, it's annoying having to make an entire api for sms when the other one wont work", "987654321", date: DateTime(2025, 6, 20, 12, 6, 40), status: SmsConstants.STATUS_COMPLETE, type: SmsConstants.MESSAGE_TYPE_OUTBOX),
      SmsMessage("Indeeed it is", "123456789", date: DateTime(2025, 6, 20, 12, 8, 54), status: SmsConstants.STATUS_COMPLETE, type: SmsConstants.MESSAGE_TYPE_INBOX),
    ];
    print("(No implementation) Querying sms... sms:$fakesms");
    return null;
  }
  
}



void sendSms(String body, String phoneNumber) async {
  if (Platform.isAndroid) {
    await MAIN_SMS_CHANNEL.invokeMethod('sendSms', {"body":body, "phoneNumber":phoneNumber});
  } else {
    print("(No implementation) Sending sms... body:$body  phoneNumber:$phoneNumber");
  }
  
}


Future<Map<String, dynamic>> retrieveSmsConstantsMap() async {
  final Map<String, dynamic> smsConstants;
  if (Platform.isAndroid) {
    smsConstants = await MAIN_SMS_CHANNEL.invokeMethod('smsConstants');
  } else {
    smsConstants = {
      "MESSAGE_TYPE_ALL" : 0,
      "MESSAGE_TYPE_DRAFT" : 3,
      "MESSAGE_TYPE_SENT" : 2,
      "MESSAGE_TYPE_INBOX" : 1,
      "MESSAGE_TYPE_FAILED" : 5,
      "MESSAGE_TYPE_OUTBOX" : 4,
      "MESSAGE_TYPE_QUEUED" : 6,
      "STATUS_NONE" : -1,
      "STATUS_FAILED" : 64,
      "STATUS_PENDING" : 32,
      "STATUS_COMPLETE" : 0,
      "THREAD_ID" : "thread_id",
      "TYPE" : "type",
      "ADDRESS" : "address",
      "DATE" : "date", 
      "DATE_SENT" : "date_sent",
      "READ" : "read",
      "SEEN" : "seen",
      "PROTOCOL" : "protocol",
      "STATUS" : "status",
      "SUBSCRIPTION_ID" : "sub_id",
      "SUBJECT" : "subject",
      "BODY" : "body"
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
    MESSAGE_TYPE_DRAFT  = mapConstants!["MESSAGE_TYPE_DRAFT"];
    MESSAGE_TYPE_SENT = mapConstants!["MESSAGE_TYPE_SENT"];
    MESSAGE_TYPE_INBOX = mapConstants!["MESSAGE_TYPE_INBOX"];
    MESSAGE_TYPE_FAILED = mapConstants!["MESSAGE_TYPE_FAILED"];
    MESSAGE_TYPE_OUTBOX = mapConstants!["MESSAGE_TYPE_OUTBOX"];
    MESSAGE_TYPE_QUEUED = mapConstants!["MESSAGE_TYPE_QUEUED"];

    STATUS_NONE = mapConstants!["STATUS_NONE"];
    STATUS_FAILED = mapConstants!["STATUS_FAILED"];
    STATUS_PENDING = mapConstants!["STATUS_PENDING"];
    STATUS_COMPLETE = mapConstants!["STATUS_COMPLETE"];

    COLUMN_NAME_THREAD_ID = mapConstants!["COLUMN_NAME_THREAD_ID"];
    COLUMN_NAME_TYPE = mapConstants!["COLUMN_NAME_TYPE"];
    COLUMN_NAME_ADDRESS = mapConstants!["COLUMN_NAME_ADDRESS"];
    COLUMN_NAME_DATE = mapConstants!["COLUMN_NAME_DATE"];
    COLUMN_NAME_DATE_SENT = mapConstants!["COLUMN_NAME_DATE_SENT"];
    COLUMN_NAME_READ = mapConstants!["COLUMN_NAME_READ"];
    COLUMN_NAME_SEEN = mapConstants!["COLUMN_NAME_SEEN"];
    COLUMN_NAME_PROTOCOL = mapConstants!["COLUMN_NAME_PROTOCOL"];
    COLUMN_NAME_STATUS = mapConstants!["COLUMN_NAME_STATUS"];
    COLUMN_NAME_SUBSCRIPTION_ID = mapConstants!["COLUMN_NAME_SUBSCRIPTION_ID"];
    COLUMN_NAME_SUBJECT = mapConstants!["COLUMN_NAME_SUBJECT"];
    COLUMN_NAME_BODY = mapConstants!["COLUMN_NAME_BODY"];
  }

}

/// Notifies when (any) sms is recieved
class SmsNotifier extends ChangeNotifier {
  // if later you can choose the specific phone number then this can't be static
  static const SMS_NOTIFIER_CHANNEL = EventChannel("flutter.native/smsnotifier");
  SmsNotifier() {
    SMS_NOTIFIER_CHANNEL.receiveBroadcastStream(
      (event) {
        if (event is String && event == "smsreceived") {
          notifyListeners();
        }
      }
    );
  }
}