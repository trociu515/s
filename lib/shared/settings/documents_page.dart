import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_plugin_pdf_viewer/flutter_plugin_pdf_viewer.dart';
import 'package:give_job/employee/employee_side_bar.dart';
import 'package:give_job/manager/manager_side_bar.dart';
import 'package:give_job/shared/libraries/colors.dart';
import 'package:give_job/shared/libraries/constants.dart';
import 'package:give_job/shared/model/user.dart';
import 'package:give_job/shared/widget/app_bar.dart';
import 'package:give_job/shared/widget/circular_progress_indicator.dart';
import 'package:give_job/shared/widget/icons.dart';
import 'package:give_job/shared/widget/texts.dart';

class DocumentsPage extends StatefulWidget {
  final User _user;
  String _tokenId;

  DocumentsPage(this._user, this._tokenId);

  @override
  _DocumentsPageState createState() => _DocumentsPageState();
}

class _DocumentsPageState extends State<DocumentsPage> {
  bool _isLoading = true;
  bool _isInit = true;
  PDFDocument regulationsPDF;
  PDFDocument privacyPolicyPDF;

  @override
  Widget build(BuildContext context) {
    if (widget._user != null) {
      return _buildForAuthenticatedUser();
    } else {
      return _buildForNotAuthenticatedUser();
    }
  }

  Widget _buildForAuthenticatedUser() {
    return MaterialApp(
      title: APP_NAME,
      theme: ThemeData(primarySwatch: MaterialColor(0xffFFFFFF, WHITE_RGBO)),
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        backgroundColor: DARK,
        appBar: appBar(context, widget._user, 'Terms of use'),
        drawer: widget._user.role == ROLE_EMPLOYEE
            ? employeeSideBar(context, widget._user)
            : managerSideBar(context, widget._user),
        body: _buildBody(),
      ),
    );
  }

  Widget _buildForNotAuthenticatedUser() {
    return Scaffold(
      backgroundColor: DARK,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        automaticallyImplyLeading: true,
        leading: IconButton(
          icon: iconWhite(Icons.arrow_back),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: _buildBody(),
    );
  }

  Widget _buildBody() {
    return Column(
      children: <Widget>[
        Expanded(
          child: Center(
            child: _isInit
                ? textCenter28White(
                    'Press button to choose interested document')
                : _isLoading
                    ? Center(child: circularProgressIndicator())
                    : PDFViewer(document: regulationsPDF),
          ),
        ),
        Row(
          mainAxisSize: MainAxisSize.max,
          children: <Widget>[
            Expanded(
              child: MaterialButton(
                color: GREEN,
                child: Text('Regulations'),
                onPressed: () => _loadRegulationsFromDocs(),
              ),
            ),
            Expanded(
              child: MaterialButton(
                color: GREEN,
                child: Text('Privacy policy'),
                onPressed: () => _loadPrivacyPolicyFromDocs(),
              ),
            ),
          ],
        ),
      ],
    );
  }

  void _loadRegulationsFromDocs() async {
    setState(() {
      _isInit = false;
      _isLoading = true;
    });
    regulationsPDF = await PDFDocument.fromAsset('docs/regulations.pdf');
    setState(() {
      _isLoading = false;
    });
  }

  void _loadPrivacyPolicyFromDocs() async {
    setState(() {
      _isInit = false;
      _isLoading = true;
    });
    regulationsPDF = await PDFDocument.fromAsset('docs/privacy_policy.pdf');
    setState(() {
      _isLoading = false;
    });
  }
}
