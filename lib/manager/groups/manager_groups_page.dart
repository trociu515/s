import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:give_job/internationalization/localization/localization_constants.dart';
import 'package:give_job/manager/dto/manager_group_dto.dart';
import 'package:give_job/manager/manager_side_bar.dart';
import 'package:give_job/manager/service/manager_service.dart';
import 'package:give_job/shared/app_bar.dart';
import 'package:give_job/shared/constants.dart';
import 'package:give_job/shared/loader_widget.dart';
import 'package:give_job/shared/toastr_service.dart';

import 'manager_groups_details_page.dart';

class ManagerGroupsPage extends StatefulWidget {
  final String _managerId;
  final String _managerInfo;
  final String _authHeader;

  ManagerGroupsPage(this._managerId, this._managerInfo, this._authHeader);

  @override
  _ManagerGroupsPageState createState() => _ManagerGroupsPageState();
}

class _ManagerGroupsPageState extends State<ManagerGroupsPage> {
  final ManagerService _managerService = new ManagerService();

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<ManagerGroupDto>>(
      future: _managerService
          .findGroupsManager(widget._managerId, widget._authHeader)
          .catchError((e) {
        ToastService.showToast(
            getTranslated(context, 'managerDoesNotHaveGroups'), Colors.red);
        Navigator.pop(context);
      }),
      builder: (BuildContext context,
          AsyncSnapshot<List<ManagerGroupDto>> snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting ||
            snapshot.data == null) {
          return loaderWidget(
            context,
            getTranslated(context, 'loading'),
            managerSideBar(context, widget._managerId, widget._managerInfo,
                widget._authHeader),
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
            theme: ThemeData(
              primarySwatch: Colors.green,
            ),
            home: Scaffold(
              appBar: appBar(context, getTranslated(context, 'groups')),
              drawer: managerSideBar(context, widget._managerId,
                  widget._managerInfo, widget._authHeader),
              body: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Column(
                    children: <Widget>[
                      for (int i = 0; i < groups.length; i++)
                        Card(
                          child: InkWell(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) =>
                                      ManagerGroupsDetailsPage(
                                          widget._managerId,
                                          widget._managerInfo,
                                          widget._authHeader,
                                          groups[i].id,
                                          groups[i].name,
                                          groups[i].description),
                                ),
                              );
                            },
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: <Widget>[
                                ListTile(
                                  leading: Text(
                                    '#' + (i + 1).toString(),
                                    style: TextStyle(fontSize: 20),
                                  ),
                                  title: Text(utf8.decode(groups[i].name != null
                                      ? groups[i].name.runes.toList()
                                      : getTranslated(context, 'empty'))),
                                  subtitle: Wrap(
                                    children: <Widget>[
                                      Text(getTranslated(
                                              context, 'numberOfEmployees') +
                                          ': ' +
                                          groups[i]
                                              .numberOfEmployees
                                              .toString()),
                                      Text(utf8.decode(groups[i].description !=
                                              null
                                          ? groups[i].description.runes.toList()
                                          : getTranslated(context, 'empty'))),
                                    ],
                                  ),
                                  trailing: Wrap(
                                    children: <Widget>[
                                      Icon(
                                        Icons.edit,
                                      ),
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
