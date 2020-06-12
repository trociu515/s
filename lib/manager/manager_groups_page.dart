import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:give_job/internationalization/localization/localization_constants.dart';
import 'package:give_job/manager/dto/manager_group_overview_dto.dart';
import 'package:give_job/manager/manager_side_bar.dart';
import 'package:give_job/manager/service/manager_service.dart';
import 'package:give_job/shared/app_bar.dart';
import 'package:give_job/shared/constants.dart';
import 'package:give_job/shared/toastr_service.dart';

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
    return FutureBuilder<List<ManagerGroupOverviewDto>>(
      future: _managerService
          .findGroupsManager(widget._managerId, widget._authHeader)
          .catchError((e) {
        ToastService.showToast(
            getTranslated(context, 'Manager doest not have groups'),
            Colors.red);
        Navigator.pop(context);
      }),
      builder: (BuildContext context,
          AsyncSnapshot<List<ManagerGroupOverviewDto>> snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting ||
            snapshot.data == null) {
          return Center(child: CircularProgressIndicator());
        } else {
          List<ManagerGroupOverviewDto> groups = snapshot.data;
          if (groups.isEmpty) {
            ToastService.showToast(
                getTranslated(context, 'Manager doest not have groups'),
                Colors.red);
            Navigator.pop(context);
          }
          return MaterialApp(
            title: APP_NAME,
            theme: ThemeData(
              primarySwatch: Colors.green,
            ),
            home: Scaffold(
              appBar: appBar(context, 'Groups'),
              drawer: managerSideBar(context, widget._managerId,
                  widget._managerInfo, widget._authHeader),
              body: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Column(
                    children: <Widget>[
                      for (var group in groups)
                        Card(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: <Widget>[
                              ListTile(
                                title: Text(utf8.decode(group.name != null
                                    ? group.name.runes.toList()
                                    : getTranslated(context, 'empty'))),
                                subtitle: Wrap(
                                  children: <Widget>[
                                    Text('Number of employees: ' +
                                        group.numberOfEmployees.toString()),
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
