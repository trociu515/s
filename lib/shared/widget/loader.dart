import 'package:flutter/material.dart';

import '../libraries/colors.dart';
import '../libraries/constants.dart';
import 'circular_progress_indicator.dart';

MaterialApp loader(AppBar appBar, Drawer drawer) {
  return MaterialApp(
    debugShowCheckedModeBanner: false,
    title: APP_NAME,
    theme: ThemeData(primarySwatch: MaterialColor(0xffFFFFFF, WHITE_RGBO)),
    home: Scaffold(
      backgroundColor: DARK,
      appBar: appBar,
      drawer: drawer,
      body: Center(child: circularProgressIndicator()),
    ),
  );
}
