import "dart:math";

import "package:flutter/material.dart";
import "package:vidar/configuration.dart";
import "package:vidar/utils/common_object.dart";
import "package:vidar/utils/contact.dart";
import "package:vidar/utils/encryption.dart";
import "package:vidar/utils/extended_change_notifier.dart";
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
  ExtendedChangeNotifier errorNotifier = ExtendedChangeNotifier();
  final TextEditingController controller = TextEditingController();
  final ScrollController _scrollController = ScrollController();

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
      color: Settings.colorSet.tertiary,
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom > 50
            ? MediaQuery.of(context).viewInsets.bottom + 10
            : 50,
        left: 20,
        right: 20,
        top: 10,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          SizedBox(
            width: MediaQuery.of(context).size.width * 0.75,
            child: Text(
              text,
              style: TextStyle(
                color: Settings.colorSet.secondary,
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
          ),
          IconButton(
            onPressed: () {
              error = false;
              errorNotifier.notifyListeners();
            },
            icon: Icon(Icons.sms, color: Settings.colorSet.secondary),
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
          Future<void>.delayed(
            const Duration(
              seconds: TimeConfiguration.messageWidgetErrorDisplayTime,
            ),
          ).then((_) {
            error = false;
            errorNotifier.notifyListeners();
          });
          switch (errorMessage) {
            case ENCRYPTION_ERROR_NO_KEY:
              return buildErrorMessageWidget(
                context,
                "No key set for contact, either disable key requirement or set a key",
              );
            case ENCRYPTION_ERROR_DECRYPTION_FAILED:
              return buildErrorMessageWidget(
                context,
                "Decryption of message failed, please ensure your key is correct",
              );
            case ENCRYPTION_ERROR_ENCRYPTION_FAILED:
              return buildErrorMessageWidget(
                context,
                "Encryption of message failed",
              );
            default:
              return buildErrorMessageWidget(context, "Unknown error");
          }
        } else {
          return Container(
            color: Settings.colorSet.secondary,
            padding: EdgeInsets.only(
              bottom: MediaQuery.of(context).viewInsets.bottom > 50
                  ? MediaQuery.of(context).viewInsets.bottom + 10
                  : 50,
            ),
            child: Padding(
              padding: const EdgeInsets.only(top: 5.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  Container(
                    decoration: BoxDecoration(
                      color: Settings.colorSet.primary,
                      borderRadius: BorderRadius.circular(4.0),
                    ),
                    padding: const EdgeInsets.only(left: 10.0),
                    width:
                        MediaQuery.sizeOf(context).width -
                        SizeConfiguration.sendMessageIconSize * 2.5,
                    child: ConstrainedBox(
                      constraints: const BoxConstraints(maxHeight: 150),
                      child: RawScrollbar(
                        thickness: 2,
                        padding: const EdgeInsets.only(bottom: -30),
                        radius: const Radius.circular(1),
                        controller: _scrollController,
                        thumbColor: Settings.colorSet.messageBarScrollbar,
                        thumbVisibility: true,
                        child: TextField(
                          scrollController: _scrollController,
                          maxLines: null,
                          controller: controller,
                          style: TextStyle(color: Settings.colorSet.text),
                          decoration: InputDecoration(
                            hintText: () {
                              if (Settings.showMessageBarHints) {
                                return ChatConfiguration
                                    .messageHints[Random().nextInt(
                                  ChatConfiguration.messageHints.length,
                                )];
                              } else {
                                return null;
                              }
                            }(),
                            hintStyle: TextStyle(
                              color: Settings.colorSet.messageBarHintText,
                            ),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10.0),
                              borderSide: BorderSide.none,
                            ),
                          ),
                          onChanged: (final String value) => message = value,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    width: 50.0,
                    height: 60.0,
                    child: Center(
                      child: IconButton(
                        onPressed: () async {
                          final String encryptedMessage = await encryptMessage(
                            message,
                            contact.encryptionKey,
                          );
                          if (encryptedMessage.startsWith(
                            ChatConfiguration.errorPrefix,
                          )) {
                            errorMessage = encryptedMessage.replaceFirst(
                              ChatConfiguration.errorPrefix,
                              "",
                            );
                            error = true;
                            errorNotifier.notifyListeners();
                          } else {
                            sendSms(encryptedMessage, contact.phoneNumber);
                            controller.text =
                                ""; // Clear only after successful send
                            if (CommonObject.currentConversation != null) {
                              int delay =
                                  (encryptedMessage.length ~/ 65) *
                                  TimeConfiguration.smsUpdateDelay;
                              delay = delay == 0 ? 1 : delay;
                              Future<void>.delayed(
                                Duration(seconds: delay),
                              ).then((_) {
                                CommonObject.currentConversation!
                                    .notifyListeners();
                              });
                            } else if (Settings.keepLogs) {
                              CommonObject.logger!.info(
                                "Current conversation is null, can not notifyListeners",
                              );
                            }
                          }
                        },
                        icon: Icon(
                          size: SizeConfiguration.sendMessageIconSize,
                          Icons.send,
                          color: Settings.colorSet.sendButton,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        }
      },
    );
  }
}
