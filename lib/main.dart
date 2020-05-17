import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:lets_work/employee/employee_page.dart';
import 'package:lets_work/login_page.dart';
import 'package:lets_work/manager/manager_page.dart';

import 'shared/constants.dart';

const SERVER_IP = 'http://10.0.2.2:8080/api';
final storage = new FlutterSecureStorage();

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  Future<Map<String, String>> get authOrEmpty async {
    var auth = await storage.read(key: 'authorization');
    var role = await storage.read(key: 'role');
    Map<String, String> map = new Map();
    map['authorization'] = auth;
    map['role'] = role;
    return map.isNotEmpty ? map : null;
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      debugShowCheckedModeBanner: false,
      home: FutureBuilder(
        future: authOrEmpty,
        builder: (context, snapshot) {
          Map<String, String> data = snapshot.data;
          if (data == null) {
            return LoginPage();
          }
          String role = data['role'];
          if (role == ROLE_EMPLOYEE) {
            return EmployeePage();
          } else if (role == ROLE_MANAGER) {
            return ManagerPage();
          } else {
            return LoginPage();
          }
        },
      ),
    );
  }
}
