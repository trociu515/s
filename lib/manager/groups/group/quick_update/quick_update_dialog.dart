import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:give_job/internationalization/localization/localization_constants.dart';
import 'package:give_job/manager/groups/group/employee/model/group_employee_model.dart';
import 'package:give_job/manager/service/manager_service.dart';
import 'package:give_job/shared/libraries/colors.dart';
import 'package:give_job/shared/service/toastr_service.dart';
import 'package:give_job/shared/service/validator_service.dart';
import 'package:give_job/shared/widget/icons.dart';
import 'package:give_job/shared/widget/texts.dart';
import 'package:intl/intl.dart';
import 'package:slide_popup_dialog/slide_popup_dialog.dart' as slideDialog;

class QuickUpdateDialog {
  static final ManagerService _managerService = new ManagerService();
  static GroupEmployeeModel _model;
  static String _todaysDate;

  static void showQuickUpdateDialog(
      BuildContext context, GroupEmployeeModel model) {
    DateTime now = DateTime.now();
    DateFormat formatter = DateFormat('yyyy-MM-dd');
    String formattedDate = formatter.format(now);
    _model = model;
    _todaysDate = formattedDate;
    slideDialog.showSlideDialog(
      context: context,
      backgroundColor: DARK,
      child: Padding(
        padding: EdgeInsets.all(10),
        child: Column(
          children: <Widget>[
            text20GreenBold('Quick update of today\'s date $formattedDate'),
            SizedBox(height: 10),
            textCenter19White('Update data for all employees of a group'),
            SizedBox(height: 20),
            _buildUpdateButton('Hours', () => _buildUpdateHoursDialog(context)),
            _buildUpdateButton(
                'Rating', () => _buildUpdateRatingDialog(context)),
            _buildUpdateButton('Plan', () => _buildUpdatePlanDialog(context)),
            _buildUpdateButton(
                'Opinion', () => _buildUpdateOpinionDialog(context)),
          ],
        ),
      ),
    );
  }

  static Widget _buildUpdateButton(String title, Function() fun) {
    return Column(
      children: <Widget>[
        MaterialButton(
          elevation: 0,
          minWidth: 200,
          height: 50,
          shape: new RoundedRectangleBorder(
              borderRadius: new BorderRadius.circular(30.0)),
          onPressed: () => fun(),
          color: GREEN,
          child: text20White(title),
          textColor: Colors.white,
        ),
        SizedBox(height: 15),
      ],
    );
  }

