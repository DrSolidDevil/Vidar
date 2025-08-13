Uri generateMailtoURL(
  final String address,
  final String subject,
  final String body,
) {
  return Uri.parse(
    "mailto:$address?subject=${encodeStringToUri(subject)}&body=${encodeStringToUri(body)}",
  );
}

Uri encodeStringToUri(final String str) {
  return Uri.parse(
    str
        .replaceAll("!", "%21")
        .replaceAll("#", "%23")
        .replaceAll(r"$", "%24")
        .replaceAll("&", "%26")
        .replaceAll("'", "%27")
        .replaceAll("(", "%28")
        .replaceAll(")", "%29")
        .replaceAll("*", "%2A")
        .replaceAll("+", "%2B")
        .replaceAll(",", "%2C")
        .replaceAll("/", "%2F")
        .replaceAll(":", "%3A")
        .replaceAll(";", "%3B")
        .replaceAll("=", "%3D")
        .replaceAll("?", "%3F")
        .replaceAll("@", "%40")
        .replaceAll("[", "%5B")
        .replaceAll("]", "%5D"),
  );
}
