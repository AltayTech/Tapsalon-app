import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:intl/intl.dart' as intl;
import 'package:provider/provider.dart';

import 'file:///C:/AndroidStudioProjects/Pro_tapsalon/tapsalon_flutter/tapsalon/lib/provider/app_theme.dart';

import '../models/favorite.dart';
import '../models/searchDetails.dart';
import '../provider/auth.dart';
import '../provider/complexes.dart';
import '../screen/user_profile/login_screen.dart';
import '../widget/favorite_complex_item.dart';

class FavoriteView extends StatefulWidget {
  static const routeName = '/favorite-view';

  @override
  _FavoriteViewState createState() => _FavoriteViewState();
}

class _FavoriteViewState extends State<FavoriteView>
    with SingleTickerProviderStateMixin {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  bool _isInit = true;
  var _isLoading;
  int page = 1;
  List<String> filterList = [];

  SearchDetails searchDetails;
  final searchTextController = TextEditingController();

  ScrollController _scrollController = new ScrollController();

  @override
  void initState() {
    _scrollController.addListener(() {
      if (_scrollController.position.pixels ==
          _scrollController.position.maxScrollExtent) {
        page = page + 1;
        Provider.of<Complexes>(context, listen: false).sPage = page;
        searchItems();
      }
    });

    super.initState();
  }

  @override
  void dispose() {
    _scrollController.dispose();

    super.dispose();
  }

  @override
  void didChangeDependencies() {
    if (_isInit) {
      searchItems();
    }
    _isInit = false;
    super.didChangeDependencies();
  }

  List<Favorite> loadedComplexes = [];
  List<Favorite> loadedComplexestolist = [];

  Future<void> _submit() async {
    loadedComplexes.clear();
    loadedComplexes =
        Provider.of<Complexes>(context, listen: false).favoriteItems;
    loadedComplexestolist.addAll(loadedComplexes);
  }

  Future<void> searchItems() async {
    setState(() {
      _isLoading = true;
    });
    await Provider.of<Complexes>(context, listen: false)
        .retrieveFavoriteComplex();
    searchDetails = Provider.of<Complexes>(context, listen: false)
        .favoriteComplexSearchDetails;
    _submit();

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

    bool isLogin = Provider.of<Auth>(context).isAuth;

    return !isLogin
        ? Container(
            child: Center(
              child: Wrap(
                direction: Axis.vertical,
                crossAxisAlignment: WrapCrossAlignment.center,
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text('شما وارد نشده اید'),
                  ),
                  InkWell(
                    onTap: () {
                      Navigator.of(context).pushNamed(LoginScreen.routeName);
                    },
                    child: Container(
                      child: Padding(
                        padding: const EdgeInsets.all(15.0),
                        child: Text(
                          'ورود به اکانت کاربری',
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                      decoration: BoxDecoration(
                          color: Colors.green,
                          borderRadius: BorderRadius.circular(5)),
                    ),
                  )
                ],
              ),
            ),
          )
        : Directionality(
            textDirection: TextDirection.rtl,
            child: SingleChildScrollView(
              child: Padding(
                padding: EdgeInsets.symmetric(
                    vertical: deviceHeight * 0.0,
                    horizontal: deviceWidth * 0.03),
                child: Stack(
                  children: <Widget>[
                    Container(
                      width: double.infinity,
                      height:
                          deviceHeight - Scaffold.of(context).appBarMaxHeight,
                      child: ListView.builder(
                        controller: _scrollController,
                        scrollDirection: Axis.vertical,
                        itemCount: loadedComplexestolist.length,
                        itemBuilder: (ctx, i) => ChangeNotifierProvider.value(
                          value: loadedComplexestolist[i],
                          child: Container(
                            height: deviceHeight * 0.3,
                            child: FavoriteComplexItem(
                              loadedComplex: loadedComplexestolist[i],
                            ),
                          ),
                        ),
                      ),
                    ),
                    Positioned(
                        top: 0,
                        bottom: 0,
                        left: 0,
                        right: 0,
                        child: Align(
                            alignment: Alignment.center,
                            child: _isLoading
                                ? SpinKitFadingCircle(
                                    itemBuilder:
                                        (BuildContext context, int index) {
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
                                : Container(
                                    child: loadedComplexestolist.isEmpty
                                        ? Center(
                                            child: Text(
                                            'سالنی وجود ندارد',
                                            style: TextStyle(
                                              fontFamily: 'Iransans',
                                              fontSize: textScaleFactor * 15.0,
                                            ),
                                          ))
                                        : Container())))
                  ],
                ),
              ),
            ),
          );
  }
}
