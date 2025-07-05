import "package:flutter/material.dart";
import "package:vidar/configuration.dart";
import "package:vidar/utils/common_object.dart";
import "package:vidar/utils/contact.dart";
import "package:vidar/utils/encryption.dart";
import "package:vidar/utils/public_change_notifier.dart";
import "package:vidar/utils/settings.dart";
import "package:vidar/utils/sms.dart";

class MessageBar extends StatefulWidget {
  const MessageBar(this.contact, {super.key});
  final Contact contact;

  @override
  _MessageBarState createState() => _MessageBarState();
}

class _MessageBarState extends State<MessageBar> {
  _MessageBarState();
  late Contact contact;
  String message = "";
  bool error = false;
  String errorMessage = "";
  PublicChangeNotifier errorNotifier = PublicChangeNotifier();
  final TextEditingController controller = TextEditingController();

  @override
  void initState() {
    super.initState();
    contact = widget.contact;
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  Widget buildErrorMessageWidget(
    final BuildContext context,
    final String text,
  ) {
    return Container(
      color: VidarColors.tertiaryGold,
      padding: const EdgeInsets.only(bottom: 50, left: 20, right: 20, top: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          SizedBox(
            width: MediaQuery.of(context).size.width * 0.75,
            child: Text(
              text,
              style: const TextStyle(
                color: VidarColors.secondaryMetallicViolet,
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
          ),
          IconButton(
            onPressed: () => errorNotifier.notifyListeners(),
            icon: const Icon(
              Icons.sms,
              color: VidarColors.secondaryMetallicViolet,
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(final BuildContext context) {
    return ListenableBuilder(
      listenable: errorNotifier,
      builder: (final BuildContext context, final Widget? child) {
        if (error) {
          error = false;
          Future<void>.delayed(
            const Duration(
              seconds: TimeConfiguration.messageWidgetErrorDisplayTime,
            ),
          ).then((_) => errorNotifier.notifyListeners());
          switch (errorMessage) {
            case "MESSAGE_FAILED":
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
                    controller: controller,
                    style: const TextStyle(color: Colors.white),
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: BorderSide.none,
                      ),
                    ),
                    onChanged: (final String value) => message = value,
                  ),
                ),
                SizedBox(
                  width: 50,
                  height: 60,
                  child: Center(
                    child: IconButton(
                      onPressed: () async {
                        final String encryptedMessage = await encryptMessage(
                          message,
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
                          errorNotifier.notifyListeners();
                        } else {
                          sendSms(encryptedMessage, contact.phoneNumber);
                          controller.text =
                              ""; // Clear only after successful send
                          if (CommonObject.currentConversation != null) {
                            CommonObject.currentConversation!.notifyListeners();
                          } else if (Settings.keepLogs) {
                            CommonObject.logger!.info(
                              "Current conversation is null, can not notifyListeners",
                            );
                          }
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
