import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:provider/provider.dart';
import 'package:tapsalon/models/city.dart';
import 'package:tapsalon/models/places_models/place_in_search.dart';
import 'package:tapsalon/models/search_argument.dart';
import 'package:tapsalon/provider/app_theme.dart';

import '../provider/cities.dart';
import '../provider/places.dart';
import '../provider/strings.dart';
import '../screen/search_screen.dart';
import '../widget/horizontal_list.dart';
import '../widget/items/main_topic_item.dart';

class HomeScreen extends StatefulWidget {
  static const routeName = '/home';

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  bool _isInit = true;
  var _isLoading;
  var _searchTextController = TextEditingController();

  List<PlaceInSearch> loadedPlace = [];
  List<PlaceInSearch> loadedPlaceMostViewed = [];
  List<PlaceInSearch> loadedPlaceBestRated = [];

  City selectedCity;

  @override
  void initState() {
    super.initState();
  }

  @override
  void didChangeDependencies() {
    if (_isInit) {
      getMainItems();
    }
    _isInit = false;
    super.didChangeDependencies();
  }

  Future<void> cleanFilters(BuildContext context) async {
    Provider.of<Places>(context, listen: false).searchKey = '';
    Provider.of<Places>(context, listen: false).filterTitle.clear();
    Provider.of<Places>(context, listen: false).sProvinceId = '';
    Provider.of<Places>(context, listen: false).sType = '';
    Provider.of<Places>(context, listen: false).sField = '';
    Provider.of<Places>(context, listen: false).sFacility = '';
    Provider.of<Places>(context, listen: false).sPlaceType = '';

    Provider.of<Places>(context, listen: false).searchBuilder();
  }

  Future<void> getMainItems() async {
    print('deviceHeight' + MediaQuery.of(context).size.height.toString());
    print('deviceWidth' + MediaQuery.of(context).size.width.toString());
    print('devicePixelRatio' +
        MediaQuery.of(context).devicePixelRatio.toString());
    setState(() {
      _isLoading = true;
    });
    cleanFilters(context);
    try {
      await Provider.of<Cities>(context, listen: false).getSelectedCity();
      selectedCity = Provider.of<Cities>(context, listen: false).selectedCity;
      Provider.of<Places>(context, listen: false).sCityId = selectedCity.id;
    } catch (_) {}

    loadedPlaceMostViewed = await retrieveMainItem('visit');
    loadedPlaceBestRated = await retrieveMainItem('rate');
    loadedPlace = await retrieveMainItem('');

    setState(() {
      _isLoading = false;
    });
  }

  Future<List<PlaceInSearch>> retrieveMainItem(String orderby) async {
    List<PlaceInSearch> loadedPlaces = [];

    cleanFilters(context);

    try {
      loadedPlaces = await Provider.of<Places>(context, listen: false)
          .retrieveNewItemInCity(selectedCity, orderby);
    } catch (_) {}

    return loadedPlaces;
  }

