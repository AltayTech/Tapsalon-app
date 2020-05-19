import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../provider/app_theme.dart';
import '../provider/strings.dart';

import '../models/city.dart';
import '../provider/auth.dart';
import '../provider/cities.dart';
import '../provider/user_info.dart';
import '../screen/home_screen.dart';
import '../screen/map_screen.dart';
import '../screen/notification_screen.dart';
import '../screen/reserve_detail_screen.dart';
import '../screen/user_profile/profile_view.dart';
import '../widget/badge.dart';
import '../widget/custom_dialog_enter.dart';
import '../widget/favorite_view.dart';
import '../widget/main_drawer.dart';
import '../widget/select_city_dialog.dart';

class NavigationBottomScreen extends StatefulWidget {
  static const routeName = '/navigationScreen';

  @override
  _NavigationBottomScreenState createState() => _NavigationBottomScreenState();
}

class _NavigationBottomScreenState extends State<NavigationBottomScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  var init = true;
  final List<Map<String, Object>> _pages = [
    {
      'page': ReserveDetailScreen(),
      'title': Strings.navReservse,
    },
    {
      'page': MapScreen(),
      'title': Strings.naveNearby,
    },
    {
      'page': HomeScreen(),
      'title': Strings.navHome,
    },
    {
      'page': FavoriteView(),
      'title': Strings.naveFavorite,
    },
    {
      'page': ProfileView(),
      'title': Strings.navProfile,
    }
  ];

  int _selectedPageIndex = 2;

  void _selectBNBItem(int index) {
    setState(
      () {
        _selectedPageIndex = index;
      },
    );
  }

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
  void didChangeDependencies() async {
    if (init) {
      await Provider.of<Cities>(context, listen: false).getSelectedCity();
      City selectedCity =
          Provider.of<Cities>(context, listen: false).selectedCity;
      if (selectedCity.id == 0) {
        WidgetsBinding.instance.addPostFrameCallback((_) async {
          await showDialog<String>(
              context: context, builder: (ctx) => SelectCityDialog());
        });
      }
      init = false;
    }
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        key: _scaffoldKey,
        appBar: AppBar(
//          title: Text(
//            'sdfsd',
//            style: TextStyle(color: Colors.white),
//          ),
          backgroundColor: AppTheme.appBarColor,
//          centerTitle: true,
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
        drawer: Theme(
          data: Theme.of(context).copyWith(
            // Set the transparency here
            canvasColor: Colors
                .transparent, //or any other color you want. e.g Colors.blue.withOpacity(0.5)
          ),
          child: MainDrawer(),
        ),
        body: _pages[_selectedPageIndex]['page'],
        bottomNavigationBar: BottomNavigationBar(
          elevation: 1,
          selectedLabelStyle: TextStyle(
              color: AppTheme.darkText,
              fontFamily: 'Iransans',
              fontSize: MediaQuery.of(context).textScaleFactor * 10.0),
          onTap: _selectBNBItem,
          backgroundColor: AppTheme.BNbgColor,
          unselectedItemColor: AppTheme.darkText,
          selectedItemColor: AppTheme.BNbSelectedItemColor,
          currentIndex: _selectedPageIndex,
          // type: BottomNavigationBarType.fixed,

          items: [
            BottomNavigationBarItem(
              backgroundColor: AppTheme.BNbgColor,
              icon: Icon(Icons.date_range),
              title: Text(
                Strings.navReservse,
              ),
            ),
            BottomNavigationBarItem(
              backgroundColor: AppTheme.BNbgColor,
              icon: Icon(Icons.near_me),
              title: Text(
                Strings.naveNearby,
              ),
            ),
            BottomNavigationBarItem(
              backgroundColor: AppTheme.BNbgColor,
              icon: Icon(Icons.home),
              title: Text(
                Strings.navHome,
              ),
            ),
            BottomNavigationBarItem(
              backgroundColor: AppTheme.BNbgColor,
              icon: Icon(Icons.favorite),
              title: Text(
                Strings.naveFavorite,
              ),
            ),
            BottomNavigationBarItem(
              backgroundColor: AppTheme.BNbgColor,
              icon: Icon(Icons.account_circle),
              title: Text(
                Strings.navProfile,
//              style: TextStyle(
//                fontFamily: 'Iransans',
//                fontSize: MediaQuery.of(context).textScaleFactor * 10.0,
//              ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
