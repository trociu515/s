import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:give_job/internationalization/localization/localization_constants.dart';
import 'package:give_job/manager/dto/manager_dto.dart';
import 'package:give_job/manager/groups/manager_groups_page.dart';
import 'package:give_job/manager/manager_side_bar.dart';
import 'package:give_job/manager/service/manager_service.dart';
import 'package:give_job/shared/libraries/colors.dart';
import 'package:give_job/shared/libraries/constants.dart';
import 'package:give_job/shared/model/user.dart';
import 'package:give_job/shared/service/logout_service.dart';
import 'package:give_job/shared/settings/settings_page.dart';
import 'package:give_job/shared/util/language_util.dart';
import 'package:give_job/shared/widget/icons.dart';
import 'package:give_job/shared/widget/loader.dart';
import 'package:give_job/shared/widget/texts.dart';

import '../manager_app_bar.dart';

class ManagerProfilePage extends StatefulWidget {
  final User _user;

  ManagerProfilePage(this._user);

  @override
  _ManagerProfilePageState createState() => _ManagerProfilePageState();
}

class _ManagerProfilePageState extends State<ManagerProfilePage> {
  final ManagerService _managerService = new ManagerService();
  ManagerDto _manager;

  User _user;

  @override
  Widget build(BuildContext context) {
    _user = widget._user;
    return MaterialApp(
      title: APP_NAME,
      theme: ThemeData(primarySwatch: MaterialColor(0xffFFFFFF, WHITE_RGBO)),
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        backgroundColor: DARK,
        appBar: managerAppBar(context, _user, 'Profile'),
        drawer: managerSideBar(context, _user),
        body: SingleChildScrollView(
          child: Center(
            child: Column(
              children: <Widget>[
                Container(
                  width: 150,
                  height: 150,
                  margin: EdgeInsets.only(top: 20, bottom: 10),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    image: DecorationImage(
                        image: AssetImage('images/logo.png'), fit: BoxFit.fill),
                  ),
                ),
                Column(
                  children: <Widget>[
                    text25White(utf8.decode(
                        _user.info != null ? _user.info.runes.toList() : '-')),
                    SizedBox(height: 2.5),
                    text20White(LanguageUtil.convertShortNameToFullName(
                            _user.nationality) +
                        ' ' +
                        LanguageUtil.findFlagByNationality(_user.nationality)),
                    SizedBox(height: 2.5),
                    text18White(
                        getTranslated(context, 'manager') + ' #' + _user.id),
                    SizedBox(height: 10),
                    _buildButton(
                      'See my groups',
                      Icons.group,
                      () => {
                        Navigator.of(context).push(
                          CupertinoPageRoute<Null>(
                            builder: (BuildContext context) {
                              return ManagerGroupsPage(_user);
                            },
                          ),
                        ),
                      },
                    ),
                    _buildButton(
                      'About me',
                      Icons.info,
                      () => {
                        showGeneralDialog(
                          context: context,
                          barrierColor: DARK.withOpacity(0.95),
                          barrierDismissible: false,
                          barrierLabel: 'Hours',
                          transitionDuration: Duration(milliseconds: 400),
                          pageBuilder: (_, __, ___) {
                            return FutureBuilder<ManagerDto>(
                              future: _managerService.findById(
                                  widget._user.id, widget._user.authHeader),
                              builder: (BuildContext context,
                                  AsyncSnapshot<ManagerDto> snapshot) {
                                if (snapshot.connectionState ==
                                        ConnectionState.waiting ||
                                    snapshot.data == null) {
                                  return loader(
                                    managerAppBar(context, null,
                                        getTranslated(context, 'loading')),
                                    managerSideBar(context, widget._user),
                                  );
                                } else {
                                  _manager = snapshot.data;
                                  return Padding(
                                    padding: EdgeInsets.only(top: 60),
                                    child: Scaffold(
                                      backgroundColor: Colors.black12,
                                      body: SingleChildScrollView(
                                        child: Center(
                                          child: Column(
                                            children: <Widget>[
                                              _buildBasicInformationsSection(),
                                              _buildContactSection(),
                                              _buildGroupSection(),
                                            ],
                                          ),
                                        ),
                                      ),
                                      bottomNavigationBar: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: <Widget>[
                                          Padding(
                                            padding:
                                                EdgeInsets.only(bottom: 20),
                                            child: MaterialButton(
                                              elevation: 0,
                                              height: 50,
                                              minWidth: 100,
                                              shape: new RoundedRectangleBorder(
                                                  borderRadius:
                                                      new BorderRadius.circular(
                                                          30.0)),
                                              child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                children: <Widget>[
                                                  iconWhite(Icons.close)
                                                ],
                                              ),
                                              color: Colors.red,
                                              onPressed: () =>
                                                  Navigator.pop(context),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  );
                                }
                              },
                            );
                          },
                        ),
                      },
                    ),
                    _buildButton(
                      'Settings',
                      Icons.settings,
                      () => {
                        Navigator.of(context).push(
                          CupertinoPageRoute<Null>(
                            builder: (BuildContext context) {
                              return SettingsPage(_user);
                            },
                          ),
                        ),
                      },
                    ),
                    _buildButton('Logout', Icons.exit_to_app,
                        () => Logout.logout(context)),
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildButton(String text, IconData icon, Function() fun) {
    return Padding(
      padding: EdgeInsets.only(top: 20),
      child: MaterialButton(
        elevation: 0,
        height: 50,
        shape: new RoundedRectangleBorder(
            borderRadius: new BorderRadius.circular(30.0)),
        onPressed: () => fun(),
        color: GREEN,
        child: Container(
          width: 250,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              text20White(text),
              iconWhite(icon),
            ],
          ),
        ),
        textColor: Colors.white,
      ),
    );
  }

  Widget _buildBasicInformationsSection() {
    return Column(
      children: <Widget>[
        _buildSectionTitle(getTranslated(context, 'basicInformations')),
        _buildListTile(
            getTranslated(context, 'name'),
            utf8.decode(_manager.name != null
                ? _manager.name.runes.toList()
                : getTranslated(context, 'empty'))),
        _buildListTile(
            getTranslated(context, 'surname'),
            utf8.decode(_manager.surname != null
                ? _manager.surname.runes.toList()
                : getTranslated(context, 'empty'))),
        _buildListTile(
            getTranslated(context, 'username'),
            utf8.decode(_manager.username != null
                ? _manager.username.runes.toList()
                : getTranslated(context, 'empty'))),
        _buildListTile(
            getTranslated(context, 'nationality'),
            _manager.nationality != null && _manager.nationality != 'Brak'
                ? LanguageUtil.findFlagByNationality(_manager.nationality) +
                    ' ' +
                    utf8.decode(_manager.nationality.runes.toList())
                : getTranslated(context, 'empty')),
      ],
    );
  }

  Widget _buildContactSection() {
    return Column(
      children: <Widget>[
        _buildSectionTitle(getTranslated(context, 'contact')),
        _buildListTile(
            getTranslated(context, 'email'),
            utf8.decode(_manager.email != null
                ? _manager.email.runes.toList()
                : getTranslated(context, 'empty'))),
        _buildListTile(
            getTranslated(context, 'phoneNumber'),
            _manager.phoneNumber != null
                ? _manager.phoneNumber
                : getTranslated(context, 'empty')),
        _buildListTile(
            getTranslated(context, 'viberNumber'),
            _manager.viberNumber != null
                ? _manager.viberNumber
                : getTranslated(context, 'empty')),
        _buildListTile(
            getTranslated(context, 'whatsAppNumber'),
            _manager.whatsAppNumber != null
                ? _manager.whatsAppNumber
                : getTranslated(context, 'empty')),
      ],
    );
  }

  Widget _buildGroupSection() {
    return Column(
      children: <Widget>[
        _buildSectionTitle(getTranslated(context, 'group')),
        _buildListTile(
            getTranslated(context, 'numberOfGroups'),
            _manager.numberOfGroups != null
                ? _manager.numberOfGroups.toString()
                : getTranslated(context, 'empty')),
        _buildListTile(
            getTranslated(context, 'numberOfEmployeesInGroups'),
            _manager.numberOfEmployeesInGroups != null
                ? _manager.numberOfEmployeesInGroups.toString()
                : getTranslated(context, 'empty')),
      ],
    );
  }

  Widget _buildSectionTitle(String text) {
    return Column(
      children: <Widget>[
        Container(width: 200, child: Divider(color: WHITE)),
        text20GreenBold(text),
        Container(width: 200, child: Divider(color: WHITE)),
      ],
    );
  }

  Widget _buildListTile(String title, String subtile) {
    return ListTile(
      title: textCenter18WhiteBold(title),
      subtitle: textCenter16White(subtile),
    );
  }
}
