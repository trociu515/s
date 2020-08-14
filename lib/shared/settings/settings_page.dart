import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:give_job/employee/employee_side_bar.dart';
import 'package:give_job/internationalization/localization/localization_constants.dart';
import 'package:give_job/shared/dialog/bug_report_dialog.dart';
import 'package:give_job/shared/libraries/colors.dart';
import 'package:give_job/shared/libraries/constants.dart';
import 'package:give_job/shared/service/toastr_service.dart';
import 'package:give_job/shared/widget/app_bar.dart';
import 'package:give_job/shared/widget/texts.dart';
import 'package:url_launcher/url_launcher.dart';

class SettingsPage extends StatefulWidget {
  final String _id;
  final String _userInfo;
  final String _authHeader;

  SettingsPage(this._id, this._userInfo, this._authHeader);

  @override
  _SettingsPageState createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: APP_NAME,
      theme: ThemeData(primarySwatch: MaterialColor(0xffFFFFFF, WHITE_RGBO)),
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        backgroundColor: DARK,
        appBar: appBar(context, getTranslated(context, 'settings')),
        drawer: employeeSideBar(
            context, widget._id, widget._userInfo, widget._authHeader),
        body: ListView(
          children: <Widget>[
            _titleContainer(getTranslated(context, 'account')),
            Container(
                margin: EdgeInsets.only(left: 15, top: 10),
                child: InkWell(
                    child: _subtitleInkWellContainer(
                        getTranslated(context, 'changePassword')))),
            _titleContainer(getTranslated(context, 'other')),
            Container(
                margin: EdgeInsets.only(left: 15, top: 10),
                child: InkWell(
                    child: _subtitleInkWellContainer(
                        getTranslated(context, 'language')))),
            Container(
                margin: EdgeInsets.only(left: 15, top: 10),
                child: InkWell(
                    child: _subtitleInkWellContainer(
                        getTranslated(context, 'theme')))),
            Container(
                margin: EdgeInsets.only(left: 15, top: 10),
                child: InkWell(
                    onTap: () => bugReportDialog(context),
                    child: _subtitleInkWellContainer(
                        getTranslated(context, 'bugReport')))),
            Container(
                margin: EdgeInsets.only(left: 15),
                padding: EdgeInsets.only(left: 10),
                alignment: Alignment.centerLeft,
                height: 30,
                child: text10White(
                    getTranslated(context, 'version') + ': 1.0.8+9')),
            _titleContainer(getTranslated(context, 'followUs')),
            _socialMediaInkWell(
              context,
              'https://www.givejob.pl',
              'GiveJob',
              'images/logo.png',
            ),
            SizedBox(height: 5.0),
            _socialMediaInkWell(
              context,
              'https://www.facebook.com/givejobb',
              'Facebook',
              'images/facebook-logo.png',
            ),
            SizedBox(height: 5.0),
            _socialMediaInkWell(
              context,
              'https://www.instagram.com/give_job',
              'Instagram',
              'images/instagram-logo.png',
            ),
            SizedBox(height: 5.0),
            _socialMediaInkWell(
              context,
              null,
              'Linkedin',
              'images/linkedin-logo.png',
            ),
            SizedBox(height: 5.0),
          ],
        ),
      ),
    );
  }
}

Container _titleContainer(String text) {
  return Container(
    margin: EdgeInsets.only(left: 15, top: 15),
    decoration: BoxDecoration(border: Border.all(color: BRIGHTER_DARK)),
    padding: EdgeInsets.only(left: 10),
    alignment: Alignment.centerLeft,
    height: 60,
    child: text20GreenBold(text),
  );
}

Container _subtitleInkWellContainer(String text) {
  return Container(
    decoration: BoxDecoration(border: Border.all(color: BRIGHTER_DARK)),
    padding: EdgeInsets.only(left: 10),
    alignment: Alignment.centerLeft,
    height: 30,
    child: text16White(text),
  );
}

InkWell _socialMediaInkWell(
    BuildContext context, String url, String text, String imagePath) {
  return InkWell(
    onTap: () async => _launchURL(context, url),
    child: ListTile(
      title: Align(
        child: text16White(text),
        alignment: Alignment(-1.05, 0),
      ),
      leading: Padding(
        padding: EdgeInsets.all(5.0),
        child: Container(
          child: Image(
            image: AssetImage(imagePath),
            fit: BoxFit.fitWidth,
          ),
        ),
      ),
    ),
  );
}

_launchURL(BuildContext context, String url) async {
  await canLaunch(url)
      ? await launch(url)
      : ToastService.showToast(
          getTranslated(context, 'couldNotLaunch'), Colors.red);
}
