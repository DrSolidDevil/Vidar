import "dart:io";

import "package:flutter/material.dart"
    show BuildContext, debugPrint, showDialog;
import "package:logging/logging.dart";
import "package:permission_handler/permission_handler.dart";
import "package:vidar/configuration.dart";
import "package:vidar/utils/common_object.dart";
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
        'The directory "${LoggingConfiguration.logFileSaveLocation}" does not exits',
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
      builder: (final BuildContext context) => ErrorPopup(
        title: "Logs exported",
        body: 'Logs have been exported to "${file.path}"',
        enableReturn: false,
      ),
    );
  }

  if (LoggingConfiguration.extraVerboseLogs && Settings.keepLogs) {
    CommonObject.logger!.info('Logs have been exported to "${file.path}"');
  }
}
