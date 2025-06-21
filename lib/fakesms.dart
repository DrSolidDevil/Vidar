import 'sms.dart';


List<SmsMessage> fakesms = [
      SmsMessage(
        "Hello",
        "123456789",
        date: DateTime(2025, 6, 20, 12, 0, 0),
        status: SmsConstants.STATUS_COMPLETE,
        type: SmsConstants.MESSAGE_TYPE_INBOX,
      ),
      SmsMessage(
        "Hi, how are you",
        "123456789",
        dateSent: DateTime(2025, 6, 20, 12, 1, 23),
        status: SmsConstants.STATUS_COMPLETE,
        type: SmsConstants.MESSAGE_TYPE_SENT,
      ),
      SmsMessage(
        "I'm fine",
        "123456789",
        date: DateTime(2025, 6, 20, 12, 5, 28),
        status: SmsConstants.STATUS_COMPLETE,
        type: SmsConstants.MESSAGE_TYPE_INBOX,
      ),
      SmsMessage(
        "You know, it's annoying having to make an entire api for sms when the other one wont work",
        "123456789",
        dateSent: DateTime(2025, 6, 20, 12, 6, 40),
        status: SmsConstants.STATUS_COMPLETE,
        type: SmsConstants.MESSAGE_TYPE_SENT,
      ),
      SmsMessage(
        "Indeeed it is",
        "123456789",
        date: DateTime(2025, 6, 20, 12, 8, 54),
        status: SmsConstants.STATUS_COMPLETE,
        type: SmsConstants.MESSAGE_TYPE_INBOX,
      ),
    ];