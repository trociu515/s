import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:give_job/internationalization/localization/localization_constants.dart';
import 'package:give_job/manager/manager_side_bar.dart';
import 'package:give_job/manager/service/manager_service.dart';
import 'package:give_job/shared/libraries/colors.dart';
import 'package:give_job/shared/libraries/constants.dart';
import 'package:give_job/shared/widget/app_bar.dart';
import 'package:give_job/shared/widget/loader_widget.dart';

import '../dto/manager_dto.dart';

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
          return loaderWidget(
            context,
            getTranslated(context, 'loading'),
            managerSideBar(context, widget._managerId, widget._managerInfo,
                widget._authHeader),
          );
        } else {
          ManagerDto manager = snapshot.data;
          return MaterialApp(
            title: APP_NAME,
            theme:
                ThemeData(primarySwatch: MaterialColor(0xFFB5D76D, GREEN_RGBO)),
            debugShowCheckedModeBanner: false,
            home: Scaffold(
              backgroundColor: DARK,
              appBar: appBar(context, getTranslated(context, 'information')),
              drawer: managerSideBar(context, widget._managerId,
                  widget._managerInfo, widget._authHeader),
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
                              title: Text(
                                getTranslated(context, 'id'),
                                style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold),
                              ),
                              subtitle: Text(
                                widget._managerId != null
                                    ? widget._managerId.toString()
                                    : getTranslated(context, 'empty'),
                                style: TextStyle(color: Colors.white),
                              ),
                            ),
                            ListTile(
                              title: Text(
                                getTranslated(context, 'username'),
                                style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold),
                              ),
                              subtitle: Text(
                                utf8.decode(manager.username != null
                                    ? manager.username.runes.toList()
                                    : getTranslated(context, 'empty')),
                                style: TextStyle(color: Colors.white),
                              ),
                            ),
                            ListTile(
                              title: Text(
                                getTranslated(context, 'name'),
                                style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold),
                              ),
                              subtitle: Text(
                                manager.name != null
                                    ? utf8.decode(manager.name.runes.toList())
                                    : getTranslated(context, 'empty'),
                                style: TextStyle(color: Colors.white),
                              ),
                            ),
                            ListTile(
                              title: Text(
                                getTranslated(context, 'surname'),
                                style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold),
                              ),
                              subtitle: Text(
                                manager.surname != null
                                    ? utf8
                                        .decode(manager.surname.runes.toList())
                                    : getTranslated(context, 'empty'),
                                style: TextStyle(color: Colors.white),
                              ),
                            ),
                            ListTile(
                              title: Text(
                                getTranslated(context, 'nationality'),
                                style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold),
                              ),
                              subtitle: Text(
                                manager.surname != null
                                    ? utf8.decode(
                                        manager.nationality.runes.toList())
                                    : getTranslated(context, 'empty'),
                                style: TextStyle(color: Colors.white),
                              ),
                            ),
                            ListTile(
                              title: Text(
                                getTranslated(context, 'email'),
                                style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold),
                              ),
                              subtitle: Text(
                                manager.email != null
                                    ? manager.email
                                    : getTranslated(context, 'empty'),
                                style: TextStyle(color: Colors.white),
                              ),
                            ),
                            ListTile(
                              title: Text(
                                getTranslated(context, 'phoneNumber'),
                                style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold),
                              ),
                              subtitle: Text(
                                manager.phoneNumber != null
                                    ? manager.phoneNumber
                                    : getTranslated(context, 'empty'),
                                style: TextStyle(color: Colors.white),
                              ),
                            ),
                            ListTile(
                              title: Text(
                                getTranslated(context, 'viberNumber'),
                                style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold),
                              ),
                              subtitle: Text(
                                manager.viberNumber != null
                                    ? manager.viberNumber
                                    : getTranslated(context, 'empty'),
                                style: TextStyle(color: Colors.white),
                              ),
                            ),
                            ListTile(
                              title: Text(
                                getTranslated(context, 'whatsAppNumber'),
                                style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold),
                              ),
                              subtitle: Text(
                                manager.whatsAppNumber != null
                                    ? manager.whatsAppNumber
                                    : getTranslated(context, 'empty'),
                                style: TextStyle(color: Colors.white),
                              ),
                            ),
                            ListTile(
                              title: Text(
                                getTranslated(context, 'numberOfGroups'),
                                style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold),
                              ),
                              subtitle: Text(
                                manager.numberOfGroups.toString(),
                                style: TextStyle(color: Colors.white),
                              ),
                            ),
                            ListTile(
                              title: Text(
                                getTranslated(
                                    context, 'numberOfEmployeesInGroups'),
                                style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold),
                              ),
                              subtitle: Text(
                                manager.numberOfEmployeesInGroups.toString(),
                                style: TextStyle(color: Colors.white),
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
