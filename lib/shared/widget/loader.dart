import 'package:flutter/material.dart';

import '../libraries/colors.dart';
import '../libraries/constants.dart';

MaterialApp loader(AppBar appBar, Drawer drawer) {
  return MaterialApp(
    debugShowCheckedModeBanner: false,
    title: APP_NAME,
    theme: ThemeData(primarySwatch: MaterialColor(0xffFFFFFF, WHITE_RGBO)),
    home: Scaffold(
      backgroundColor: DARK,
      appBar: appBar,
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
