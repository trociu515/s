import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:give_job/internationalization/localization/localization_constants.dart';
import 'package:give_job/manager/manager_side_bar.dart';
import 'package:give_job/shared/libraries/colors.dart';
import 'package:give_job/shared/model/user.dart';
import 'package:shimmer/shimmer.dart';

import '../manager_app_bar.dart';

Widget shimmerManagerVocationsTimesheets(BuildContext context, User user) {
  return Scaffold(
    backgroundColor: DARK,
    appBar: managerAppBar(context, null, getTranslated(context, 'loading')),
    drawer: managerSideBar(context, user),
    body: Container(
      color: DARK,
      child: Container(
        padding: EdgeInsets.all(10),
        child: Center(
          child: Shimmer.fromColors(
              direction: ShimmerDirection.rtl,
              period: Duration(seconds: 1),
              child: Column(
                children: <Widget>[
                  _buildContainer(EdgeInsets.only(top: 15, bottom: 5),
                      Alignment.center, 250, 25),
                  _buildContainer(EdgeInsets.only(top: 5, bottom: 15),
                      Alignment.center, double.infinity, 30),
                  _buildContainer(EdgeInsets.only(top: 5, bottom: 10),
                      Alignment.topLeft, double.infinity, 40),
                  _buildContainer(EdgeInsets.only(top: 5), Alignment.topLeft,
                      double.infinity, 40),
                ],
              ),
              baseColor: Colors.grey[700],
              highlightColor: Colors.grey[100]),
        ),
      ),
    ),
  );
}

Widget _buildContainer(
    EdgeInsets padding, Alignment alignment, double width, double height) {
  return Padding(
    padding: padding,
    child: Align(
      alignment: alignment,
      child: Container(
        width: width,
        height: height,
        color: Colors.white,
      ),
    ),
  );
}
