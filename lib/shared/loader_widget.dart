import 'package:flutter/material.dart';

import 'app_bar.dart';
import 'colors.dart';
import 'constants.dart';

MaterialApp loaderWidget(BuildContext context, String title, Drawer drawer) {
  return MaterialApp(
    debugShowCheckedModeBanner: false,
    title: APP_NAME,
    theme: ThemeData(primarySwatch: MaterialColor(0xFFB5D76D, GREEN_RGBO)),
    home: Scaffold(
      backgroundColor: DARK,
      appBar: appBar(context, title),
      drawer: drawer,
      body: Center(
        child: CircularProgressIndicator(
          backgroundColor: GREEN,
          valueColor: new AlwaysStoppedAnimation(Colors.white),
        ),
      ),
    ),
  );
}
