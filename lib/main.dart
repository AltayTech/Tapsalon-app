import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tapsalon/provider/app_theme.dart';
import 'package:tapsalon/screen/place_detail/place_detail_comments_screen.dart';
import 'package:tapsalon/screen/place_detail/place_location_screen.dart';
import 'package:tapsalon/screen/user_profile/user_detail_info_screen.dart';
import 'package:tapsalon/screen/user_profile/user_detail_reserve_screen.dart';

import './provider/auth.dart';
import './provider/places.dart';
import './provider/salons.dart';
import './provider/strings.dart';
import './provider/user_info.dart';
import './screen/about_us_screen.dart';
import './screen/contact_with_us_screen.dart';
import './screen/favorite_screen.dart';
import './screen/home_screen.dart';
import './screen/map_screen.dart';
import './screen/navigation_bottom_screen.dart';
import './screen/search_screen.dart';
import './screen/splash_Screen.dart';
import './screen/user_profile/login_screen.dart';
import './widget/favorite_view.dart';
import 'models/user_models/user.dart';
import 'provider/cities.dart';
import 'screen/place_detail/comment_create_screen.dart';
import 'screen/place_detail/place_detail_screen.dart';
import 'screen/place_detail/place_detail_timing_screen.dart';
import 'screen/user_profile/profile_screen.dart';
import 'screen/user_profile/user_detail_info_edit_screen.dart';

void main() => runApp(MyApp());

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    super.initState();
  }

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
            create: (ctx) => Places(),
          ),
          ChangeNotifierProvider(
            create: (ctx) => UserInfo(),
          ),
          ChangeNotifierProvider(
            create: (ctx) => User(),
          ),
        ],
        child:
//      Platform.isAndroid
//          ?
            MaterialApp(
          title: Strings.appTitle,
          theme: ThemeData(
            primaryColor: AppTheme.white,
            backgroundColor: AppTheme.bg,
            textTheme: AppTheme.textTheme,
          ),
          home: Directionality(
            child: SplashScreens(),
            textDirection: TextDirection.rtl, // setting rtl
          ),
          routes: {
            HomeScreen.routeName: (ctx) => HomeScreen(),
            FavoriteScreen.routeName: (ctx) => FavoriteScreen(),
            FavoriteView.routeName: (ctx) => FavoriteView(),
            PlaceDetailScreen.routeName: (ctx) => PlaceDetailScreen(),
            LoginScreen.routeName: (ctx) => LoginScreen(),
            UserDetailInfoEditScreen.routeName: (ctx) =>
                UserDetailInfoEditScreen(),
            ProfileScreen.routeName: (ctx) => ProfileScreen(),
            SearchScreen.routeName: (ctx) => SearchScreen(),
            AboutUsScreen.routeName: (ctx) => AboutUsScreen(),
            ContactWithUs.routeName: (ctx) => ContactWithUs(),
            NavigationBottomScreen.routeName: (ctx) => NavigationBottomScreen(),
            CommentCreateScreen.routeName: (ctx) => CommentCreateScreen(),
            MapScreen.routeName: (ctx) => MapScreen(),
            UserDetailInfoScreen.routeName: (ctx) => UserDetailInfoScreen(),
            UserDetailReserveScreen.routeName: (ctx) =>
                UserDetailReserveScreen(),
            PlaceDetailTimingScreen.routeName: (ctx) =>
                PlaceDetailTimingScreen(),
            PlaceDetailCommentsScreen.routeName: (ctx) =>
                PlaceDetailCommentsScreen(),
            PlaceLocationScreen.routeName: (ctx) => PlaceLocationScreen(),
          },
        )
//          : Platform.isIOS
//              ? CupertinoApp(
//                  title: Strings.appTitle,
//                  home: Directionality(
//                    child: SplashScreens(),
//                    textDirection: TextDirection.rtl, // setting rtl
//                  ),
//                  routes: {
//                    HomeScreen.routeName: (ctx) => HomeScreen(),
//                    FavoriteScreen.routeName: (ctx) => FavoriteScreen(),
//                    FavoriteView.routeName: (ctx) => FavoriteView(),
//                    PlaceDetailScreen.routeName: (ctx) => PlaceDetailScreen(),
//                    LoginScreen.routeName: (ctx) => LoginScreen(),
//                    UserDetailInfoEditScreen.routeName: (ctx) =>
//                        UserDetailInfoEditScreen(),
//                    ProfileScreen.routeName: (ctx) => ProfileScreen(),
//                    SearchScreen.routeName: (ctx) => SearchScreen(),
//                    AboutUsScreen.routeName: (ctx) => AboutUsScreen(),
//                    ContactWithUs.routeName: (ctx) => ContactWithUs(),
//                    NavigationBottomScreen.routeName: (ctx) =>
//                        NavigationBottomScreen(),
//                    ReserveDetailScreen.routeName: (ctx) =>
//                        ReserveDetailScreen(),
//                    NotificationScreen.routeName: (ctx) => NotificationScreen(),
//                    CommentCreateScreen.routeName: (ctx) =>
//                        CommentCreateScreen(),
//                    MapScreen.routeName: (ctx) => MapScreen(),
//                  },
//                )
//              : MaterialApp(
//                  title: Strings.appTitle,
//                  theme: ThemeData(
//                    primarySwatch: Colors.green,
//                    accentColor: Colors.amber,
//                    textTheme: ThemeData.light().textTheme.copyWith(
//                          bodyText1: TextStyle(
//                            fontFamily: 'Iransans',
//                            color: Color.fromRGBO(20, 51, 51, 1),
//                          ),
//                          bodyText2: TextStyle(
//                            fontFamily: 'Iransans',
//                            color: Color.fromRGBO(20, 51, 51, 1),
//                          ),
//                          headline1: TextStyle(
//                            fontSize: 20,
//                            fontFamily: 'Iransans',
//                            fontWeight: FontWeight.bold,
//                          ),
//                        ),
//                  ),
//                  // home: CategoriesScreen(),
//
//                  home: Directionality(
//                    child: SplashScreens(),
//                    textDirection: TextDirection.rtl, // setting rtl
//                  ),
//                  routes: {
//                    HomeScreen.routeName: (ctx) => HomeScreen(),
//                    FavoriteScreen.routeName: (ctx) => FavoriteScreen(),
//                    FavoriteView.routeName: (ctx) => FavoriteView(),
//                    PlaceDetailScreen.routeName: (ctx) => PlaceDetailScreen(),
//                    LoginScreen.routeName: (ctx) => LoginScreen(),
//                    UserDetailInfoEditScreen.routeName: (ctx) =>
//                        UserDetailInfoEditScreen(),
//                    ProfileScreen.routeName: (ctx) => ProfileScreen(),
//                    SearchScreen.routeName: (ctx) => SearchScreen(),
//                    AboutUsScreen.routeName: (ctx) => AboutUsScreen(),
//                    ContactWithUs.routeName: (ctx) => ContactWithUs(),
//                    NavigationBottomScreen.routeName: (ctx) =>
//                        NavigationBottomScreen(),
//                    ReserveDetailScreen.routeName: (ctx) =>
//                        ReserveDetailScreen(),
//                    NotificationScreen.routeName: (ctx) => NotificationScreen(),
//                    CommentCreateScreen.routeName: (ctx) =>
//                        CommentCreateScreen(),
//                    MapScreen.routeName: (ctx) => MapScreen(),
//                  },
//                ),
        );
  }
}
