import "package:flutter/material.dart";
import "package:vidar/configuration.dart";
import "package:vidar/utils/contact.dart";
import "package:vidar/utils/encryption.dart";
import "package:vidar/utils/sms.dart";
import "package:vidar/utils/updater.dart";

class MessageBar extends StatefulWidget {
  const MessageBar(this.contact, this.updater, {super.key});
  final Contact contact;
  final Updater updater;

  @override
  _MessageBarState createState() => _MessageBarState();
}

class _MessageBarState extends State<MessageBar> {
  _MessageBarState();
  late Contact contact;
  late Updater updater;
  String? message;
  bool error = false;
  String errorMessage = "";
  Updater failUpdater = Updater();

  @override
  void initState() {
    super.initState();
    contact = widget.contact;
    updater = widget.updater;
  }

  Widget buildErrorMessageWidget(
    final BuildContext context,
    final String text,
  ) {
    return ColoredBox(
      color: VidarColors.secondaryMetallicViolet,
      child: Row(
        children: <Widget>[
          Text(text, style: const TextStyle(color: Colors.white)),
          IconButton(
            onPressed: () => failUpdater.update,
            icon: const Icon(Icons.sms, color: Colors.white),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(final BuildContext context) {
    return ListenableBuilder(
      listenable: failUpdater,
      builder: (final BuildContext context, final Widget? child) {
        if (error) {
          error = false;
          Future<void>.delayed(
            const Duration(
              seconds: TimeConfiguration.messageWidgetErrorDisplayTime,
            ),
          ).then((_) => failUpdater.update());
          switch (errorMessage) {
            case "MESSAGE_FAILED":
              debugPrint("MESSAGE_FAILED");
              return buildErrorMessageWidget(context, "Failed to send message");
            case "NO_KEY":
              return buildErrorMessageWidget(
                context,
                "No key set for contact, either disable key requirement or set a key",
              );
            case "DECRYPTION_FAILED":
              return buildErrorMessageWidget(
                context,
                "Decryption of message failed, please ensure your key is correct",
              );
            case "ENCRYPTION_FAILED":
              return buildErrorMessageWidget(
                context,
                "Encryption of message failed",
              );
            default:
              return buildErrorMessageWidget(context, "Unknown error");
          }
        } else {
          return Container(
            color: VidarColors.tertiaryGold,
            padding: EdgeInsets.only(
              bottom: MediaQuery.of(context).viewInsets.bottom > 50
                  ? MediaQuery.of(context).viewInsets.bottom
                  : 50,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                Container(
                  decoration: BoxDecoration(
                    color: VidarColors.secondaryMetallicViolet,
                    borderRadius: BorderRadius.circular(4),
                  ),
                  padding: const EdgeInsets.only(left: 10),
                  width:
                      MediaQuery.sizeOf(context).width -
                      SizeConfiguration.sendMessageIconSize * 2.5,
                  child: TextField(
                    style: const TextStyle(color: Colors.white),
                    decoration: const InputDecoration(border: InputBorder.none),
                    onChanged: (final String value) => message = value,
                  ),
                ),
                SizedBox(
                  width: 50,
                  height: 60,
                  child: Center(
                    child: IconButton(
                      onPressed: () async {
                        debugPrint("Sending message: $message");
                        final String encryptedMessage = await encryptMessage(
                          message!,
                          contact.encryptionKey,
                        );
                        if (encryptedMessage.startsWith(
                          MiscellaneousConfiguration.errorPrefix,
                        )) {
                          errorMessage = encryptedMessage.replaceFirst(
                            MiscellaneousConfiguration.errorPrefix,
                            "",
                          );
                          error = true;
                          failUpdater.update();
                        } else {
                          sendSms(encryptedMessage, contact.phoneNumber);
                          await Future<void>.delayed(
                            const Duration(
                              seconds: TimeConfiguration.smsUpdateDelay,
                            ),
                          );
                          updater.update();
                        }
                      },
                      icon: const Icon(
                        size: SizeConfiguration.sendMessageIconSize,
                        Icons.send,
                        color: VidarColors.secondaryMetallicViolet,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          );
        }
      },
    );
  }
}
