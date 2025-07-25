import "package:flutter/material.dart";
import "package:vidar/configuration.dart";
import "package:vidar/utils/settings.dart";
import "package:vidar/utils/sms.dart";

class SpeechBubble extends StatelessWidget {
  const SpeechBubble(this.message, {super.key});
  final SmsMessage message;

  @override
  Widget build(final BuildContext context) {
    final bool isMe = (message.type == SmsConstants.MESSAGE_TYPE_SENT);
    return Align(
      alignment: isMe ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: EdgeInsets.only(
          top: SizeConfiguration.messageVerticalSeperation,
          bottom: SizeConfiguration.messageVerticalSeperation,
          left: isMe ? 0 : SizeConfiguration.messageIndent,
          right: isMe ? SizeConfiguration.messageIndent : 0,
        ),
        child: Column(
          crossAxisAlignment: isMe
              ? CrossAxisAlignment.end
              : CrossAxisAlignment.start,
          children: <Widget>[
            ConstrainedBox(
              constraints: BoxConstraints(
                maxWidth: MediaQuery.of(context).size.width * 0.75,
              ),
              child: Container(
                padding: const EdgeInsets.symmetric(
                  vertical: 10,
                  horizontal: 10,
                ),
                decoration: BoxDecoration(
                  color: isMe
                      ? Settings.colorSet.secondary
                      : Settings.colorSet.tertiary,
                  borderRadius: BorderRadius.only(
                    topLeft: const Radius.circular(10),
                    topRight: const Radius.circular(10),
                    bottomLeft: Radius.circular(isMe ? 10 : 0),
                    bottomRight: Radius.circular(isMe ? 0 : 10),
                  ),
                ),
                child: Text(
                  message.body,
                  style: TextStyle(color: Settings.colorSet.text, fontSize: 12),
                ),
              ),
            ),
            Container(
              margin: const EdgeInsets.only(top: 2.0, bottom: 2.0),
              child: Text(
                (isMe ? "Sent at " : "Received at ") +
                    message.date!.toIso8601String().substring(11, 16),
                style: const TextStyle(color: Colors.white, fontSize: 8),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
