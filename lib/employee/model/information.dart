import 'package:flutter/cupertino.dart';

class Information {
  final String title;
  List<String> titleContents = [];
  final Icon icon;

  Information(this.title, this.titleContents, this.icon);
}