  static void _buildUpdateHoursDialog(BuildContext context) {
    TextEditingController _hoursController = new TextEditingController();
    showGeneralDialog(
      context: context,
      barrierColor: DARK.withOpacity(0.95),
      barrierDismissible: false,
      barrierLabel: 'Hours',
      transitionDuration: Duration(milliseconds: 400),
      pageBuilder: (_, __, ___) {
        return SizedBox.expand(
          child: Scaffold(
            backgroundColor: Colors.black12,
            body: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Padding(
                      padding: EdgeInsets.only(top: 50),
                      child: text20GreenBold('HOURS')),
                  SizedBox(height: 2.5),
                  textGreen('Fill in the group hours for today'),
                  Container(
                    width: 150,
                    child: TextFormField(
                      autofocus: true,
                      controller: _hoursController,
                      keyboardType: TextInputType.number,
                      inputFormatters: <TextInputFormatter>[
                        WhitelistingTextInputFormatter.digitsOnly
                      ],
                      maxLength: 2,
                      cursorColor: WHITE,
                      textAlignVertical: TextAlignVertical.center,
                      style: TextStyle(color: WHITE),
                      decoration: InputDecoration(
                        counterStyle: TextStyle(color: WHITE),
                        labelStyle: TextStyle(color: WHITE),
                        labelText:
                            getTranslated(context, 'newHours') + ' (0-24)',
                      ),
                    ),
                  ),
                  SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      MaterialButton(
                        elevation: 0,
                        height: 50,
                        minWidth: 40,
                        shape: new RoundedRectangleBorder(
                            borderRadius: new BorderRadius.circular(30.0)),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[iconWhite(Icons.close)],
                        ),
                        color: Colors.red,
                        onPressed: () => Navigator.pop(context),
                      ),
                      SizedBox(width: 25),
                      MaterialButton(
                        elevation: 0,
                        height: 50,
                        shape: new RoundedRectangleBorder(
                            borderRadius: new BorderRadius.circular(30.0)),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[iconWhite(Icons.check)],
                        ),
                        color: GREEN,
                        onPressed: () {
                          int hours;
                          try {
                            hours = int.parse(_hoursController.text);
                          } catch (FormatException) {
                            ToastService.showBottomToast(
                                getTranslated(
                                    context, 'givenValueIsNotANumber'),
                                Colors.red);
                            return;
                          }
                          String invalidMessage =
                              ValidatorService.validateUpdatingHours(
                                  hours, context);
                          if (invalidMessage != null) {
                            ToastService.showBottomToast(
                                invalidMessage, Colors.red);
                            return;
                          }
                          Navigator.of(context).pop();
                          _managerService
                              .updateGroupHoursOfTodaysDateInCurrentTimesheet(
                                  _model.groupId,
                                  _todaysDate,
                                  hours,
                                  _model.user.authHeader)
                              .then((res) {
                            ToastService.showCenterToast(
                                'Today\'s group hours updated successfully',
                                BRIGHTER_DARK,
                                GREEN);
                          }).catchError((onError) {
                            String s = onError.toString();
                            if (s.contains('TIMESHEET_NULL_OR_EMPTY')) {
                              _errorDialog(context,
                                  'Cannot update today\'s hours cause group does not have a timesheet for today.');
                            }
                          });
                        },
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  static void _buildUpdateRatingDialog(BuildContext context) {
    TextEditingController _ratingController = new TextEditingController();
    showGeneralDialog(
      context: context,
      barrierColor: DARK.withOpacity(0.95),
      barrierDismissible: false,
      barrierLabel: 'Rating',
      transitionDuration: Duration(milliseconds: 400),
      pageBuilder: (_, __, ___) {
        return SizedBox.expand(
          child: Scaffold(
            backgroundColor: Colors.black12,
            body: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Padding(
                      padding: EdgeInsets.only(top: 50),
                      child: text20GreenBold('RATING')),
                  SizedBox(height: 2.5),
                  textGreen('Fill in the group rating for today'),
                  Container(
                    width: 150,
                    child: TextFormField(
                      autofocus: true,
                      controller: _ratingController,
                      keyboardType: TextInputType.number,
                      inputFormatters: <TextInputFormatter>[
                        WhitelistingTextInputFormatter.digitsOnly
                      ],
                      maxLength: 2,
                      cursorColor: WHITE,
                      textAlignVertical: TextAlignVertical.center,
                      style: TextStyle(color: WHITE),
                      decoration: InputDecoration(
                        counterStyle: TextStyle(color: WHITE),
                        labelStyle: TextStyle(color: WHITE),
                        labelText:
                            getTranslated(context, 'newRating') + ' (0-10)',
                      ),
                    ),
                  ),
                  SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      MaterialButton(
                        elevation: 0,
                        height: 50,
                        minWidth: 40,
                        shape: new RoundedRectangleBorder(
                            borderRadius: new BorderRadius.circular(30.0)),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[iconWhite(Icons.close)],
                        ),
                        color: Colors.red,
                        onPressed: () => Navigator.pop(context),
                      ),
                      SizedBox(width: 25),
                      MaterialButton(
                        elevation: 0,
                        height: 50,
                        shape: new RoundedRectangleBorder(
                            borderRadius: new BorderRadius.circular(30.0)),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[iconWhite(Icons.check)],
                        ),
                        color: GREEN,
                        onPressed: () {
                          int rating;
                          try {
                            rating = int.parse(_ratingController.text);
                          } catch (FormatException) {
                            ToastService.showBottomToast(
                                getTranslated(
                                    context, 'givenValueIsNotANumber'),
                                Colors.red);
                            return;
                          }
                          String invalidMessage =
                              ValidatorService.validateUpdatingRating(
                                  rating, context);
                          if (invalidMessage != null) {
                            ToastService.showBottomToast(
                                invalidMessage, Colors.red);
                            return;
                          }
                          Navigator.of(context).pop();
                          _managerService
                              .updateGroupHoursOfTodaysDateInCurrentTimesheet(
                                  _model.groupId,
                                  _todaysDate,
                                  rating,
                                  _model.user.authHeader)
                              .then((res) {
                            ToastService.showCenterToast(
                                'Today\'s group rating updated successfully',
                                BRIGHTER_DARK,
                                GREEN);
                          }).catchError((onError) {
                            String s = onError.toString();
                            if (s.contains('TIMESHEET_NULL_OR_EMPTY')) {
                              _errorDialog(context,
                                  'Cannot update today\'s rating cause group does not have a timesheet for today.');
                            }
                          });
                        },
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  static void _buildUpdatePlanDialog(BuildContext context) {
    TextEditingController _planController = new TextEditingController();
    showGeneralDialog(
      context: context,
      barrierColor: DARK.withOpacity(0.95),
      barrierDismissible: false,
      barrierLabel: 'Plan',
      transitionDuration: Duration(milliseconds: 400),
      pageBuilder: (_, __, ___) {
        return SizedBox.expand(
          child: Scaffold(
            backgroundColor: Colors.black12,
            body: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Padding(
                      padding: EdgeInsets.only(top: 50),
                      child: text20GreenBold('PLAN')),
                  SizedBox(height: 2.5),
                  textGreen('Plan today for the group'),
                  SizedBox(height: 20),
                  Padding(
                    padding: EdgeInsets.only(left: 25, right: 25),
                    child: TextFormField(
                      autofocus: false,
                      controller: _planController,
                      keyboardType: TextInputType.multiline,
                      maxLength: 510,
                      maxLines: 5,
                      cursorColor: WHITE,
                      textAlignVertical: TextAlignVertical.center,
                      style: TextStyle(color: WHITE),
                      decoration: InputDecoration(
                        hintText: 'Text some plan ...',
                        hintStyle: TextStyle(color: MORE_BRIGHTER_DARK),
                        counterStyle: TextStyle(color: WHITE),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: GREEN, width: 2.5),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: GREEN, width: 2.5),
                        ),
                      ),
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      MaterialButton(
                        elevation: 0,
                        height: 50,
                        minWidth: 40,
                        shape: new RoundedRectangleBorder(
                            borderRadius: new BorderRadius.circular(30.0)),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[iconWhite(Icons.close)],
                        ),
                        color: Colors.red,
                        onPressed: () => Navigator.pop(context),
                      ),
                      SizedBox(width: 25),
                      MaterialButton(
                        elevation: 0,
                        height: 50,
                        shape: new RoundedRectangleBorder(
                            borderRadius: new BorderRadius.circular(30.0)),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[iconWhite(Icons.check)],
                        ),
                        color: GREEN,
                        onPressed: () {
                          String plan = _planController.text;
                          String invalidMessage =
                              ValidatorService.validateUpdatingPlan(
                                  plan, context);
                          if (invalidMessage != null) {
                            ToastService.showBottomToast(
                                invalidMessage, Colors.red);
                            return;
                          }
                          Navigator.of(context).pop();
                          _managerService
                              .updateGroupPlanOfTodaysDateInCurrentTimesheet(
                                  _model.groupId,
                                  _todaysDate,
                                  plan,
                                  _model.user.authHeader)
                              .then((res) {
                            ToastService.showCenterToast(
                                'Today\'s group plan updated successfully',
                                BRIGHTER_DARK,
                                GREEN);
                          }).catchError((onError) {
                            String s = onError.toString();
                            if (s.contains('TIMESHEET_NULL_OR_EMPTY')) {
                              _errorDialog(context,
                                  'Cannot update today\'s plan cause group does not have a timesheet for today.');
                            }
                          });
                        },
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  static void _buildUpdateOpinionDialog(BuildContext context) {
    TextEditingController _opinionController = new TextEditingController();
    showGeneralDialog(
      context: context,
      barrierColor: DARK.withOpacity(0.95),
      barrierDismissible: false,
      barrierLabel: 'Opinion',
      transitionDuration: Duration(milliseconds: 400),
      pageBuilder: (_, __, ___) {
        return SizedBox.expand(
          child: Scaffold(
            backgroundColor: Colors.black12,
            body: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Padding(
                      padding: EdgeInsets.only(top: 50),
                      child: text20GreenBold('OPINION')),
                  SizedBox(height: 2.5),
                  textGreen('Fill in the group opinion for today'),
                  SizedBox(height: 20),
                  Padding(
                    padding: EdgeInsets.only(left: 25, right: 25),
                    child: TextFormField(
                      autofocus: false,
                      controller: _opinionController,
                      keyboardType: TextInputType.multiline,
                      maxLength: 510,
                      maxLines: 5,
                      cursorColor: WHITE,
                      textAlignVertical: TextAlignVertical.center,
                      style: TextStyle(color: WHITE),
                      decoration: InputDecoration(
                        hintText: 'Text some opinion ...',
                        hintStyle: TextStyle(color: MORE_BRIGHTER_DARK),
                        counterStyle: TextStyle(color: WHITE),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: GREEN, width: 2.5),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: GREEN, width: 2.5),
                        ),
                      ),
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      MaterialButton(
                        elevation: 0,
                        height: 50,
                        minWidth: 40,
                        shape: new RoundedRectangleBorder(
                            borderRadius: new BorderRadius.circular(30.0)),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[iconWhite(Icons.close)],
                        ),
                        color: Colors.red,
                        onPressed: () => Navigator.pop(context),
                      ),
                      SizedBox(width: 25),
                      MaterialButton(
                        elevation: 0,
                        height: 50,
                        shape: new RoundedRectangleBorder(
                            borderRadius: new BorderRadius.circular(30.0)),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[iconWhite(Icons.check)],
                        ),
                        color: GREEN,
                        onPressed: () {
                          String opinion = _opinionController.text;
                          String invalidMessage =
                              ValidatorService.validateUpdatingPlan(
                                  opinion, context);
                          if (invalidMessage != null) {
                            ToastService.showBottomToast(
                                invalidMessage, Colors.red);
                            return;
                          }
                          Navigator.of(context).pop();
                          _managerService
                              .updateGroupOpinionOfTodaysDateInCurrentTimesheet(
                                  _model.groupId,
                                  _todaysDate,
                                  opinion,
                                  _model.user.authHeader)
                              .then((res) {
                            ToastService.showCenterToast(
                                'Today\'s group opinion updated successfully',
                                BRIGHTER_DARK,
                                GREEN);
                          }).catchError((onError) {
                            String s = onError.toString();
                            if (s.contains('TIMESHEET_NULL_OR_EMPTY')) {
                              _errorDialog(context,
                                  'Cannot update today\'s opinion cause group does not have a timesheet for today.');
                            }
                          });
                        },
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  static _errorDialog(BuildContext context, String content) {
    return showDialog(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: DARK,
          title: textGreen('Error'),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                textWhite(content),
              ],
            ),
          ),
          actions: <Widget>[
            FlatButton(
              child: textWhite(getTranslated(context, 'close')),
              onPressed: () => Navigator.of(context).pop(),
            ),
          ],
        );
      },
    );
  }
}
