import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:give_job/internationalization/localization/localization_constants.dart';
import 'package:give_job/manager/manager_side_bar.dart';
import 'package:give_job/manager/service/manager_service.dart';
import 'package:give_job/shared/libraries/colors.dart';
import 'package:give_job/shared/libraries/constants.dart';
import 'package:give_job/shared/model/user.dart';
import 'package:give_job/shared/widget/loader.dart';
import 'package:give_job/shared/widget/texts.dart';

import '../dto/manager_dto.dart';
import '../manager_app_bar.dart';

class ManagerInformationPage extends StatefulWidget {
  final User _user;

  ManagerInformationPage(this._user);

  @override
  _ManagerInformationPageState createState() => _ManagerInformationPageState();
}

class _ManagerInformationPageState extends State<ManagerInformationPage> {
  final ManagerService _managerService = new ManagerService();

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<ManagerDto>(
      future:
          _managerService.findById(widget._user.id, widget._user.authHeader),
      builder: (BuildContext context, AsyncSnapshot<ManagerDto> snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting ||
            snapshot.data == null) {
          return loader(
            context,
            getTranslated(context, 'loading'),
            managerSideBar(context, widget._user),
          );
        } else {
          ManagerDto manager = snapshot.data;
          return MaterialApp(
            title: APP_NAME,
            theme:
                ThemeData(primarySwatch: MaterialColor(0xffFFFFFF, WHITE_RGBO)),
            debugShowCheckedModeBanner: false,
            home: Scaffold(
              backgroundColor: DARK,
              appBar: managerAppBar(
                  context, widget._user, getTranslated(context, 'home')),
              drawer: managerSideBar(context, widget._user),
              body: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Column(
                    children: <Widget>[
                      Card(
                        color: DARK,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: <Widget>[
                            ListTile(
                              title:
                                  textWhiteBold(getTranslated(context, 'id')),
                              subtitle: textWhite(widget._user.id != null
                                  ? widget._user.id.toString()
                                  : getTranslated(context, 'empty')),
                            ),
                            ListTile(
                              title: textWhiteBold(
                                  getTranslated(context, 'username')),
                              subtitle: textWhite(utf8.decode(
                                  manager.username != null
                                      ? manager.username.runes.toList()
                                      : getTranslated(context, 'empty'))),
                            ),
                            ListTile(
                              title:
                                  textWhiteBold(getTranslated(context, 'name')),
                              subtitle: textWhite(manager.name != null
                                  ? utf8.decode(manager.name.runes.toList())
                                  : getTranslated(context, 'empty')),
                            ),
                            ListTile(
                              title: textWhiteBold(
                                  getTranslated(context, 'surname')),
                              subtitle: textWhite(manager.surname != null
                                  ? utf8.decode(manager.surname.runes.toList())
                                  : getTranslated(context, 'empty')),
                            ),
                            ListTile(
                              title: textWhiteBold(
                                  getTranslated(context, 'nationality')),
                              subtitle: textWhite(manager.surname != null
                                  ? utf8.decode(
                                      manager.nationality.runes.toList())
                                  : getTranslated(context, 'empty')),
                            ),
                            ListTile(
                              title: textWhiteBold(
                                  getTranslated(context, 'email')),
                              subtitle: textWhite(manager.email != null
                                  ? manager.email
                                  : getTranslated(context, 'empty')),
                            ),
                            ListTile(
                              title: textWhiteBold(
                                  getTranslated(context, 'phoneNumber')),
                              subtitle: textWhite(manager.phoneNumber != null
                                  ? manager.phoneNumber
                                  : getTranslated(context, 'empty')),
                            ),
                            ListTile(
                              title: textWhiteBold(
                                  getTranslated(context, 'viberNumber')),
                              subtitle: textWhite(manager.viberNumber != null
                                  ? manager.viberNumber
                                  : getTranslated(context, 'empty')),
                            ),
                            ListTile(
                              title: textWhiteBold(
                                  getTranslated(context, 'whatsAppNumber')),
                              subtitle: textWhite(manager.whatsAppNumber != null
                                  ? manager.whatsAppNumber
                                  : getTranslated(context, 'empty')),
                            ),
                            ListTile(
                              title: textWhiteBold(
                                  getTranslated(context, 'numberOfGroups')),
                              subtitle:
                                  textWhite(manager.numberOfGroups.toString()),
                            ),
                            ListTile(
                              title: textWhiteBold(getTranslated(
                                  context, 'numberOfEmployeesInGroups')),
                              subtitle: textWhite(
                                  manager.numberOfEmployeesInGroups.toString()),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        }
      },
    );
  }
}
