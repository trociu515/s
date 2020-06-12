import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:give_job/internationalization/localization/localization_constants.dart';
import 'package:give_job/manager/manager_side_bar.dart';
import 'package:give_job/manager/service/manager_service.dart';
import 'package:give_job/shared/app_bar.dart';
import 'package:give_job/shared/constants.dart';

import 'dto/manager_dto.dart';

class ManagerDetails extends StatefulWidget {
  final String _managerId;
  final String _managerInfo;
  final String _authHeader;

  ManagerDetails(this._managerId, this._managerInfo, this._authHeader);

  @override
  _ManagerDetailsState createState() => _ManagerDetailsState();
}

class _ManagerDetailsState extends State<ManagerDetails> {
  final ManagerService _managerService = new ManagerService();

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<ManagerDto>(
      future: _managerService.findById(widget._managerId, widget._authHeader),
      builder: (BuildContext context, AsyncSnapshot<ManagerDto> snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting ||
            snapshot.data == null) {
          return Center(child: CircularProgressIndicator());
        } else {
          ManagerDto manager = snapshot.data;
          return MaterialApp(
            title: APP_NAME,
            theme: ThemeData(
              primarySwatch: Colors.green,
            ),
            home: Scaffold(
              appBar: appBar(context, getTranslated(context, 'information')),
              drawer: managerSideBar(context, widget._managerId,
                  widget._managerInfo, widget._authHeader),
              body: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Column(
                    children: <Widget>[
                      Card(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: <Widget>[
                            ListTile(
                              title: Text(getTranslated(context, 'id')),
                              subtitle: Text(widget._managerId != null
                                  ? widget._managerId.toString()
                                  : getTranslated(context, 'empty')),
                            ),
                            ListTile(
                              title: Text(getTranslated(context, 'username')),
                              subtitle: Text(
                                utf8.decode(manager.username != null
                                    ? manager.username.runes.toList()
                                    : getTranslated(context, 'empty')),
                              ),
                            ),
                            ListTile(
                              title: Text(getTranslated(context, 'name')),
                              subtitle: Text(utf8.decode(manager.name != null
                                  ? manager.name.runes.toList()
                                  : getTranslated(context, 'empty'))),
                            ),
                            ListTile(
                              title: Text(getTranslated(context, 'surname')),
                              subtitle: Text(
                                utf8.decode(manager.surname != null
                                    ? manager.surname.runes.toList()
                                    : getTranslated(context, 'empty')),
                              ),
                            ),
                            ListTile(
                              title: Text('Number of groups'),
                              subtitle: Text(manager.numberOfGroups.toString()),
                            ),
                            ListTile(
                              title: Text('Number of employees in groups'),
                              subtitle: Text(
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
