import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:lets_work/employee_page.dart';
import 'package:lets_work/login_page.dart';

const SERVER_IP = 'http://10.0.2.2:8080/api';
final storage = new FlutterSecureStorage();

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  Future<String> get authOrEmpty async {
    var auth = await storage.read(key: 'authorization');
    return auth != null ? auth : '';
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: FutureBuilder(
        future: authOrEmpty,
        builder: (context, snapshot) {
          var data = snapshot.data;
          return data != null ? EmployeePage() : LoginPage();
        },
      ),
    );
  }
}
