import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:give_job/internationalization/localization/localization_constants.dart';
import 'package:give_job/manager/dto/manager_group_time_sheet_dto.dart';
import 'package:give_job/manager/groups/group/employee/model/group_employee_model.dart';
import 'package:give_job/manager/groups/group/shared/group_floating_action_button.dart';
import 'package:give_job/manager/service/manager_service.dart';
import 'package:give_job/shared/libraries/colors.dart';
import 'package:give_job/shared/libraries/constants.dart';
import 'package:give_job/shared/service/toastr_service.dart';
import 'package:give_job/shared/util/month_util.dart';
import 'package:give_job/shared/widget/loader.dart';
import 'package:give_job/shared/widget/texts.dart';

import '../../../manager_app_bar.dart';
import '../../../manager_side_bar.dart';
import 'manager_time_sheets_employees_accepted_page.dart';
import 'manager_time_sheets_employees_in_progress_page.dart';

class ManagerTimeSheetsPage extends StatefulWidget {
  final GroupEmployeeModel _model;

  ManagerTimeSheetsPage(this._model);

  @override
  _ManagerTimeSheetsPageState createState() => _ManagerTimeSheetsPageState();
}

class _ManagerTimeSheetsPageState extends State<ManagerTimeSheetsPage> {
  final ManagerService _managerService = new ManagerService();

  GroupEmployeeModel _model;

  List<ManagerGroupTimeSheetDto> _inProgressTimesheets = new List();
  List<ManagerGroupTimeSheetDto> _acceptedTimesheets = new List();
  bool _loading = false;

  @override
  void initState() {
    this._model = widget._model;
    super.initState();
    _loading = true;
    _managerService
        .findTimeSheetsByGroupId(
            _model.groupId.toString(), _model.user.authHeader)
        .then((res) {
      setState(() {
        res.forEach((ts) => {
              if (STATUS_IN_PROGRESS == ts.status)
                {_inProgressTimesheets.add(ts)}
              else
                {_acceptedTimesheets.add(ts)}
            });
        _loading = false;
      });
    }).catchError((e) {
      ToastService.showBottomToast(
          'Group does not have timesheets', Colors.red);
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
              for (var inProgressTs in _inProgressTimesheets)
                Card(
                  color: BRIGHTER_DARK,
                  child: InkWell(
                    onTap: () {
                      Navigator.of(context).push(
                        CupertinoPageRoute<Null>(
                          builder: (BuildContext context) {
                            return ManagerTimeSheetsEmployeesInProgressPage(
                                _model, inProgressTs);
                          },
                        ),
                      );
                    },
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        ListTile(
                          leading: Icon(Icons.radio_button_unchecked,
                              color: Colors.orange),
                          title: textWhiteBold(inProgressTs.year.toString() +
                              ' ' +
                              MonthUtil.translateMonth(
                                  context, inProgressTs.month)),
                        ),
                      ],
                    ),
                  ),
                ),
              Padding(
                padding: EdgeInsets.only(left: 20, top: 15, bottom: 5),
                child: Align(
                  alignment: Alignment.topLeft,
                  child: text20GreenBold('Accepted timesheets'),
                ),
              ),
              for (var acceptedTs in _acceptedTimesheets)
                Card(
                  color: BRIGHTER_DARK,
                  child: InkWell(
                    onTap: () {
                      Navigator.of(context).push(
                        CupertinoPageRoute<Null>(
                          builder: (BuildContext context) {
                            return ManagerTimeSheetsEmployeesAcceptedPage(
                                _model, acceptedTs);
                          },
                        ),
                      );
                    },
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        ListTile(
                          leading:
                              Icon(Icons.radio_button_checked, color: GREEN),
                          title: textWhiteBold(acceptedTs.year.toString() +
                              ' ' +
                              MonthUtil.translateMonth(
                                  context, acceptedTs.month)),
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
