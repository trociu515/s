import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:give_job/internationalization/language/language.dart';
import 'package:give_job/internationalization/localization/localization_constants.dart';
import 'package:give_job/login_page.dart';
import 'package:give_job/main.dart';

class GetStartedPage extends StatefulWidget {
  @override
  _GetStartedPageState createState() => _GetStartedPageState();
}

class _GetStartedPageState extends State<GetStartedPage> {
  List<Language> _languages = Language.getLanguages();
  List<DropdownMenuItem<Language>> _dropdownMenuItems;
  Language _selectedLanguage;

  @override
  void initState() {
    _dropdownMenuItems = buildDropdownMenuItems(_languages);
    _selectedLanguage = _dropdownMenuItems[1].value;
    super.initState();
  }

  List<DropdownMenuItem<Language>> buildDropdownMenuItems(List languages) {
    List<DropdownMenuItem<Language>> items = List();
    for (Language language in languages) {
      items.add(
        DropdownMenuItem(
          value: language,
          child: Text(language.name + ' ' + language.flag),
        ),
      );
    }
    return items;
  }

  @override
  Widget build(BuildContext context) {
    void _changeLanguage(Language language, BuildContext context) async {
      setState(() {
        _selectedLanguage = language;
      });
      Locale _temp = await setLocale(language.languageCode);
      MyApp.setLocale(context, _temp);
    }

    return Scaffold(
      backgroundColor: Color(0xff303030),
      body: Container(
        margin: EdgeInsets.symmetric(horizontal: 40),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Image.asset(
              'images/logo.png',
              height: 250,
            ),
            SizedBox(
              height: 20,
            ),
            Text(
              getTranslated(context, 'welcomeTitle'),
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.white, fontSize: 28),
            ),
            SizedBox(height: 20),
            Text(
              getTranslated(context, 'welcomeDescription'),
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.white, fontSize: 16),
            ),
            SizedBox(
              height: 30,
            ),
            MaterialButton(
              elevation: 0,
              height: 50,
              shape: new RoundedRectangleBorder(
                borderRadius: new BorderRadius.circular(30.0),
              ),
              onPressed: () {
                storage.write(key: 'getStartedClick', value: 'click');
                Navigator.push(
                    context, MaterialPageRoute(builder: (_) => LoginPage()));
              },
              color: Color(0xffb5d76d),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Text(getTranslated(context, 'getStarted'),
                      style: TextStyle(color: Colors.white, fontSize: 20)),
                  Icon(Icons.arrow_forward_ios)
                ],
              ),
              textColor: Colors.white,
            ),
            SizedBox(
              height: 30,
            ),
            Text(getTranslated(context, 'selectLanguage'),
                style: TextStyle(color: Colors.white, fontSize: 20)),
            Container(
              child: Center(
                child: Theme(
                  data: Theme.of(context).copyWith(
                    canvasColor: Color(0xff303030),
                  ),
                  child: Column(
                    children: <Widget>[
                      DropdownButtonHideUnderline(
                        child: DropdownButton(
                          style: TextStyle(color: Colors.white, fontSize: 20),
                          value: _selectedLanguage,
                          items: _dropdownMenuItems,
                          onChanged: (Language language) {
                            _changeLanguage(language, context);
                          },
                        ),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                    ],
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
