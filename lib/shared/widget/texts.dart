import 'package:flutter/cupertino.dart';
import 'package:give_job/shared/libraries/colors.dart';

/////////////////////
/*    TEXT WHITE   */
/////////////////////
Text textWhite(String text) { return Text(text, style: TextStyle(color: WHITE)); }
Text text17White(String text) { return Text(text, style: TextStyle(fontSize: 18, color: WHITE)); }
Text text18White(String text) { return Text(text, style: TextStyle(fontSize: 18, color: WHITE)); }
Text text20White(String text) { return Text(text, style: TextStyle(fontSize: 20, color: WHITE)); }


/////////////////////
/* TEXT WHITE BOLD */
/////////////////////
Text textWhiteBold(String text) { return Text(text, style: TextStyle(color: WHITE, fontWeight: FontWeight.bold)); }
Text text15WhiteBold(String text) { return Text(text, style: TextStyle(fontSize: 15, color: WHITE, fontWeight: FontWeight.bold)); }
Text text16WhiteBold(String text) { return Text(text, style: TextStyle(fontSize: 16, color: WHITE, fontWeight: FontWeight.bold)); }
Text text20WhiteBold(String text) { return Text(text, style: TextStyle(fontSize: 20, color: WHITE, fontWeight: FontWeight.bold)); }


/////////////////////
/*TEXT WHITE ITALIC*/
/////////////////////
Text text20WhiteItalic(String text) { return Text(text, style: TextStyle(fontSize: 20, color: WHITE, fontStyle: FontStyle.italic)); }


/////////////////////
/*TEXT WHITE CENTER*/
/////////////////////
Text textCenter14White(String text) { return Text(text, textAlign: TextAlign.center, style: TextStyle(fontSize: 14, color: WHITE)); }
Text textCenter28White(String text) { return Text(text, textAlign: TextAlign.center, style: TextStyle(fontSize: 28, color: WHITE)); }


/////////////////////
/*    TEXT DARK    */
/////////////////////
Text textDark(String text) { return Text(text, style: TextStyle(color: DARK)); }


/////////////////////
/* TEXT DARK BOLD  */
/////////////////////
Text textDarkBold(String text) { return Text(text, style: TextStyle(color: DARK, fontWeight: FontWeight.bold)); }
Text text14DarkBold(String text) { return Text(text, style: TextStyle(fontSize: 14, color: DARK, fontWeight: FontWeight.bold)); }
Text text18DarkBold(String text) { return Text(text, style: TextStyle(fontSize: 18, color: DARK, fontWeight: FontWeight.bold)); }
Text text20DarkBold(String text) { return Text(text, style: TextStyle(fontSize: 20, color: DARK, fontWeight: FontWeight.bold)); }
Text text22DarkBold(String text) { return Text(text, style: TextStyle(fontSize: 22, color: DARK, fontWeight: FontWeight.bold)); }


/////////////////////
/* TEXT GREEN BOLD */
/////////////////////
Text text20GreenBold(String text) {return Text(text, style: TextStyle(fontSize: 20, color: GREEN, fontWeight: FontWeight.bold)); }
