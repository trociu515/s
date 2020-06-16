import 'package:flutter/material.dart';

import 'app_bar.dart';
import 'constants.dart';

MaterialApp loaderWidget(BuildContext context, String title, Drawer drawer) {
  return MaterialApp(
    title: APP_NAME,
    theme: ThemeData(
      primarySwatch: Colors.green,
    ),
    home: Scaffold(
      appBar: appBar(context, title),
      drawer: drawer,
      body: Center(
        child: CircularProgressIndicator(),
      ),
    ),
  );
}
