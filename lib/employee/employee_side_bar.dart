import 'package:flutter/material.dart';
import 'package:give_job/employee/employee_details.dart';
import 'package:give_job/employee/employee_group.dart';
import 'package:give_job/employee/employee_page.dart';
import 'package:give_job/internationalization/localization/localization_constants.dart';
import 'package:give_job/shared/logout.dart';

Drawer employeeSideBar(BuildContext context, String employeeId, String userInfo,
    String authHeader) {
  return Drawer(
    child: Column(
      children: <Widget>[
        Container(
          width: double.infinity,
          padding: EdgeInsets.all(20),
          color: Theme.of(context).primaryColor,
          child: Center(
            child: Column(
              children: <Widget>[
                Container(
                  width: 100,
                  height: 100,
                  margin: EdgeInsets.only(
                    top: 30,
                    bottom: 10,
                  ),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    image: DecorationImage(
                        image: AssetImage('images/logo.png'), fit: BoxFit.fill),
                  ),
                ),
                Text(
                  userInfo,
                  style: TextStyle(fontSize: 22, color: Colors.white),
                ),
                Text(
                  getTranslated(context, 'employee') + ' #' + employeeId,
                  style: TextStyle(color: Colors.white),
                ),
              ],
            ),
          ),
        ),
        ListTile(
          leading: Icon(Icons.home),
          title: Text(
            getTranslated(context, 'home'),
            style: TextStyle(
              fontSize: 18,
            ),
          ),
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) =>
                    EmployeePage(employeeId, userInfo, authHeader),
              ),
            );
          },
        ),
        ListTile(
          leading: Icon(Icons.person),
          title: Text(
            getTranslated(context, 'information'),
            style: TextStyle(
              fontSize: 18,
            ),
          ),
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) =>
                    EmployeeDetails(employeeId, userInfo, authHeader),
              ),
            );
          },
        ),
        ListTile(
          leading: Icon(Icons.group),
          title: Text(
            getTranslated(context, 'group'),
            style: TextStyle(
              fontSize: 18,
            ),
          ),
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) =>
                    EmployeeGroup(employeeId, userInfo, authHeader),
              ),
            );
          },
        ),
        ListTile(
          leading: Icon(Icons.exit_to_app),
          title: Text(
            getTranslated(context, 'signOut'),
            style: TextStyle(
              fontSize: 18,
            ),
          ),
          onTap: () {
            Logout.logout(context);
          },
        ),
      ],
    ),
  );
}
