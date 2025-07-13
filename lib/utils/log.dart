import "dart:io";

import "package:device_info_plus/device_info_plus.dart" show DeviceInfoPlugin;
import "package:flutter/material.dart";
import "package:logging/logging.dart";
import "package:package_info_plus/package_info_plus.dart" show PackageInfo;
import "package:permission_handler/permission_handler.dart";
import "package:vidar/configuration.dart";
import "package:vidar/pages/contact_list.dart";
import "package:vidar/utils/common_object.dart";
import "package:vidar/utils/navigation.dart";
import "package:vidar/utils/settings.dart";
import "package:vidar/widgets/error_popup.dart";

Future<void> createLogger() async {
  CommonObject.logger = Logger(LoggingConfiguration.loggerName);
  if (hierarchicalLoggingEnabled) {
    CommonObject.logger!.level = Level.ALL;
  }
  CommonObject.logger!.onRecord.listen((final LogRecord log) {
    late final String logMessage;
    switch (log.level) {
      case Level.INFO:
        logMessage = LoggingConfiguration.conciseLogMessage(log);
      case Level.CONFIG:
        logMessage = LoggingConfiguration.minimalLogMessage(log);
      default:
        logMessage = LoggingConfiguration.verboseLogMessage(log);
    }

    debugPrint(logMessage);
    CommonObject.logs.add(logMessage);
  });

  CommonObject.logger!.config(
    LoggingConfiguration.initLog(
      packageInfo: await PackageInfo.fromPlatform(),
      deviceInfo: await DeviceInfoPlugin().androidInfo,
    ),
  );
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

const Level initLog = const Level("INIT", 601);
