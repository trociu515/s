import 'package:flutter/cupertino.dart';

Widget buildGroupLogo() {
  return Container(
    child: Image(
      image: AssetImage('images/group-img.png'),
      fit: BoxFit.cover,
    ),
  );
}
