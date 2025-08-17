import "package:flutter/material.dart";
import "package:url_launcher/url_launcher.dart";
import "package:vidar/configuration.dart";
import "package:vidar/pages/contact_list.dart";
import "package:vidar/utils/common_object.dart";
import "package:vidar/utils/navigation.dart";
import "package:vidar/utils/settings.dart";
import "package:vidar/utils/url.dart";
import "package:vidar/widgets/buttons.dart";
import "package:vidar/widgets/error_popup.dart";

class FeedbackPage extends StatefulWidget {
  const FeedbackPage({super.key});

  @override
  _FeedbackPageState createState() => _FeedbackPageState();
}

class _FeedbackPageState extends State<FeedbackPage> {
  String body = "";
  final ScrollController _scrollController = ScrollController();

  @override
  Widget build(final BuildContext context) {
    final double formWidth = MediaQuery.of(context).size.width;
    final double formHeight = MediaQuery.of(context).size.height / 3.2;

    return Scaffold(
      backgroundColor: Settings.colorSet.primary,
      appBar: AppBar(
        backgroundColor: Settings.colorSet.secondary,
        title: Text(
          "Vidar – For Privacy's Sake",
          style: TextStyle(
            fontSize: 18,
            color: Settings.colorSet.text,
            decoration: TextDecoration.none,
          ),
        ),

        leading: Container(
          margin: const EdgeInsets.only(left: 10),
          child: IconButton(
            onPressed: () {
              clearNavigatorAndPush(context, const ContactListPage());
            },
            icon: Icon(Icons.arrow_back, color: Settings.colorSet.text),
            tooltip: "Go back",
          ),
        ),
      ),
      body: Column(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.only(top: 20),
            child: Text(
              "Feedback",
              style: TextStyle(color: Settings.colorSet.text, fontSize: 24),
            ),
          ),
          Text(
            "Sent via mail.",
            style: TextStyle(
              fontStyle: FontStyle.italic,
              color: Settings.colorSet.text,
            ),
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.only(
                  left: 30,
                  right: 30,
                  top: 30,
                  bottom: 20,
                ),
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: Settings.colorSet.secondary,
                      width: 3,
                    ),
                    borderRadius: BorderRadius.circular(10),
                    color: Settings.colorSet.feedbackBackground,
                  ),
                  child: ConstrainedBox(
                    constraints: BoxConstraints(
                      maxWidth: formWidth,
                      maxHeight: formHeight,
                      minWidth: formWidth,
                      minHeight: formHeight,
                    ),
                    child: RawScrollbar(
                      thumbColor: Settings.colorSet.feedbackScrollbar,
                      interactive: true,
                      controller: _scrollController,
                      thickness: 3,
                      padding: const EdgeInsets.only(top: 5, bottom: -10),
                      thumbVisibility: true,
                      radius: const Radius.circular(2),
                      child: TextField(
                        maxLines: null,
                        scrollController: _scrollController,
                        keyboardType: TextInputType.multiline,
                        style: TextStyle(
                          color: Settings.colorSet.feedbackText,
                          fontSize: SizeConfiguration.feedbackFormFontSize,
                        ),
                        decoration: InputDecoration(
                          contentPadding: const EdgeInsets.symmetric(
                            horizontal: 10,
                            vertical: 10,
                          ),
                          hintText:
                              "Tell us what you think! Anything to improve or add?",
                          hintStyle: TextStyle(
                            color: Settings.colorSet.feedbackHintText,
                          ),
                          border: InputBorder.none,
                        ),
                        onChanged: (final String value) => body = value,
                      ),
                    ),
                  ),
                ),
              ),
              BasicButton(
                buttonText: "Send Feedback",
                textColor: Settings.colorSet.text,
                buttonColor: Settings.colorSet.secondary,
                width: 200,
                onPressed: () async {
                  final Uri mailto = generateMailtoURL(
                    MiscellaneousConfiguration.userFeedbackEmailAddress,
                    "Vidar Feedback",
                    body,
                  );
                  try {
                    if (!await launchUrl(mailto)) {
                      if (Settings.keepLogs) {
                        CommonObject.logger!.info(
                          'Failed to launch mailto: "$mailto"',
                        );
                      }
                    }
                  } catch (error, stackTrace) {
                    if (Settings.keepLogs) {
                      CommonObject.logger!.shout(
                        'Failed to launch mailto: "$mailto"',
                        error,
                        stackTrace,
                      );
                    }
                    if (context.mounted) {
                      showDialog<void>(
                        context: context,
                        builder: (final BuildContext context) => ErrorPopup(
                          title: "Failed to launch mailto",
                          body: "$error\n$stackTrace\n$mailto",
                          enableReturn: true,
                        ),
                      );
                    }
                  }
                },
              ),
            ],
          ),
        ],
      ),
    );
  }
}
