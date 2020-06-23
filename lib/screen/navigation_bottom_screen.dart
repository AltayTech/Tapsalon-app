import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/city.dart';
import '../provider/app_theme.dart';
import '../provider/cities.dart';
import '../provider/strings.dart';
import '../screen/home_screen.dart';
import '../screen/map_screen.dart';
import '../screen/reserve_detail_screen.dart';
import '../screen/user_profile/profile_view.dart';
import '../widget/custom_dialog_enter.dart';
import '../widget/favorite_view.dart';
import '../widget/main_drawer.dart';
import '../widget/select_city_dialog.dart';

class NavigationBottomScreen extends StatefulWidget {
  static const routeName = '/NavigationBottomScreen';

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

  void _showLoginDialog() {
    showDialog(
        context: context,
        builder: (ctx) => CustomDialogEnter(
              title: 'ورود',
              buttonText: 'صفحه ورود ',
              description: 'برای ادامه باید وارد شوید',
            ));
  }

  Future<bool> _onBackPressed() {
    return showDialog(
          context: context,
          builder: (context) => new AlertDialog(
            contentTextStyle: TextStyle(
                color: AppTheme.grey,
                fontFamily: 'Iransans',
                fontSize: MediaQuery.of(context).textScaleFactor * 15.0),
            title: Text(
              'خروج از اپلیکیشن',
              textAlign: TextAlign.center,
              style: TextStyle(
                  color: AppTheme.black,
                  fontFamily: 'Iransans',
                  fontSize: MediaQuery.of(context).textScaleFactor * 15.0),
            ),
            content: Text(
              'آیا میخواهید از اپلیکیشن خارج شوید؟',
              style: TextStyle(
                  color: AppTheme.grey,
                  fontFamily: 'Iransans',
                  fontSize: MediaQuery.of(context).textScaleFactor * 15.0),
            ),
            actionsPadding: EdgeInsets.all(10),
            actions: <Widget>[
              GestureDetector(
                onTap: () => Navigator.of(context).pop(false),
                child: Text(
                  "نه",
                  style: TextStyle(
                      color: AppTheme.black,
                      fontFamily: 'Iransans',
                      fontSize: MediaQuery.of(context).textScaleFactor * 18.0),
                ),
              ),
              SizedBox(
                height: 16,
                width: MediaQuery.of(context).size.width * 0.3,
              ),
              GestureDetector(
                onTap: () {
                  Navigator.of(context).pop(true);
                },
                child: Text("بلی"),
              ),
            ],
          ),
        ) ??
        false;
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
    return WillPopScope(
      onWillPop: _onBackPressed,
      child: Directionality(
        textDirection: TextDirection.rtl,
        child: Scaffold(
          key: _scaffoldKey,
          appBar: AppBar(
            backgroundColor: AppTheme.appBarColor,
            elevation:0 ,
            iconTheme:IconThemeData(color: AppTheme.appBarIconColor) ,
            actions: <Widget>[
              Consumer<Cities>(
                builder: (_, cities, ch) => Padding(
                  padding: const EdgeInsets.only(left: 10.0),
                  child: InkWell(
                    onTap: () {
                      showDialog(
                          context: context,
                          builder: (ctx) => SelectCityDialog());
                    },
                    child: Directionality(
                      textDirection: TextDirection.ltr,
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                          Text(
                            cities.selectedCity.name,
                            style: TextStyle(
                                color: AppTheme.appBarIconColor,
                                fontFamily: 'Iransans',
                                fontSize:
                                    MediaQuery.of(context).textScaleFactor *
                                        12.0),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(3.0),
                            child: Icon(
                              Icons.arrow_drop_down,
                              color: AppTheme.appBarIconColor,

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
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
