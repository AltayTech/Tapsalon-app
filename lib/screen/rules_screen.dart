import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_widget_from_html_core/flutter_widget_from_html_core.dart';
import 'package:intl/intl.dart' as intl;
import 'package:provider/provider.dart';

import '../models/rule_data.dart';
import '../provider/app_theme.dart';
import '../provider/user_info.dart';
import '../widget/main_drawer.dart';

class RulesScreen extends StatefulWidget {
  static const routeName = '/RulesScreen';

  @override
  _RulesScreenState createState() => _RulesScreenState();
}

class _RulesScreenState extends State<RulesScreen> {
  bool _isInit = true;
  var _isLoading;

  List<RuleData> loadedruleList;

  @override
  void didChangeDependencies() {
    if (_isInit) {
      getRulesList();
    }
    _isInit = false;
    super.didChangeDependencies();
  }

  Future<void> getRulesList() async {
    setState(() {
      _isLoading = true;
    });
    print(_isLoading.toString());
    print(_isLoading.toString());

    setState(() {
      _isLoading = false;
      print(_isLoading.toString());
    });
    print(_isLoading.toString());
  }

  @override
  Widget build(BuildContext context) {
    double deviceHeight = MediaQuery.of(context).size.height;
    double deviceWidth = MediaQuery.of(context).size.width;
    var textScaleFactor = MediaQuery.of(context).textScaleFactor;
    var currencyFormat = intl.NumberFormat.decimalPattern();
    loadedruleList = Provider.of<UserInfo>(context).ruleList;

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: AppTheme.appBarColor,
        iconTheme: new IconThemeData(color: AppTheme.appBarIconColor),
      ),
      body: Builder(
        builder: (context) => SingleChildScrollView(
          child: Directionality(
            textDirection: TextDirection.rtl,
            child: Stack(
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 10),
                  child: Card(
                    child: Container(
                      width: double.infinity,
                      height: deviceHeight,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: ListView.builder(
                          itemCount: loadedruleList.length,
                          itemBuilder: (ctx, i) => HtmlWidget(
                            loadedruleList[i].content,
                            onTapUrl: (url) => showDialog(
                              context: context,
                              builder: (_) => AlertDialog(
                                title: Text('onTapUrl'),
                                content: Text(url),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                Positioned(
                  height: deviceHeight * 0.8,
                  left: 0,
                  right: 0,
                  child: Align(
                      alignment: Alignment.center,
                      child: _isLoading
                          ? SpinKitFadingCircle(
                              itemBuilder: (BuildContext context, int index) {
                                return DecoratedBox(
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: index.isEven
                                        ? AppTheme.spinerColor
                                        : AppTheme.spinerColor,
                                  ),
                                );
                              },
                            )
                          : Container()),
                ),
              ],
            ),
          ),
        ),
      ),
      endDrawer: Theme(
        data: Theme.of(context).copyWith(
          // Set the transparency here
          canvasColor: Colors
              .white, //or any other color you want. e.g Colors.blue.withOpacity(0.5)
        ),
        child: MainDrawer(),
      ),
    );
  }
}
