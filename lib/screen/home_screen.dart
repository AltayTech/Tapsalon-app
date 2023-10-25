import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tapsalon/models/city.dart';
import 'package:tapsalon/models/places_models/place_in_search.dart';
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

  late City selectedCity;

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
    Provider.of<Places>(context, listen: false).searchBuilder();
  }

  Future<void> getMainItems() async {
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

    return SingleChildScrollView(
      child: Column(
        children: <Widget>[
          Column(
            children: <Widget>[
              Padding(
                padding: EdgeInsets.all(deviceHeight * 0.02),
                child: Container(
                  height: deviceHeight * 0.06,
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
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.only(right: 8.0),
                            child: TextFormField(
                              controller: _searchTextController,
                              textInputAction: TextInputAction.search,
                              style: TextStyle(
                                color: AppTheme.black,
                                fontFamily: 'Iransans',
                              ),
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
                        ),
                        InkWell(
                          onTap: () {
                            cleanFilters(context);

                            Provider.of<Places>(context, listen: false)
                                .searchKey = _searchTextController.text;
                            Provider.of<Places>(context, listen: false)
                                .searchBuilder();
                            Navigator.of(context).pushNamed(
                                SearchScreen.routeName,
                                arguments: 0);
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
                height: deviceHeight * 0.18,
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
                          Provider.of<Places>(context, listen: false).sType =
                              '1';

                          Navigator.of(context)
                              .pushNamed(SearchScreen.routeName, arguments: 1);
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
                          Provider.of<Places>(context, listen: false).sType =
                              '2';

                          Navigator.of(context)
                              .pushNamed(SearchScreen.routeName, arguments: 2);
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
                          Provider.of<Places>(context, listen: false).sType =
                              '3';

                          Navigator.of(context)
                              .pushNamed(SearchScreen.routeName, arguments: 3);
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
            listTitle: 'سالن های جدید',
          ),
          new HorizontalList(
            list: loadedPlaceBestRated,
            listTitle: 'سالن های محبوب',
          ),
          new HorizontalList(
            list: loadedPlaceMostViewed,
            listTitle: 'سالن های پربازدید',
          ),
        ],
      ),
    );
  }
}
