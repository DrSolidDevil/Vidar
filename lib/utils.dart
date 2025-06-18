import 'package:flutter/material.dart';
import 'package:sms_advanced/sms_advanced.dart';

class Updater extends ChangeNotifier {
  void update() {
    notifyListeners();
  }
}

SmsMessage copySmsMessage(SmsMessage message, {String? address, String? body, 
DateTime? date, DateTime? dateSent, int? id, SmsMessageKind? kind, bool? read, int? sim, int? threadId}) {
  return SmsMessage(
    address ?? message.address,
    body ?? message.body,
    date: date ?? message.date,
    dateSent: dateSent ?? message.dateSent,
    id: id ?? message.id,
    kind: kind ?? message.kind,
    read: read ?? message.isRead,
    sim: sim ?? message.sim,
    threadId: threadId ?? message.threadId

  );
}
