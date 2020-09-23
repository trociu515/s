import 'package:flutter/cupertino.dart';
import 'package:give_job/manager/groups/group/employee/model/group_employee_model.dart';

class ManagerVocationsCalendarPage extends StatefulWidget {
  final GroupEmployeeModel _model;

  ManagerVocationsCalendarPage(this._model);

  @override
  _ManagerVocationsCalendarPageState createState() =>
      _ManagerVocationsCalendarPageState();
}

class _ManagerVocationsCalendarPageState
    extends State<ManagerVocationsCalendarPage> {
  GroupEmployeeModel _model;

  @override
  Widget build(BuildContext context) {
    this._model = widget._model;
    return Container();
  }
}
