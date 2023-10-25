import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:intl/intl.dart' as intl;
import 'package:provider/provider.dart';
import 'package:tapsalon/models/places_models/place_in_search.dart';

import '../models/searchDetails.dart';
import '../provider/app_theme.dart';
import '../provider/cities.dart';
import '../provider/places.dart';
import '../provider/user_info.dart';
import '../widget/badge.dart';
import '../widget/en_to_ar_number_convertor.dart';
import '../widget/filter_drawer.dart';
import '../widget/main_drawer.dart';
import '../widget/dialogs/select_city_dialog.dart';
import 'package:badges/badges.dart' as badges;

class SalonFinderScreen extends StatefulWidget {
  static const routeName = '/searchScreen';

  @override
  _SalonFinderScreenState createState() => _SalonFinderScreenState();
}

class _SalonFinderScreenState extends State<SalonFinderScreen>
    with SingleTickerProviderStateMixin {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  bool _isInit = true;
  var _isLoading;
  int page = 1;
  List<String> filterList = [];

  late SearchDetails searchDetails;
  final searchTextController = TextEditingController();
  late TabController _tabController;

  ScrollController _scrollController = new ScrollController();

  @override
  void initState() {
    _tabController = TabController(vsync: this, length: 4);
    _tabController.addListener(_handleTabSelection);

    _scrollController.addListener(() {
      if (_scrollController.position.pixels ==
          _scrollController.position.maxScrollExtent) {
        page = page + 1;
        Provider.of<Places>(context, listen: false).sPage = page;
        searchItems();
      }
    });

    super.initState();
  }

  void _handleTabSelection() {
    setState(() {});
  }

  @override
  void dispose() {
    _tabController.dispose();

    _scrollController.dispose();

    super.dispose();
  }

  @override
  void didChangeDependencies() {
    if (_isInit) {
      int tabIndex = ModalRoute.of(context)?.settings.arguments as int;
      _tabController.index = tabIndex;

      Provider.of<Places>(context, listen: false).searchBuilder();

      searchItems();
    }
    _isInit = false;
    super.didChangeDependencies();
  }

  List<PlaceInSearch> loadedComplexes = [];
  List<PlaceInSearch> loadedComplexestolist = [];

  Future<void> _submit() async {
    loadedComplexes.clear();
    loadedComplexes = Provider.of<Places>(context, listen: false).items;
    loadedComplexestolist.addAll(loadedComplexes);
  }

  Future<void> filterItems() async {
    loadedComplexes.clear();
    await searchItems();
  }

  Future<void> searchItems() async {
    setState(() {
      _isLoading = true;
    });
    Provider.of<Places>(context, listen: false).searchBuilder();
    await Provider.of<Places>(context, listen: false).searchItem();
    filterList = Provider.of<Places>(context, listen: false).filterTitle;
    searchDetails =
        Provider.of<Places>(context, listen: false).placeSearchDetails;
    _submit();

    setState(() {
      _isLoading = false;
      print(_isLoading.toString());
    });
    print(_isLoading.toString());
  }

  Future<void> setSort(String sortValue) async {
    if (sortValue == 'محبوبترین') {
      Provider.of<Places>(context, listen: false).sOrderBy = 'stars';
      Provider.of<Places>(context, listen: false).sSort = 'DESC';
    } else if (sortValue == 'پربازدیدترین') {
      Provider.of<Places>(context, listen: false).sOrderBy = 'visits_no';
      Provider.of<Places>(context, listen: false).sSort = 'DESC';
    } else if (sortValue == 'پرطرفدارترین') {
      Provider.of<Places>(context, listen: false).sOrderBy = 'likes_no';
      Provider.of<Places>(context, listen: false).sSort = 'DESC';
    } else if (sortValue == 'کم بازدیدترین') {
      Provider.of<Places>(context, listen: false).sOrderBy = 'visits_no';
      Provider.of<Places>(context, listen: false).sSort = 'ASC';
    } else {
      Provider.of<Places>(context, listen: false).sOrderBy = 'name';
      Provider.of<Places>(context, listen: false).sSort = 'ASC';
    }
    page = 1;
    Provider.of<Places>(context, listen: false).sPage = page;
    loadedComplexestolist.clear();
    searchItems();
  }

  var sortValue = 'براساس نام';

  final List<String> sortList = [
    'محبوبترین',
    'پربازدیدترین',
    'پرطرفدارترین',
    'براساس نام',
    'کم بازدیدترین',
  ];

  @override
  Widget build(BuildContext context) {
    double deviceHeight = MediaQuery.of(context).size.height;
    double deviceWidth = MediaQuery.of(context).size.width;
    var textScaleFactor = MediaQuery.of(context).textScaleFactor;
    var deviceAspectRatio = MediaQuery.of(context).size.aspectRatio;
    var currencyFormat = intl.NumberFormat.decimalPattern();
    final List<Tab> myTabs = <Tab>[
      Tab(
        text: 'همه',
      ),
      Tab(
        text: 'ورزشی',
      ),
      Tab(
        text: 'باشگاه ها',
      ),
      Tab(
        text: 'تفریحی',
      ),
    ];

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
              builder: (_, notification, ch) => badges.Badge(
                // color: notification.notificationItems.length == 0
                //     ? Colors.grey
                //     : Colors.green,
                badgeContent: Text( notification.notificationItems.length.toString()),
                // value: notification.notificationItems.length.toString(),
                child: ch,
              ),
              child: IconButton(
                onPressed: () {
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
        body: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.symmetric(
                vertical: deviceHeight * 0.0, horizontal: deviceWidth * 0.03),
            child: Stack(
              children: <Widget>[
                Column(
                  children: <Widget>[
                    Padding(
                      padding:
                          EdgeInsets.symmetric(vertical: deviceHeight * 0.02),
                      child: Container(
                        height: deviceHeight * 0.055,
                        decoration: new BoxDecoration(
                            border: Border.all(color: Colors.blue, width: 0.5),
                            borderRadius:
                                new BorderRadius.all(Radius.circular(10))),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: <Widget>[
                            Container(
                              height: deviceWidth * 0.13,
                              width: deviceWidth * 0.13,
                              child: TextButton(
                                child: Icon(
                                  Icons.search,
                                  color: Colors.blue,
                                ),
                                onPressed: () {
                                  Provider.of<Places>(context, listen: false)
                                      .searchKey = searchTextController.text;
                                  page = 1;
                                  Provider.of<Places>(context, listen: false)
                                      .sPage = page;
                                  loadedComplexestolist.clear();

                                  searchItems();
                                },
                              ),
                            ),
                            Expanded(
                              child: Padding(
                                padding: const EdgeInsets.only(bottom: 5),
                                child: TextFormField(
                                  controller: searchTextController,
                                  textInputAction: TextInputAction.search,
                                  onFieldSubmitted: (_) {
                                    Provider.of<Places>(context, listen: false)
                                        .searchKey = searchTextController.text;
                                    page = 1;
                                    Provider.of<Places>(context, listen: false)
                                        .sPage = page;
                                    loadedComplexestolist.clear();

                                    searchItems();
                                  },
                                  onChanged: (_) {
                                    Provider.of<Places>(context, listen: false)
                                        .searchKey = searchTextController.text;
                                    page = 1;
                                    Provider.of<Places>(context, listen: false)
                                        .sPage = page;
                                    loadedComplexestolist.clear();

                                    searchItems();
                                  },
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
                            ),
                          ],
                        ),
                      ),
                    ),
                    Column(
                      children: <Widget>[
                        ClipRRect(
                          borderRadius: BorderRadius.circular(10),
                          child: Container(
                            height: deviceHeight * 0.055,
                            decoration: BoxDecoration(
                                border: Border.all(color: Colors.red),
                                borderRadius: BorderRadius.circular(10)),
                            child: TabBar(
                                onTap: (i) {
                                  if (i == 0) {
                                    Provider.of<Places>(context, listen: false)
                                        .sPlaceType = '';
                                  } else if (i == 1) {
                                    Provider.of<Places>(context, listen: false)
                                        .sPlaceType = '1';
                                  } else if (i == 2) {
                                    Provider.of<Places>(context, listen: false)
                                        .sPlaceType = '2';
                                  } else if (i == 3) {
                                    Provider.of<Places>(context, listen: false)
                                        .sPlaceType = '3';
                                  }
                                  page = 1;
                                  Provider.of<Places>(context, listen: false)
                                      .sPage = page;
                                  loadedComplexestolist.clear();

                                  searchItems();
                                },
                                indicator: BoxDecoration(
                                  color: Colors.red,
                                ),
                                indicatorColor: Colors.red,
                                indicatorWeight: 0,
                                unselectedLabelColor: Colors.red,
                                labelColor: Colors.white,
                                labelPadding: EdgeInsets.only(top: 2, left: 4),
                                labelStyle: TextStyle(
                                  fontFamily: 'Iransans',
                                  fontSize: textScaleFactor * 13.0,
                                ),
                                unselectedLabelStyle: TextStyle(
                                  fontFamily: 'Iransans',
                                  fontSize: textScaleFactor * 13.0,
                                ),
                                controller: _tabController,
                                tabs: myTabs),
                          ),
                        ),
                        Consumer<Places>(builder: (_, products, ch) {
                          return Container(
                            width: double.infinity,
                            child: Wrap(
                                alignment: WrapAlignment.start,
                                crossAxisAlignment: WrapCrossAlignment.center,
                                direction: Axis.horizontal,
                                children: <Widget>[
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 3, vertical: 5),
                                    child: Text(
                                      'تعداد:',
                                      style: TextStyle(
                                        fontFamily: 'Iransans',
                                        fontSize: textScaleFactor * 12.0,
                                      ),
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(
                                        right: 4.0, left: 6),
                                    child: Text(
                                      searchDetails != null
                                          ? EnArConvertor().replaceArNumber(
                                              searchDetails.total.toString())
                                          : EnArConvertor()
                                              .replaceArNumber('0'),
                                      style: TextStyle(
                                        fontFamily: 'Iransans',
                                        fontSize: textScaleFactor * 13.0,
                                      ),
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 3, vertical: 5),
                                    child: Text(
                                      filterList.length == 0 ? '' : 'فیلتر',
                                      style: TextStyle(
                                        fontFamily: 'Iransans',
                                        fontSize: textScaleFactor * 12.0,
                                      ),
                                    ),
                                  ),
                                  Container(
                                    width: deviceWidth * 0.65,
                                    height: deviceHeight * 0.06,
                                    child: filterList.length == 0
                                        ? Padding(
                                            padding: const EdgeInsets.symmetric(
                                                horizontal: 3, vertical: 5),
                                            child: Container(
                                              child: Text(
                                                '',
                                                style: TextStyle(
                                                  fontFamily: 'Iransans',
                                                  fontSize:
                                                      textScaleFactor * 12.0,
                                                ),
                                              ),
                                              alignment: Alignment.centerRight,
                                            ),
                                          )
                                        : ListView.builder(
                                            scrollDirection: Axis.horizontal,
                                            itemCount: filterList.length,
                                            itemBuilder: (ctx, i) => Padding(
                                              padding:
                                                  const EdgeInsets.all(2.0),
                                              child: Chip(
                                                label: Text(
                                                  filterList[i],
                                                  style: TextStyle(
                                                    fontFamily: 'Iransans',
                                                    fontSize:
                                                        textScaleFactor * 12.0,
                                                  ),
                                                ),
                                                padding: EdgeInsets.all(0),
                                                backgroundColor: Colors.black12,
                                              ),
                                            ),
                                          ),
                                  ),
                                ]),
                          );
                        }),
                        Padding(
                          padding: const EdgeInsets.only(bottom: 8.0),
                          child: Container(
                            height: deviceHeight * 0.04,
                            child: Row(
                              children: <Widget>[
                                Expanded(
                                  child: Directionality(
                                    textDirection: TextDirection.rtl,
                                    child: Container(
                                      decoration: BoxDecoration(
//                                          color: Colors.grey.withOpacity(0.2),
                                          border: Border.all(
                                              color: Colors.grey, width: 0.5),
                                          borderRadius: BorderRadius.only(
                                              topRight: Radius.circular(5),
                                              bottomRight: Radius.circular(5))),
                                      child: Center(
                                        child: DropdownButton<String>(
                                          value: sortValue,
                                          icon: Icon(
                                            Icons.arrow_drop_down,
                                            color: Colors.orange,
                                          ),
                                          style: TextStyle(
                                            color: Colors.black,
                                            fontFamily: 'Iransans',
                                            fontSize: textScaleFactor * 13.0,
                                          ),
                                          onChanged: (String? newValue) {
                                            setState(() {
                                              sortValue = newValue!;
                                            });
                                            setSort(newValue!);
                                          },
                                          items: sortList
                                              .map<DropdownMenuItem<String>>(
                                                  (String value) {
                                            return DropdownMenuItem<String>(
                                              value: value,
                                              child: Text(
                                                value,
                                                style: TextStyle(
                                                  color: Colors.black,
                                                  fontFamily: 'Iransans',
                                                  fontSize:
                                                      textScaleFactor * 13.0,
                                                ),
                                              ),
                                            );
                                          }).toList(),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                                Expanded(
                                  child: Builder(
                                    builder: (context) {
                                      return InkWell(
                                        onTap: () {
                                          Scaffold.of(context).openEndDrawer();
                                        },
                                        child: Container(
                                          decoration: BoxDecoration(
//                                              color:
//                                                  Colors.grey.withOpacity(0.2),
                                            borderRadius: BorderRadius.only(
                                                topLeft: Radius.circular(5),
                                                bottomLeft: Radius.circular(5)),

                                            border: Border.all(
                                                color: Colors.grey, width: 0.5),
                                          ),
                                          child: Center(
                                            child: Wrap(
                                              children: <Widget>[
                                                Padding(
                                                  padding: const EdgeInsets
                                                          .symmetric(
                                                      horizontal: 8.0),
                                                  child: Icon(
                                                    Icons.filter_list,
                                                    color: Colors.orange,
                                                  ),
                                                ),
                                                Padding(
                                                  padding:
                                                      const EdgeInsets.only(
                                                          top: 5.0, left: 10),
                                                  child: Text(
                                                    'فیلتر',
                                                    style: TextStyle(
                                                      color: Colors.black,
                                                      fontFamily: 'Iransans',
                                                      fontSize:
                                                          textScaleFactor *
                                                              13.0,
                                                    ),
                                                    textAlign: TextAlign.center,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      );
                                    },
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
//                        Container(
//                          width: double.infinity,
//                          height: deviceHeight * 0.6,
//                          child: ListView.builder(
//                            controller: _scrollController,
//                            scrollDirection: Axis.vertical,
//                            itemCount: loadedComplexestolist.length,
//                            itemBuilder: (ctx, i) =>
//                                ChangeNotifierProvider.value(
//                              value: loadedComplexestolist[i],
//                              child: Container(
//                                height: deviceHeight * 0.3,
//                                child: ComplexItem(
//                                  loadedComplex: loadedComplexestolist[i],
//                                ),
//                              ),
//                            ),
//                          ),
//                        ),
                      ],
                    )
                  ],
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
        drawer: Theme(
          data: Theme.of(context).copyWith(
            canvasColor: Colors.white,
          ),
          child: MainDrawer(),
        ),
        endDrawer: FilterDrawer(searchItems),
      ),
    );
  }
}
