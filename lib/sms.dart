import 'dart:io';
import 'package:flutter/services.dart';

const mainChannel = MethodChannel("flutter.native/helper");
const smsNotifierChannel = MethodChannel("flutter.native/smsnotifier");



class SmsMessage {
  const SmsMessage(
    this.body, 
    this.phoneNumber, 
    {
      this.threadId,
      this.type, 
      this.date,
      this.dateSent, 
      this.sent, 
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
  /// (boolean int) Has the message been seen by the user? The "seen" flag determines whether we need to show a notification.
  final int? sent;
  /// (boolean int) Has the message been read?
  final int? read;
  /// Messaging protocol, ex. SMS or MMS
  final int? protocol;
  /// TP-Status value for the message, or -1 if no status has been received.
  final int? status;
  /// The subscription to which the message belongs to. Its value will be < 0 if the sub id cannot be determined.
  final int? subscriptionId;
  /// The subject of the message, if present.
  final String? subject;
  final String body;
}


Future<List<SmsMessage>?> querySms({String? phoneNumber}) async {
  if (Platform.isAndroid) {
    try {
    final result = await mainChannel.invokeMethod<List<Map<String, String>>>('querySms');
    // convert list of maps to sms messages
    return result;
  } on PlatformException catch (e) {
    stderr.writeln(e.message);
    return null;
  }
  } else {
    final List<SmsMessage> fakesms = [
    ];
    print("(No implementation) Querying sms... sms:$fakesms");
  }
}



void sendSms(String body, String phoneNumber) async {
  if (Platform.isAndroid) {
    await mainChannel.invokeMethod('sendSms', {"body":body, "phoneNumber":phoneNumber});
  } else {
    print("(No implementation) Sending sms... body:$body  phoneNumber:$phoneNumber");
  }
  
}


// todo setup notifier