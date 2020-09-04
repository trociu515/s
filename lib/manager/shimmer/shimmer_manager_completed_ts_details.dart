import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:give_job/internationalization/localization/localization_constants.dart';
import 'package:give_job/manager/manager_side_bar.dart';
import 'package:give_job/shared/libraries/colors.dart';
import 'package:give_job/shared/model/user.dart';
import 'package:shimmer/shimmer.dart';

import '../manager_app_bar.dart';

Widget shimmerManagerCompletedTsDetails(BuildContext context, User user) {
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
                  Padding(
                    padding: EdgeInsets.only(bottom: 10),
                    child: Container(
                      height: 60,
                      width: double.infinity,
                      color: Colors.white,
                    ),
                  ),
                  Column(
                    children: [0, 1, 2, 3]
                        .map(
                          (_) => Padding(
                            padding: EdgeInsets.only(right: 5, bottom: 5),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 8.0),
                                ),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      _buildContainer(120),
                                      _buildContainer(80),
                                      _buildContainer(160),
                                      _buildContainer(200),
                                    ],
                                  ),
                                ),
                                Container(
                                  width: 48.0,
                                  height: 48.0,
                                  decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: Colors.white),
                                ),
                              ],
                            ),
                          ),
                        )
                        .toList(),
                  ),
                ],
              ),
              baseColor: Colors.grey[700],
              highlightColor: Colors.grey[100]),
        ),
      ),
    ),
  );
}

Widget _buildContainer(double width) {
  return Column(
    children: <Widget>[
      Container(width: width, height: 8.0, color: Colors.white),
      Padding(padding: const EdgeInsets.symmetric(vertical: 4.0))
    ],
  );
}
