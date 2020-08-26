import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:give_job/internationalization/localization/localization_constants.dart';
import 'package:give_job/manager/informations/tabs/manager_info_tab.dart';
import 'package:give_job/manager/manager_side_bar.dart';
import 'package:give_job/manager/service/manager_service.dart';
import 'package:give_job/shared/libraries/colors.dart';
import 'package:give_job/shared/libraries/constants.dart';
import 'package:give_job/shared/model/user.dart';
import 'package:give_job/shared/util/language_util.dart';
import 'package:give_job/shared/widget/icons.dart';
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
              appBar: managerAppBar(context, widget._user,
                  getTranslated(context, 'informations')),
              drawer: managerSideBar(context, widget._user),
              body: Column(
                children: <Widget>[
                  Container(
                    color: DARK,
                    width: double.infinity,
                    height: 90,
                    child: Center(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Row(
                            children: <Widget>[
                              SizedBox(
                                  width:
                                      MediaQuery.of(context).size.width * 0.25),
                              Container(
                                width: 50,
                                height: 50,
                                margin: EdgeInsets.only(top: 5, bottom: 5),
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  image: DecorationImage(
                                      image: AssetImage('images/logo.png'),
                                      fit: BoxFit.fill),
                                ),
                              ),
                              Expanded(
                                child: ListTile(
                                  title: text20WhiteBold(utf8.decode(
                                      widget._user.info != null
                                          ? widget._user.info.runes.toList()
                                          : '-')),
                                  subtitle: textWhiteBold(
                                    getTranslated(context, 'manager') +
                                        ' #' +
                                        widget._user.id +
                                        ' ' +
                                        LanguageUtil.findFlagByNationality(
                                            manager.nationality),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                  Expanded(
                    child: DefaultTabController(
                      length: 1,
                      child: Scaffold(
                        body: TabBarView(
                          children: <Widget>[
                            managerInfoTab(context, manager),
                          ],
                        ),
                        bottomNavigationBar: TabBar(
                          tabs: <Widget>[
                            Tab(
                                icon: iconWhite(Icons.person_pin),
                                text: getTranslated(context, 'informations')),
                          ],
                          labelColor: WHITE,
                          unselectedLabelColor: Colors.white30,
                          indicatorColor: GREEN,
                        ),
                        backgroundColor: DARK,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        }
      },
    );
  }
}
