import "package:flutter/material.dart";
import "package:go_router/go_router.dart";
import "package:pretty_qr_code/pretty_qr_code.dart";
import "package:vidar/pages/contact_list.dart";
import "package:vidar/utils/navigation.dart";
import "package:vidar/utils/settings.dart";
import "package:vidar/widgets/buttons.dart";

class ContactQrPage extends StatelessWidget {
  const ContactQrPage({required this.uri, super.key});
  final String uri;

  @override
  Widget build(final BuildContext context) {
    return ColoredBox(
      color: Settings.colorSet.primary,
      child: SizedBox.expand(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            SizedBox(
              width: MediaQuery.of(context).size.width * 0.75,
              height: MediaQuery.of(context).size.width * 0.75,
              child: PrettyQrView.data(
                data: uri,
                decoration: PrettyQrDecoration(
                  shape: PrettyQrSmoothSymbol(
                    color: Settings.colorSet.qrCode ?? Settings.colorSet.text,
                    roundFactor: 0.3,
                  ),
                  background: Settings.colorSet.primary,
                ),
              ),
            ),
            BasicButton(
              buttonText: "Dismiss",
              textColor: Settings.colorSet.text,
              buttonColor: Settings.colorSet.secondary,
              onPressed: () =>
                  context.goNamed("ContactListPage")
            ),
          ],
        ),
      ),
    );
  }
}
