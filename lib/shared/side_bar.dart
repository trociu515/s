import 'package:flutter/material.dart';
import 'package:lets_work/internationalization/localization/localization_constants.dart';
import 'package:lets_work/shared/logout.dart';

Drawer sideBar(BuildContext context, String role) {
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
                        image: NetworkImage(
                            'https://material.angular.io/assets/img/examples/shiba2.jpg'),
                        fit: BoxFit.fill),
                  ),
                ),
                Text(
                  'Jan Kowalski',
                  style: TextStyle(fontSize: 22, color: Colors.white),
                ),
                Text(
                  role,
                  style: TextStyle(color: Colors.white),
                ),
              ],
            ),
          ),
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
