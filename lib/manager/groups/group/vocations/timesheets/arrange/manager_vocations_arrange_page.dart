import 'package:flutter/cupertino.dart';
import 'package:give_job/manager/groups/group/employee/model/group_employee_model.dart';

class ManagerVocationsArrangePage extends StatefulWidget {
  final GroupEmployeeModel _model;

  ManagerVocationsArrangePage(this._model);

  @override
  _ManagerVocationsArrangePageState createState() =>
      _ManagerVocationsArrangePageState();
}

class _ManagerVocationsArrangePageState
    extends State<ManagerVocationsArrangePage> {
  GroupEmployeeModel _model;

  @override
  Widget build(BuildContext context) {
    this._model = widget._model;
    return Container();
  }
}
