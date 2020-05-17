import 'package:flutter/material.dart';
import 'package:lets_work/shared/toastr_service.dart';

import '../login_page.dart';
import '../main.dart';

class Logout {
  static showAlert(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Wylogowywanie'),
          content: Text("Czy na pewno chcesz się wylogować?"),
          actions: <Widget>[
            FlatButton(
              child: Text("Tak"),
              onPressed: () {
                storage.delete(key: 'authorization');
                storage.delete(key: 'role');
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => LoginPage()));
                ToastService.showToast('Wylogowano pomyślnie', Colors.green);
              },
            ),
            FlatButton(
              child: Text("Nie"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
}
