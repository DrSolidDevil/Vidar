import "dart:io";

import "package:flutter/material.dart";
import "package:logging/logging.dart";
import "package:permission_handler/permission_handler.dart";
import "package:vidar/configuration.dart";
import "package:vidar/pages/contact_list.dart";
import "package:vidar/utils/common_object.dart";
import "package:vidar/utils/navigation.dart";
import "package:vidar/utils/settings.dart";
import "package:vidar/widgets/error_popup.dart";

void createLogger() {
  CommonObject.logger = Logger(LoggingConfiguration.loggerName);
  CommonObject.logger!.onRecord.listen((final LogRecord log) {
    if (log.level != Level.INFO && log.level != Level.CONFIG) {
      debugPrint(LoggingConfiguration.verboseLogMessage(log));
      CommonObject.logs.add(LoggingConfiguration.verboseLogMessage(log));
    } else {
      debugPrint(LoggingConfiguration.conciseLogMessage(log));
      CommonObject.logs.add(LoggingConfiguration.conciseLogMessage(log));
    }
  });
}

Future<void> exportLogs({final BuildContext? context}) async {
  late final File file;
  try {
    if ((await Permission.manageExternalStorage.request()).isDenied) {
      throw Exception("MANAGE_EXTERNAL_STORAGE permission is denied");
    }

    final Directory directory = Directory(
      LoggingConfiguration.logFileSaveLocation,
    );
    if (!directory.existsSync()) {
      throw Exception(
        'The directory "${LoggingConfiguration.logFileSaveLocation}" does not exist',
      );
    }
    file =
        File(
            "${directory.path}${Platform.pathSeparator}${LoggingConfiguration.logFileName()}",
          )
          ..createSync()
          ..writeAsStringSync(CommonObject.logs.join());
  } on Exception catch (error, stackTrace) {
    if (context != null && context.mounted) {
      showDialog<void>(
        context: context,
        builder: (final BuildContext context) => ErrorPopup(
          title: "Failed to export logs",
          body: error.toString(),
          enableReturn: false,
        ),
      );
    }

    if (Settings.keepLogs) {
      CommonObject.logger!.warning("Failed to export logs", error, stackTrace);
    }

    return;
  }

  if (context != null && context.mounted) {
    showDialog<void>(
      context: context,
      builder: (final BuildContext context) => AlertDialog(
        title: const Text("Logs exported"),
        content: Text('Logs have been exported to "${file.path}"'),
        actions: <Widget>[
          TextButton(
            onPressed: () =>
                clearNavigatorAndPush(context, const ContactListPage()),
            child: const Text("Dismiss"),
          ),
        ],
      ),
    );
  }

  if (LoggingConfiguration.extraVerboseLogs && Settings.keepLogs) {
    CommonObject.logger!.info('Logs have been exported to "${file.path}"');
  }
}
