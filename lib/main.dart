import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tapsalon/models/strings.dart';
import 'package:tapsalon/models/user.dart';
import 'package:tapsalon/provider/auth.dart';
import 'package:tapsalon/provider/complexes.dart';
import 'package:tapsalon/provider/salons.dart';
import 'package:tapsalon/provider/user_info.dart';
import 'package:tapsalon/screen/about_us_screen.dart';
import 'package:tapsalon/screen/complex_detail/complex_detail_screen.dart';
import 'package:tapsalon/screen/contact_with_us_screen.dart';
import 'package:tapsalon/screen/navigation_bottom_screen.dart';
import 'package:tapsalon/screen/notification_screen.dart';
import 'package:tapsalon/screen/place_detail/salon_detail_screen.dart';
import 'package:tapsalon/screen/reserve_detail_screen.dart';
import 'package:tapsalon/screen/search_screen.dart';
import 'package:tapsalon/screen/splash_Screen.dart';
import 'package:tapsalon/screen/user_profile/login_screen.dart';
import 'package:tapsalon/widget/favorite_view.dart';

import './screen/favorite_screen.dart';
import './screen/home_screen.dart';
import './screen/map_screen.dart';
import 'provider/cities.dart';
import 'screen/complex_detail/comment_create_screen.dart';
import 'screen/user_profile/profile_screen.dart';
import 'screen/user_profile/user_detail_info_edit_screen.dart';

void main() => runApp(MyApp());

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (ctx) => Salons(),
        ),
        ChangeNotifierProvider(
          create: (ctx) => Cities(),
        ),
        ChangeNotifierProvider(
          create: (ctx) => Auth(),
        ),
        ChangeNotifierProvider(
          create: (ctx) => Complexes(),
        ),
        ChangeNotifierProvider(
          create: (ctx) => UserInfo(),
        ),
        ChangeNotifierProvider(
          create: (ctx) => User(),
        ),
      ],
      child: MaterialApp(
        title: Strings.appTitle,
        theme: ThemeData(
          primarySwatch: Colors.green,
          accentColor: Colors.amber,
          textTheme: ThemeData.light().textTheme.copyWith(
                body1: TextStyle(
                  fontFamily: 'Iransans',
                  color: Color.fromRGBO(20, 51, 51, 1),
                ),
                body2: TextStyle(
                  fontFamily: 'Iransans',
                  color: Color.fromRGBO(20, 51, 51, 1),
                ),
                title: TextStyle(
                  fontSize: 20,
                  fontFamily: 'Iransans',
                  fontWeight: FontWeight.bold,
                ),
              ),
        ),
        // home: CategoriesScreen(),

        home: Directionality(
          child: SplashScreens(),
          textDirection: TextDirection.rtl, // setting rtl
        ),
        routes: {
          // '/': (ctx) => NavigationBottomScreen(),
          HomeScreeen.routeName: (ctx) => HomeScreeen(),
          FavoriteScreen.routeName: (ctx) => FavoriteScreen(),
          FavoriteView.routeName: (ctx) => FavoriteView(),
          MapScreen.routeName: (ctx) => MapScreen(),
          ComplexDetailScreen.routeName: (ctx) => ComplexDetailScreen(),
          SalonDetailScreen.routeName: (ctx) => SalonDetailScreen(),
          LoginScreen.routeName: (ctx) => LoginScreen(),

          UserDetailInfoEditScreen.routeName: (ctx) =>
              UserDetailInfoEditScreen(),
          ProfileScreen.routeName: (ctx) => ProfileScreen(),

          SearchScreen.routeName: (ctx) => SearchScreen(),
          AboutUsScreen.routeName: (ctx) => AboutUsScreen(),
          ContactWithUs.routeName: (ctx) => ContactWithUs(),
          NavigationBottomScreen.routeName: (ctx) => NavigationBottomScreen(),
          ReserveDetailScreen.routeName: (ctx) => ReserveDetailScreen(),
          NotificationScreen.routeName: (ctx) => NotificationScreen(),

          CommentCreateScreen.routeName: (ctx) => CommentCreateScreen(),
        },
      ),
    );
  }
}
