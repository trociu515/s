import 'package:flutter/material.dart';

import '../libraries/colors.dart';
import '../libraries/constants.dart';
import 'app_bar.dart';

MaterialApp loaderWidget(BuildContext context, String title, Drawer drawer) {
  return MaterialApp(
    debugShowCheckedModeBanner: false,
    title: APP_NAME,
    theme: ThemeData(primarySwatch: MaterialColor(0xffFFFFFF, WHITE_RGBO)),
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
