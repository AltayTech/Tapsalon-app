import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../provider/app_theme.dart';
import '../provider/cities.dart';
import '../widget/dialogs/select_city_dialog.dart';
import '../widget/favorite_view.dart';
import '../widget/main_drawer.dart';

class FavoriteScreen extends StatefulWidget {
  static const routeName = '/FavoriteScreen';

  @override
  _FavoriteScreenState createState() => _FavoriteScreenState();
}

class _FavoriteScreenState extends State<FavoriteScreen>
    with SingleTickerProviderStateMixin {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    double deviceHeight = MediaQuery.of(context).size.height;
    double deviceWidth = MediaQuery.of(context).size.width;
    var textScaleFactor = MediaQuery.of(context).textScaleFactor;

    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        key: _scaffoldKey,
        backgroundColor: Color(0xffF9F9F9),
        appBar: AppBar(
          elevation: 0,
          centerTitle: true,
          title: Text(
            'مکان ها مورد علاقه',
            style: TextStyle(
                color: AppTheme.black,
                fontFamily: 'Iransans',
                fontSize: textScaleFactor * 18),
          ),
          backgroundColor: AppTheme.appBarColor,
          iconTheme: new IconThemeData(color: AppTheme.appBarIconColor),
          actions: <Widget>[
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
                              color: AppTheme.appBarIconColor,
                              fontFamily: 'Iransans',
                              fontSize: MediaQuery.of(context).textScaleFactor *
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
        body: FavoriteView(),
        drawer: Theme(
          data: Theme.of(context).copyWith(
            // Set the transparency here
            canvasColor: Colors
                .white, //or any other color you want. e.g Colors.blue.withOpacity(0.5)
          ),
          child: MainDrawer(),
        ),
      ),
    );
  }
}
