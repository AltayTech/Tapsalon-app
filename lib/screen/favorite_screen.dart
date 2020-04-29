import 'package:flutter/material.dart';
import 'package:intl/intl.dart' as intl;
import 'package:provider/provider.dart';
import 'package:tapsalon/models/app_theme.dart';
import 'package:tapsalon/models/complex_search.dart';
import 'package:tapsalon/models/searchDetails.dart';
import 'package:tapsalon/provider/auth.dart';
import 'package:tapsalon/provider/cities.dart';
import 'package:tapsalon/provider/complexes.dart';
import 'package:tapsalon/provider/user_info.dart';
import 'package:tapsalon/widget/badge.dart';
import 'package:tapsalon/widget/custom_dialog_enter.dart';
import 'package:tapsalon/widget/favorite_view.dart';
import 'package:tapsalon/widget/main_drawer.dart';
import 'package:tapsalon/widget/select_city_dialog.dart';

import 'notification_screen.dart';

class FavoriteScreen extends StatefulWidget {
  static const routeName = '/favorite';

  @override
  _FavoriteScreenState createState() => _FavoriteScreenState();
}

class _FavoriteScreenState extends State<FavoriteScreen>
    with SingleTickerProviderStateMixin {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();


  void _showLogindialog() {
    showDialog(
        context: context,
        builder: (ctx) => CustomDialogEnter(
          title: 'ورود',
          buttonText: 'صفحه ورود ',
          description: 'برای ادامه باید وارد شوید',
        ));
  }
  @override
  Widget build(BuildContext context) {
    double deviceHeight = MediaQuery.of(context).size.height;
    double deviceWidth = MediaQuery.of(context).size.width;
    var textScaleFactor = MediaQuery.of(context).textScaleFactor;
    var deviceAspectRatio = MediaQuery.of(context).size.aspectRatio;
    var currencyFormat = intl.NumberFormat.decimalPattern();

    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        key: _scaffoldKey,
        backgroundColor: Color(0xffF9F9F9),
        appBar: AppBar(
          backgroundColor: AppTheme.appBarColor,
          iconTheme: new IconThemeData(color: AppTheme.appBarIconColor),
          actions: <Widget>[
            Consumer<UserInfo>(
              builder: (_, notification, ch) => Badge(
                color: notification.notificationItems.length == 0
                    ? Colors.grey
                    : Colors.green,
                value: notification.notificationItems.length.toString(),
                child: ch,
              ),
              child: IconButton(
                onPressed: () {
                  if (Provider.of<Auth>(context, listen: false).isAuth) {
                    Navigator.of(context)
                        .pushNamed(NotificationScreen.routeName);
                  } else {
                    _showLogindialog();
                  }
                },
                color: AppTheme.appBarIconColor,
                icon: Icon(
                  Icons.notifications_none,
                ),
              ),
            ),
            Consumer<Cities>(
              builder: (_, cities, ch) => Padding(
                padding: const EdgeInsets.only(left: 10.0),
                child: InkWell(
                  onTap: () {
                    showDialog(
                        context: context, builder: (ctx) => SelectCityDialog());
                  },
                  child: Directionality(
                    textDirection: TextDirection.ltr,
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        Text(
                          cities.selectedCity.name,
                          style: TextStyle(
                              color: Colors.white,
                              fontFamily: 'Iransans',
                              fontSize: MediaQuery.of(context).textScaleFactor *
                                  12.0),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(3.0),
                          child: Icon(
                            Icons.arrow_drop_down,
                            size: 25,
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
        body: FavoriteView(),
        drawer: Theme(
          data: Theme.of(context).copyWith(
            // Set the transparency here
            canvasColor: Colors
                .transparent, //or any other color you want. e.g Colors.blue.withOpacity(0.5)
          ),
          child: MainDrawer(),
        ),
      ),
    );
  }
}
