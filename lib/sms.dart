
import 'dart:io';

import 'package:flutter/services.dart';

const mainChannel = MethodChannel("flutter.native/helper");
const smsNotifierChannel = MethodChannel("flutter.native/smsnotifier");


Future<List<Map<String, String>>?> querySms({String? phoneNumber}) async {
  try {
    final result = await mainChannel.invokeMethod<List<Map<String, String>>>('querySms');
    return result;
  } on PlatformException catch (e) {
    stderr.writeln(e.message);
    return null;
  }
}



void sendSms(String body, String phoneNumber) async {
  await mainChannel.invokeMethod('sendSms', {"body":body, "phoneNumber":phoneNumber});
}


// todo setup notifier