import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:give_job/manager/groups/group/employee/manager_employee_page.dart';
import 'package:give_job/manager/groups/group/employee/model/group_employee_model.dart';
import 'package:give_job/manager/groups/group/timesheets/completed/manager_completed_ts_page.dart';
import 'package:give_job/manager/groups/group/timesheets/in_progress/manager_in_progress_ts_page.dart';
import 'package:give_job/shared/libraries/colors.dart';

import '../manager_group_details_page.dart';

Widget groupFloatingActionButton(
    BuildContext context, GroupEmployeeModel model) {
  return SpeedDial(
    backgroundColor: GREEN,
    animatedIcon: AnimatedIcons.view_list,
    animatedIconTheme: IconThemeData(color: DARK),
    children: [
      SpeedDialChild(
        child: Image(
          image: AssetImage('images/group-img.png'),
          fit: BoxFit.fitHeight,
        ),
        label: 'Group',
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => ManagerGroupDetailsPage(model)),
          );
        },
      ),
      SpeedDialChild(
        child: Icon(Icons.person_outline),
        label: 'Employees',
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => ManagerEmployeePage(model)),
          );
        },
      ),
      SpeedDialChild(
        child: Icon(Icons.equalizer),
        label: 'Plan',
        onTap: () {
          // TODO to be implemented
        },
      ),
      SpeedDialChild(
        child: Icon(Icons.event_available),
        label: 'Completed timesheets',
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => ManagerCompletedTimeSheetsPage(model)),
          );
        },
      ),
      SpeedDialChild(
        child: Icon(Icons.event_note),
        label: 'In progress timesheets',
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => ManagerInProgressTimeSheetsPage(model)),
          );
        },
      ),
      SpeedDialChild(
        child: Icon(Icons.chat),
        label: 'Chat',
        onTap: () {
          // TODO to be implemented
        },
      ),
      SpeedDialChild(
        child: Icon(Icons.error_outline),
        label: 'Message',
        onTap: () {
          // TODO to be implemented
        },
      ),
    ],
  );
}
