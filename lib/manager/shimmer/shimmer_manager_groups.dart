import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:give_job/internationalization/localization/localization_constants.dart';
import 'package:give_job/manager/manager_side_bar.dart';
import 'package:give_job/shared/libraries/colors.dart';
import 'package:give_job/shared/model/user.dart';
import 'package:shimmer/shimmer.dart';

import '../manager_app_bar.dart';

Widget shimmerManagerGroups(BuildContext context, User user) {
  return Scaffold(
    backgroundColor: DARK,
    appBar: managerAppBar(context, null, getTranslated(context, 'loading')),
    drawer: managerSideBar(context, user),
    body: Container(
      color: DARK,
      child: Container(
        padding: EdgeInsets.all(30.0),
        child: Center(
          child: Shimmer.fromColors(
              direction: ShimmerDirection.rtl,
              period: Duration(seconds: 1),
              child: Column(
                children: [0, 1, 2]
                    .map(
                      (_) => Padding(
                        padding: const EdgeInsets.only(bottom: 8.0),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              width: 48.0,
                              height: 48.0,
                              decoration: BoxDecoration(
                                  shape: BoxShape.circle, color: Colors.white),
                            ),
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 8.0),
                            ),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  _buildContainer(double.infinity),
                                  _buildContainer(double.infinity),
                                  _buildContainer(160),
                                  _buildContainer(120),
                                  _buildContainer(80),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    )
                    .toList(),
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
