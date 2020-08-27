import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:give_job/internationalization/localization/localization_constants.dart';
import 'package:give_job/manager/dto/manager_group_dto.dart';
import 'package:give_job/manager/manager_side_bar.dart';
import 'package:give_job/manager/service/manager_service.dart';
import 'package:give_job/shared/libraries/colors.dart';
import 'package:give_job/shared/libraries/constants.dart';
import 'package:give_job/shared/model/user.dart';
import 'package:give_job/shared/service/logout_service.dart';
import 'package:give_job/shared/service/toastr_service.dart';
import 'package:give_job/shared/util/language_util.dart';
import 'package:give_job/shared/widget/loader.dart';
import 'package:give_job/shared/widget/texts.dart';

import '../manager_app_bar.dart';
import 'group/manager_group_details_page.dart';

class ManagerGroupsPage extends StatefulWidget {
  final User _user;

  ManagerGroupsPage(this._user);

  @override
  _ManagerGroupsPageState createState() => _ManagerGroupsPageState();
}

class _ManagerGroupsPageState extends State<ManagerGroupsPage> {
  final ManagerService _managerService = new ManagerService();

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      child: FutureBuilder<List<ManagerGroupDto>>(
        future: _managerService
            .findGroupsManager(widget._user.id, widget._user.authHeader)
            .catchError((e) {
          ToastService.showBottomToast(
              getTranslated(context, 'managerDoesNotHaveGroups'), Colors.red);
          Navigator.pop(context);
        }),
        builder: (BuildContext context,
            AsyncSnapshot<List<ManagerGroupDto>> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting ||
              snapshot.data == null) {
            return loader(
              managerAppBar(context, null, getTranslated(context, 'loading')),
              managerSideBar(context, widget._user),
            );
          } else {
            List<ManagerGroupDto> groups = snapshot.data;
            if (groups.isEmpty) {
              ToastService.showBottomToast(
                  getTranslated(context, 'managerDoesNotHaveGroups'),
                  Colors.red);
              Navigator.pop(context);
            }
            return MaterialApp(
              title: APP_NAME,
              theme: ThemeData(
                  primarySwatch: MaterialColor(0xffFFFFFF, WHITE_RGBO)),
              debugShowCheckedModeBanner: false,
              home: Scaffold(
                backgroundColor: DARK,
                appBar: managerAppBar(
                    context, widget._user, getTranslated(context, 'groups')),
                drawer: managerSideBar(context, widget._user),
                body: SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: Column(
                      children: <Widget>[
                        for (int i = 0; i < groups.length; i++)
                          Card(
                            color: BRIGHTER_DARK,
                            child: InkWell(
                              onTap: () {
                                Navigator.of(context).push(
                                  CupertinoPageRoute<Null>(
                                    builder: (BuildContext context) {
                                      return ManagerGroupDetailsPage(
                                          widget._user,
                                          groups[i].id,
                                          groups[i].name,
                                          groups[i].description,
                                          groups[i]
                                              .numberOfEmployees
                                              .toString(),
                                          groups[i].countryOfWork);
                                    },
                                  ),
                                );
                              },
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: <Widget>[
                                  ListTile(
                                    leading: Tab(
                                      icon: Container(
                                        child: Image(
                                          image: AssetImage(
                                            'images/group-img.png',
                                          ),
                                          fit: BoxFit.cover,
                                        ),
                                      ),
                                    ),
                                    title: text18WhiteBold(
                                      utf8.decode(
                                        groups[i].name != null
                                            ? groups[i].name.runes.toList()
                                            : getTranslated(context, 'empty'),
                                      ),
                                    ),
                                    subtitle: Column(
                                      children: <Widget>[
                                        Align(
                                            child: textWhite(utf8.decode(
                                                groups[i].description != null
                                                    ? groups[i]
                                                        .description
                                                        .runes
                                                        .toList()
                                                    : getTranslated(
                                                        context, 'empty'))),
                                            alignment: Alignment.topLeft),
                                        SizedBox(height: 5),
                                        Align(
                                            child: textWhite(getTranslated(
                                                    context,
                                                    'numberOfEmployees') +
                                                ': ' +
                                                groups[i]
                                                    .numberOfEmployees
                                                    .toString()),
                                            alignment: Alignment.topLeft),
                                        Align(
                                            child: textWhite(getTranslated(
                                                    context,
                                                    'groupCountryOfWork') +
                                                ': ' +
                                                LanguageUtil
                                                    .findFlagByNationality(
                                                        groups[i]
                                                            .countryOfWork
                                                            .toString())),
                                            alignment: Alignment.topLeft),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
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
      ),
      onWillPop: _onWillPop,
    );
  }

  Future<bool> _onWillPop() async {
    return Logout.logout(context) ?? false;
  }
}
