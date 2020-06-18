import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tapsalon/models/city.dart';
import 'package:tapsalon/models/place_in_search.dart';

import '../provider/cities.dart';
import '../provider/places.dart';
import '../provider/strings.dart';
import '../provider/user_info.dart';
import '../screen/search_screen.dart';
import '../widget/MainTopicItem.dart';
import '../widget/horizontal_list.dart';

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
    } catch (_) {}

    try {
      await Provider.of<Places>(context, listen: false)
          .retrieveCityComplexes(selectedCity.id);
      loadedPlace = Provider.of<Places>(context, listen: false).itemsCityPlace;
    } catch (_) {}

    try {
      await Provider.of<UserInfo>(context, listen: false).getNotification();
    } catch (_) {}

    setState(() {
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    double deviceHeight = MediaQuery.of(context).size.height;
    double deviceWidth = MediaQuery.of(context).size.width;
    double textScaleFactor = MediaQuery.of(context).textScaleFactor;

    return SingleChildScrollView(
      child: Column(
        children: <Widget>[
          SizedBox(
            width: double.infinity,
            height: deviceHeight * 0.32,
            child: Stack(
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.only(
                    bottom: 30,
                  ),
                  child: Container(
                    padding: EdgeInsets.all(5.0),
                    alignment: Alignment.bottomCenter,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.centerLeft,
                        end: Alignment.centerRight,
                        colors: <Color>[
                          Color.fromRGBO(133, 183, 216, 1.0),
                          Color.fromRGBO(71, 147, 197, 1.0),
                          Color.fromRGBO(133, 183, 216, 1.0),
                        ],
                      ),
                    ),
                  ),
                ),
                Column(
                  children: <Widget>[
                    Padding(
                      padding: EdgeInsets.all(deviceHeight * 0.05),
                      child: Container(
                        height: deviceHeight * 0.06,
                        decoration: new BoxDecoration(
                            color: Colors.white,
                            borderRadius:
                                new BorderRadius.all(Radius.circular(10))),
                        child: Row(
                          children: <Widget>[
                            InkWell(
                              onTap: () {
                                cleanFilters(context);

                                Provider.of<Places>(context, listen: false)
                                    .searchKey = _searchTextController.text;
                                Provider.of<Places>(context, listen: false)
                                    .searchBuilder();
                                return Navigator.of(context).pushNamed(
                                    SearchScreen.routeName,
                                    arguments: 0);
                              },
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Icon(
                                  Icons.search,
                                  color: Colors.blue,
                                ),
                              ),
                            ),
                            Expanded(
                              child: TextFormField(
                                controller: _searchTextController,
                                textInputAction: TextInputAction.search,
                                decoration: InputDecoration(
                                  border: InputBorder.none,
                                  hintStyle: TextStyle(
                                    color: Colors.blue,
                                    fontFamily: 'Iransans',
                                    fontSize: textScaleFactor * 12.0,
                                  ),
                                  hintText: 'جستجوی مجموعه ...',
                                  labelStyle: TextStyle(
                                    color: Colors.blue,
                                    fontFamily: 'Iransans',
                                    fontSize: textScaleFactor * 10.0,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    Container(
                      height: deviceHeight * 0.15,
                      width: double.infinity,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: <Widget>[
                          InkWell(
                            onTap: () {
                              cleanFilters(context);
                              Provider.of<Places>(context, listen: false)
                                  .sType = '1';

                              Navigator.of(context).pushNamed(
                                  SearchScreen.routeName,
                                  arguments: 1);
                            },
                            child: MainTopicItem(
                              number: 1,
                              title: Strings.titleSalons,
                              icon: 'assets/images/salon.png',
                              bgColor: Color(0xffFB8C00),
                            ),
                          ),
                          InkWell(
                            onTap: () {
                              cleanFilters(context);
                              Provider.of<Places>(context, listen: false)
                                  .sType = '2';

                              Navigator.of(context).pushNamed(
                                  SearchScreen.routeName,
                                  arguments: 2);
                            },
                            child: MainTopicItem(
                              number: 1,
                              title: Strings.titlClubs,
                              icon: 'assets/images/gym.png',
                              bgColor: Color(0xffFFB300),
                            ),
                          ),
                          InkWell(
                            onTap: () {
                              cleanFilters(context);
                              Provider.of<Places>(context, listen: false)
                                  .sType = '3';

                              Navigator.of(context).pushNamed(
                                  SearchScreen.routeName,
                                  arguments: 3);
                            },
                            child: MainTopicItem(
                              number: 1,
                              title: Strings.titleEntertainment,
                              icon: 'assets/images/swimming.png',
                              bgColor: Color(0xffFE5E2B),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          new HorizontalList(
            list: loadedPlace,
            listTitle: 'سالن های محبوب',
          ),
          new HorizontalList(
            list: loadedPlace,
            listTitle: 'سالن های جدید',
          ),
          new HorizontalList(
            list: loadedPlace,
            listTitle: 'سالن های پربازدید',
          ),
        ],
      ),
    );
  }
}
