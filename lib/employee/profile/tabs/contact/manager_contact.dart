import 'package:flutter/cupertino.dart';
import 'package:give_job/shared/libraries/colors.dart';
import 'package:give_job/shared/widget/contact_section.dart';
import 'package:slide_popup_dialog/slide_popup_dialog.dart' as slideDialog;

void showManagerContact(BuildContext context, String email, String phone,
    String viber, String whatsApp) {
  slideDialog.showSlideDialog(
    context: context,
    backgroundColor: DARK,
    child: Column(
      children: <Widget>[
        buildContactSection(context, email, phone, viber, whatsApp),
      ],
    ),
  );
}
