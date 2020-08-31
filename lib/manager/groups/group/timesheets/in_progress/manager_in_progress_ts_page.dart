import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:give_job/internationalization/localization/localization_constants.dart';
import 'package:give_job/manager/dto/manager_group_time_sheet_dto.dart';
import 'package:give_job/manager/groups/group/employee/model/group_employee_model.dart';
import 'package:give_job/manager/groups/group/shared/group_floating_action_button.dart';
import 'package:give_job/manager/groups/group/timesheets/in_progress/manager_in_progress_ts_details_page.dart';
import 'package:give_job/manager/service/manager_service.dart';
import 'package:give_job/shared/libraries/colors.dart';
import 'package:give_job/shared/libraries/constants.dart';
import 'package:give_job/shared/service/toastr_service.dart';
import 'package:give_job/shared/util/month_util.dart';
import 'package:give_job/shared/widget/loader.dart';
import 'package:give_job/shared/widget/texts.dart';

import '../../../../manager_app_bar.dart';
import '../../../../manager_side_bar.dart';

class ManagerInProgressTimeSheetsPage extends StatefulWidget {
  final GroupEmployeeModel _model;

  ManagerInProgressTimeSheetsPage(this._model);

  @override
  _ManagerInProgressTimeSheetsPageState createState() =>
      _ManagerInProgressTimeSheetsPageState();
}

class _ManagerInProgressTimeSheetsPageState
    extends State<ManagerInProgressTimeSheetsPage> {
  final ManagerService _managerService = new ManagerService();

  GroupEmployeeModel _model;

  List<ManagerGroupTimeSheetDto> _timesheets = new List();
  bool _loading = false;

  @override
  void initState() {
    this._model = widget._model;
    super.initState();
    _loading = true;
    _managerService
        .findTimeSheetsByGroupIdAndTimeSheetStatus(_model.groupId.toString(),
            STATUS_IN_PROGRESS, _model.user.authHeader)
        .then((res) {
      setState(() {
        _timesheets = res;
        _loading = false;
      });
    }).catchError((e) {
      ToastService.showBottomToast(
          'Group does not have in progress timesheets', Colors.red);
      Navigator.pop(context);
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_loading) {
      return loader(
        managerAppBar(context, null, getTranslated(context, 'loading')),
        managerSideBar(context, _model.user),
      );
    }
    return MaterialApp(
      title: APP_NAME,
      theme: ThemeData(primarySwatch: MaterialColor(0xffFFFFFF, WHITE_RGBO)),
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        backgroundColor: DARK,
        appBar: managerAppBar(
            context,
            _model.user,
            getTranslated(context, 'timesheets') +
                ' - ' +
                utf8.decode(_model.groupName != null
                    ? _model.groupName.runes.toList()
                    : '-')),
        drawer: managerSideBar(context, _model.user),
        body: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              Padding(
                padding: EdgeInsets.only(left: 20, top: 15, bottom: 5),
                child: Align(
                  alignment: Alignment.topLeft,
                  child: text20OrangeBold('In progress timesheets'),
                ),
              ),
              for (var ts in _timesheets)
                Card(
                  color: BRIGHTER_DARK,
                  child: InkWell(
                    onTap: () {
                      Navigator.of(context).push(
                        CupertinoPageRoute<Null>(
                          builder: (BuildContext context) {
                            return ManagerTimeSheetsEmployeesInProgressPage(
                                _model, ts);
                          },
                        ),
                      );
                    },
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        ListTile(
                          leading: Padding(
                            padding: EdgeInsets.only(bottom: 15),
                            child: Image(
                              image: AssetImage('images/unchecked.png'),
                              fit: BoxFit.fitHeight,
                            ),
                          ),
                          title: text18WhiteBold(ts.year.toString() +
                              ' ' +
                              MonthUtil.translateMonth(context, ts.month)),
                        ),
                      ],
                    ),
                  ),
                ),
            ],
          ),
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
        floatingActionButton: groupFloatingActionButton(context, _model),
      ),
    );
  }
}
