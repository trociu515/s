import 'package:bouncing_widget/bouncing_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:give_job/internationalization/localization/localization_constants.dart';
import 'package:give_job/shared/libraries/colors.dart';
import 'package:give_job/shared/util/url_util.dart';
import 'package:give_job/shared/widget/texts.dart';

import 'icons.dart';

Widget buildContactSection(BuildContext context, String email,
    String phoneNumber, String viberNumber, String whatsAppNumber) {
  return SingleChildScrollView(
    child: Column(
      children: <Widget>[
        email != null
            ? _buildEmail(context, email)
            : _buildEmptyListTile(context, 'email'),
        phoneNumber != null
            ? _buildPhoneNumber(context, phoneNumber)
            : _buildEmptyListTile(context, 'phone'),
        viberNumber != null
            ? _buildViber(context, viberNumber)
            : _buildEmptyListTile(context, 'viber'),
        whatsAppNumber != null
            ? _buildWhatsApp(context, whatsAppNumber)
            : _buildEmptyListTile(context, 'whatsApp'),
      ],
    ),
  );
}

Widget _buildEmail(BuildContext context, String email) {
  return ListTile(
    title: text16GreenBold(getTranslated(context, 'email')),
    subtitle: Row(
      children: <Widget>[
        SelectableText(email, style: TextStyle(fontSize: 16, color: WHITE)),
        SizedBox(width: 5),
        IconButton(
          icon: icon30White(Icons.alternate_email),
          onPressed: () => _launchAction(context, 'mailto', email),
        ),
      ],
    ),
  );
}

Widget _buildPhoneNumber(BuildContext context, String phoneNumber) {
  return ListTile(
    title: text16GreenBold(getTranslated(context, 'phone')),
    subtitle: Row(
      children: <Widget>[
        SelectableText(phoneNumber,
            style: TextStyle(fontSize: 16, color: WHITE)),
        SizedBox(width: 5),
        IconButton(
          icon: icon30White(Icons.phone),
          onPressed: () => _launchAction(context, 'tel', phoneNumber),
        ),
        IconButton(
          icon: icon30White(Icons.local_post_office),
          onPressed: () => _launchAction(context, 'sms', phoneNumber),
        ),
      ],
    ),
  );
}

Widget _buildViber(BuildContext context, String viberNumber) {
  return ListTile(
    title: text16GreenBold(getTranslated(context, 'viber')),
    subtitle: Row(
      children: <Widget>[
        SelectableText(viberNumber,
            style: TextStyle(fontSize: 16, color: WHITE)),
        SizedBox(width: 5),
        SizedBox(width: 7.5),
        Padding(
          padding: EdgeInsets.all(4),
          child: Transform.scale(
            scale: 1.2,
            child: BouncingWidget(
              duration: Duration(milliseconds: 100),
              scaleFactor: 2,
              onPressed: () => _launchApp(context, 'viber', viberNumber),
              child: Image(
                width: 40,
                height: 40,
                image: AssetImage('images/viber-logo.png'),
              ),
            ),
          ),
        ),
      ],
    ),
  );
}

Widget _buildWhatsApp(BuildContext context, String whatsAppNumber) {
  return ListTile(
    title: text16GreenBold(getTranslated(context, 'whatsApp')),
    subtitle: Row(
      children: <Widget>[
        SelectableText(whatsAppNumber,
            style: TextStyle(fontSize: 16, color: WHITE)),
        SizedBox(width: 7.5),
        Padding(
          padding: EdgeInsets.all(4),
          child: Transform.scale(
            scale: 1.2,
            child: BouncingWidget(
              duration: Duration(milliseconds: 100),
              scaleFactor: 2,
              onPressed: () => _launchApp(context, 'whatsapp', whatsAppNumber),
              child: Image(
                width: 40,
                height: 40,
                image: AssetImage('images/whatsapp-logo.png'),
              ),
            ),
          ),
        ),
      ],
    ),
  );
}

_launchAction(BuildContext context, String action, String number) async {
  String url = action + ':' + number;
  UrlUtil.launchURL(context, url);
}

_launchApp(BuildContext context, String app, String number) async {
  var url = '$app://send?phone=$number';
  UrlUtil.launchURL(context, url);
}

Widget _buildEmptyListTile(BuildContext context, String title) {
  return ListTile(
    title: text16GreenBold(getTranslated(context, title)),
    subtitle: text16White(getTranslated(context, 'empty')),
  );
}