  @override
  Widget build(BuildContext context) {
    double deviceHeight = MediaQuery.of(context).size.height;
    double deviceWidth = MediaQuery.of(context).size.width;
    double textScaleFactor = MediaQuery.of(context).textScaleFactor;
    print('deviceHeight' + deviceHeight.toString());
    print('deviceWidth' + deviceWidth.toString());

    return Stack(
      children: [
        SingleChildScrollView(
          child: Column(
            children: <Widget>[
              Column(
                children: <Widget>[
                  Padding(
                    padding: EdgeInsets.all(deviceHeight * 0.02),
                    child: Container(
                      height: 50,
                      decoration: BoxDecoration(
                          color: Colors.white,
                          boxShadow: [
                            BoxShadow(
                              color: AppTheme.grey.withOpacity(0.3),
                              blurRadius: 6,
                              spreadRadius: 3,
                              offset: Offset(
                                0,
                                0,
                              ),
                            ),
                          ],
                          borderRadius: BorderRadius.all(Radius.circular(50))),
                      child: Padding(
                        padding: const EdgeInsets.only(left: 8, right: 16),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: <Widget>[
                            Expanded(
                              child: TextFormField(
                                controller: _searchTextController,
                                textInputAction: TextInputAction.search,
                                style: TextStyle(
                                  color: AppTheme.black,
                                  fontFamily: 'Iransans',
                                ),
                                onFieldSubmitted: (_) {
                                  cleanFilters(context);

                                  Provider.of<Places>(context, listen: false)
                                      .searchKey = _searchTextController.text;
                                  Provider.of<Places>(context, listen: false)
                                      .searchBuilder();
                                  return Navigator.of(context).pushNamed(
                                      SearchScreen.routeName,
                                      arguments: SearchArgument(
                                          tabIndex: 0, sortValue: 'جدیدترین'));
                                },
                                textAlignVertical: TextAlignVertical.center,
                                decoration: InputDecoration(
                                  border: InputBorder.none,
                                  hintStyle: TextStyle(
                                    color: Colors.grey,
                                    fontFamily: 'Iransans',
                                    fontSize: textScaleFactor * 12.0,
                                  ),
                                  hintText: 'جستجو',
                                  labelStyle: TextStyle(
                                    color: Colors.grey,
                                    fontFamily: 'Iransans',
                                    fontSize: textScaleFactor * 10.0,
                                  ),
                                ),
                              ),
                            ),
                            InkWell(
                              onTap: () {
                                cleanFilters(context);

                                Provider.of<Places>(context, listen: false)
                                    .searchKey = _searchTextController.text;
                                Provider.of<Places>(context, listen: false)
                                    .searchBuilder();
                                return Navigator.of(context).pushNamed(
                                    SearchScreen.routeName,
                                    arguments: SearchArgument(
                                        tabIndex: 0, sortValue: 'جدیدترین'));
                              },
                              child: Padding(
                                padding: const EdgeInsets.all(2.0),
                                child: Icon(
                                  Icons.search,
                                  color: Colors.grey.withOpacity(0.5),
                                  size: 30,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  Container(
//                height: deviceHeight * 0.18,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(0),
                      color: AppTheme.white,
                    ),
                    child: Padding(
                      padding: const EdgeInsets.only(top: 8.0, bottom: 8),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: <Widget>[
                          InkWell(
                            onTap: () {
                              cleanFilters(context);

                              Navigator.of(context).pushNamed(
                                  SearchScreen.routeName,
                                  arguments: SearchArgument(
                                      tabIndex: 1, sortValue: 'جدیدترین'));
                            },
                            child: MainTopicItem(
                              number: 1,
                              title: Strings.titleSalons,
                              icon: 'assets/images/main_page_salon_ic.png',
                              bgColor: AppTheme.bg,
                              iconColor: AppTheme.mainPageColor,
                            ),
                          ),
                          InkWell(
                            onTap: () {
                              cleanFilters(context);

                              Navigator.of(context).pushNamed(
                                  SearchScreen.routeName,
                                  arguments: SearchArgument(
                                      tabIndex: 2, sortValue: 'جدیدترین'));
                            },
                            child: MainTopicItem(
                              number: 1,
                              title: Strings.titlClubs,
                              icon: 'assets/images/main_page_gym_ic.png',
                              bgColor: AppTheme.bg,
                              iconColor: AppTheme.mainPageColor,
                            ),
                          ),
                          InkWell(
                            onTap: () {
                              cleanFilters(context);

                              Navigator.of(context).pushNamed(
                                  SearchScreen.routeName,
                                  arguments: SearchArgument(
                                      tabIndex: 4, sortValue: 'جدیدترین'));
                            },
                            child: MainTopicItem(
                              number: 1,
                              title: Strings.titleEntertainment,
                              icon: 'assets/images/main_page_ent_ic.png',
                              bgColor: AppTheme.bg,
                              iconColor: AppTheme.mainPageColor,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: 16,
              ),
              new HorizontalList(
                list: loadedPlace,
                listTitle: 'جدیدترین',
              ),
              new HorizontalList(
                list: loadedPlaceBestRated,
                listTitle: 'محبوبترین',
              ),
              new HorizontalList(
                list: loadedPlaceMostViewed,
                listTitle: 'پربازدیدترین',
              ),
            ],
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
                : Container(),
          ),
        ),
      ],
    );
  }
}
