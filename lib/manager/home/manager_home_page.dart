import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:give_job/internationalization/localization/localization_constants.dart';
import 'package:give_job/manager/manager_side_bar.dart';
import 'package:give_job/manager/service/manager_service.dart';
import 'package:give_job/shared/libraries/colors.dart';
import 'package:give_job/shared/libraries/constants.dart';
import 'package:give_job/shared/service/logout_service.dart';
import 'package:give_job/shared/widget/app_bar.dart';
import 'package:give_job/shared/widget/loader.dart';
import 'package:give_job/shared/widget/texts.dart';

import '../dto/manager_dto.dart';

class ManagerDetails extends StatefulWidget {
  final String _userId;
  final String _userInfo;
  final String _authHeader;

  ManagerDetails(this._userId, this._userInfo, this._authHeader);

  @override
  _ManagerDetailsState createState() => _ManagerDetailsState();
}

class _ManagerDetailsState extends State<ManagerDetails> {
  final ManagerService _managerService = new ManagerService();

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<ManagerDto>(
      future: _managerService.findById(widget._userId, widget._authHeader),
      builder: (BuildContext context, AsyncSnapshot<ManagerDto> snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting ||
            snapshot.data == null) {
          return loader(
            context,
            getTranslated(context, 'loading'),
            managerSideBar(
                context, widget._userId, widget._userInfo, widget._authHeader),
          );
        } else {
          ManagerDto manager = snapshot.data;
          return WillPopScope(
            child: MaterialApp(
              title: APP_NAME,
              theme: ThemeData(
                  primarySwatch: MaterialColor(0xFFB5D76D, GREEN_RGBO)),
              debugShowCheckedModeBanner: false,
              home: Scaffold(
                backgroundColor: DARK,
                appBar: appBar(context, widget._userId, widget._userInfo,
                    widget._authHeader, getTranslated(context, 'home')),
                drawer: managerSideBar(context, widget._userId,
                    widget._userInfo, widget._authHeader),
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
                                subtitle: textWhite(widget._userId != null
                                    ? widget._userId.toString()
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
                                title: textWhiteBold(
                                    getTranslated(context, 'name')),
                                subtitle: textWhite(manager.name != null
                                    ? utf8.decode(manager.name.runes.toList())
                                    : getTranslated(context, 'empty')),
                              ),
                              ListTile(
                                title: textWhiteBold(
                                    getTranslated(context, 'surname')),
                                subtitle: textWhite(manager.surname != null
                                    ? utf8
                                        .decode(manager.surname.runes.toList())
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
                                subtitle: textWhite(
                                    manager.whatsAppNumber != null
                                        ? manager.whatsAppNumber
                                        : getTranslated(context, 'empty')),
                              ),
                              ListTile(
                                title: textWhiteBold(
                                    getTranslated(context, 'numberOfGroups')),
                                subtitle: textWhite(
                                    manager.numberOfGroups.toString()),
                              ),
                              ListTile(
                                title: textWhiteBold(getTranslated(
                                    context, 'numberOfEmployeesInGroups')),
                                subtitle: textWhite(manager
                                    .numberOfEmployeesInGroups
                                    .toString()),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            onWillPop: _onWillPop,
          );
        }
      },
    );
  }

  Future<bool> _onWillPop() async {
    return Logout.logout(context) ?? false;
  }
}
