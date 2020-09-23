import 'package:flutter/cupertino.dart';
import 'package:give_job/manager/groups/group/employee/model/group_employee_model.dart';

class ManagerVocationsVerifyPage extends StatefulWidget {
  final GroupEmployeeModel _model;

  ManagerVocationsVerifyPage(this._model);

  @override
  _ManagerVocationsVerifyPageState createState() =>
      _ManagerVocationsVerifyPageState();
}

class _ManagerVocationsVerifyPageState
    extends State<ManagerVocationsVerifyPage> {
  GroupEmployeeModel _model;

  @override
  Widget build(BuildContext context) {
    this._model = widget._model;
    return Container();
  }
}
