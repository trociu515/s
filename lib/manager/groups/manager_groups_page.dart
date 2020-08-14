import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:give_job/internationalization/localization/localization_constants.dart';
import 'package:give_job/manager/dto/manager_group_dto.dart';
import 'package:give_job/manager/manager_side_bar.dart';
import 'package:give_job/manager/service/manager_service.dart';
import 'package:give_job/shared/libraries/colors.dart';
import 'package:give_job/shared/libraries/constants.dart';
import 'package:give_job/shared/service/toastr_service.dart';
import 'package:give_job/shared/widget/app_bar.dart';
import 'package:give_job/shared/widget/icons.dart';
import 'package:give_job/shared/widget/loader.dart';
import 'package:give_job/shared/widget/texts.dart';

import 'manager_groups_details_page.dart';

class ManagerGroupsPage extends StatefulWidget {
  final String _userId;
  final String _userInfo;
  final String _authHeader;

  ManagerGroupsPage(this._userId, this._userInfo, this._authHeader);

  @override
  _ManagerGroupsPageState createState() => _ManagerGroupsPageState();
}

class _ManagerGroupsPageState extends State<ManagerGroupsPage> {
  final ManagerService _managerService = new ManagerService();

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<ManagerGroupDto>>(
      future: _managerService
          .findGroupsManager(widget._userId, widget._authHeader)
          .catchError((e) {
        ToastService.showToast(
            getTranslated(context, 'managerDoesNotHaveGroups'), Colors.red);
        Navigator.pop(context);
      }),
      builder: (BuildContext context,
          AsyncSnapshot<List<ManagerGroupDto>> snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting ||
            snapshot.data == null) {
          return loader(
            context,
            getTranslated(context, 'loading'),
            managerSideBar(
                context, widget._userId, widget._userInfo, widget._authHeader),
          );
        } else {
          List<ManagerGroupDto> groups = snapshot.data;
          if (groups.isEmpty) {
            ToastService.showToast(
                getTranslated(context, 'managerDoesNotHaveGroups'), Colors.red);
            Navigator.pop(context);
          }
          return MaterialApp(
            title: APP_NAME,
            theme:
                ThemeData(primarySwatch: MaterialColor(0xffFFFFFF, WHITE_RGBO)),
            debugShowCheckedModeBanner: false,
            home: Scaffold(
              backgroundColor: DARK,
              appBar: appBar(context, widget._userId, widget._userInfo,
                  widget._authHeader, getTranslated(context, 'groups')),
              drawer: managerSideBar(context, widget._userId, widget._userInfo,
                  widget._authHeader),
              body: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Column(
                    children: <Widget>[
                      for (int i = 0; i < groups.length; i++)
                        Card(
                          color: DARK,
                          child: InkWell(
                            onTap: () {
                              Navigator.of(context).push(
                                CupertinoPageRoute<Null>(
                                  builder: (BuildContext context) {
                                    return ManagerGroupsDetailsPage(
                                        widget._userId,
                                        widget._userInfo,
                                        widget._authHeader,
                                        groups[i].id,
                                        groups[i].name,
                                        groups[i].description);
                                  },
                                ),
                              );
                            },
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: <Widget>[
                                ListTile(
                                  leading:
                                      text20WhiteBold('#' + (i + 1).toString()),
                                  title: textWhiteBold(utf8.decode(
                                    groups[i].name != null
                                        ? groups[i].name.runes.toList()
                                        : getTranslated(context, 'empty'),
                                  )),
                                  subtitle: Wrap(
                                    children: <Widget>[
                                      textWhite(getTranslated(
                                              context, 'numberOfEmployees') +
                                          ': ' +
                                          groups[i]
                                              .numberOfEmployees
                                              .toString()),
                                      textWhite(getTranslated(
                                              context, 'groupCountryOfWork') +
                                          ': ' +
                                          groups[i].countryOfWork.toString()),
                                      textWhite(utf8.decode(groups[i]
                                                  .description !=
                                              null
                                          ? groups[i].description.runes.toList()
                                          : getTranslated(context, 'empty'))),
                                    ],
                                  ),
                                  trailing: Wrap(
                                    children: <Widget>[
                                      iconWhite(Icons.edit),
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
    );
  }
}
