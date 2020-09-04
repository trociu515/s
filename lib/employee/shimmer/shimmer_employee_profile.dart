import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:give_job/shared/libraries/colors.dart';
import 'package:shimmer/shimmer.dart';

Widget shimmerEmployeeProfile() {
  return Container(
    color: DARK,
    child: Center(
      child: Shimmer.fromColors(
        direction: ShimmerDirection.rtl,
        period: Duration(seconds: 1),
        child: Column(
          children: <Widget>[
            Container(
              width: double.infinity,
              height: 100,
              margin: EdgeInsets.only(top: 35, bottom: 5),
              decoration:
                  BoxDecoration(shape: BoxShape.circle, color: Colors.white),
            ),
            SizedBox(height: 7),
            _buildContainer(150, 25, 7),
            _buildContainer(100, 15, 7),
            _buildContainer(230, 15, 15),
            Padding(
              padding: EdgeInsets.only(right: 12, left: 12),
              child: Container(
                width: double.infinity,
                height: 60,
                color: Colors.white,
              ),
            ),
            SizedBox(height: 30),
            _buildContainer(double.infinity, 60, 7),
            _buildTimesheetContainer(),
            _buildTimesheetContainer(),
            _buildTimesheetContainer(),
          ],
        ),
        baseColor: Colors.grey[700],
        highlightColor: Colors.grey[100],
      ),
    ),
  );
}

Widget _buildContainer(double width, double height, double boxHeight) {
  return Column(
    children: <Widget>[
      Container(
        width: width,
        height: height,
        color: Colors.white,
      ),
      SizedBox(height: boxHeight),
    ],
  );
}

Widget _buildTimesheetContainer() {
  return Padding(
    padding: EdgeInsets.only(right: 5, left: 5),
    child: Container(
      child: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.only(top: 12, left: 12, right: 12),
          child: Container(
            width: double.infinity,
            height: 70,
            color: Colors.white,
          ),
        ),
      ),
    ),
  );
}
