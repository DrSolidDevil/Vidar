import "dart:io";

import "package:file_selector/file_selector.dart";
import "package:vidar/configuration.dart";
import "package:vidar/utils/common_object.dart";

Future<void> exportLogs() async {
  final FileSaveLocation? path = await getSaveLocation(suggestedName: LoggingConfiguration.logFileDefaultName);

  if (path != null) {
    final File file = File(path.path);
    await file.writeAsString(CommonObject.logs.join("\n"));
  } else {
  }
}
