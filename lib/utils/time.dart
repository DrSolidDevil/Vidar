extension TimeFormatting on DateTime {
  String format24HourTime() {
    return "$hour:$minute";
  }

  // If time is
  String format12HourTime() {
    final bool isAM = hour < 12;
    int h = hour;
    if (!isAM) {
      h -= 12;
    } else if (h == 0) {
      h = 12;
    }
    return "$h:$minute ${isAM ? "a.m." : "p.m."}";
  }
}
