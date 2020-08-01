import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:intl/intl.dart' as intl;
import 'package:provider/provider.dart';
import 'package:tapsalon/models/city.dart';
import 'package:tapsalon/models/places_models/place_in_search.dart';
import 'package:tapsalon/models/search_argument.dart';
import 'package:tapsalon/widget/items/place_item.dart';

import '../models/searchDetails.dart';
import '../provider/app_theme.dart';
import '../provider/cities.dart';
import '../provider/places.dart';
import '../widget/dialogs/select_city_dialog.dart';
import '../widget/en_to_ar_number_convertor.dart';
import '../widget/filter_drawer.dart';
import '../widget/main_drawer.dart';

class SearchScreen extends StatefulWidget {
  static const routeName = '/searchScreen';

  @override
  _SearchScreenState createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen>
    with TickerProviderStateMixin {
  bool _isInit = true;
  var _isLoading = false;
  int page = 1;
  List<String> filterList = [];
  City selectedCity;

  SearchDetails searchDetails;
  final searchTextController = TextEditingController();
  TabController _tabController;

  ScrollController _scrollController = new ScrollController();

  @override
  void initState() {
    _tabController = TabController(vsync: this, length: 5);
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
  void didChangeDependencies() async {
    if (_isInit) {
      var searchArgument =
          ModalRoute.of(context).settings.arguments as SearchArgument;
      int tabIndex = searchArgument.tabIndex;
      cleanFilter();

      sortValue = searchArgument.sortValue;
      await setSort(sortValue);
      _tabController.index = tabIndex;
      await changeTab(tabIndex);

      setState(() {
        _isLoading = true;
      });
      selectedCity = Provider.of<Cities>(context, listen: false).selectedCity;
      if (selectedCity == null) {
        await Provider.of<Cities>(context, listen: false).getSelectedCity();
      }
      selectedCity = Provider.of<Cities>(context, listen: false).selectedCity;
      print('selectedCity.id' + selectedCity.id.toString());
      Provider.of<Places>(context, listen: false).sCityId =
          selectedCity.id.toString();

      Provider.of<Places>(context, listen: false).sPage = page;

      searchTextController.text =
          Provider.of<Places>(context, listen: false).searchKey;

      await searchItems();
      setState(() {
        _isLoading = false;
      });
    }
    _isInit = false;
    super.didChangeDependencies();
  }

  Future<void> cleanFilter() async {
    setState(() {
      _isLoading = true;
    });

    Provider.of<Places>(context, listen: false).filterTitle.clear();
    Provider.of<Places>(context, listen: false).sFacility = '';
    Provider.of<Places>(context, listen: false).sField = '';
    Provider.of<Places>(context, listen: false).sRange = '';
    Provider.of<Places>(context, listen: false).sPage = 1;
    Provider.of<Places>(context, listen: false).sPerPage = 10;
    Provider.of<Places>(context, listen: false).sRegion = '';
    Provider.of<Places>(context, listen: false).sPlaceType = '';

    Provider.of<Places>(context, listen: false).searchBuilder();

    setState(() {
      _isLoading = false;
    });
  }

  List<PlaceInSearch> loadedPlaces = [];
  List<PlaceInSearch> loadedPlacesToList = [];

  void filterItems() async {
    loadedPlacesToList.clear();
    await searchItems();
  }

  Future<void> searchItems() async {
    setState(() {
      _isLoading = true;
    });

    Provider.of<Places>(context, listen: false).searchBuilder();
    await Provider.of<Places>(context, listen: false).searchItem();
    loadedPlaces.clear();
    loadedPlaces = Provider.of<Places>(context, listen: false).items;

    loadedPlacesToList.addAll(loadedPlaces);

    filterList = Provider.of<Places>(context, listen: false).filterTitle;
    searchDetails =
        Provider.of<Places>(context, listen: false).placeSearchDetails;

    setState(() {
      _isLoading = false;
    });
  }

  Future<void> setSort(String sortValue) async {
    if (sortValue == 'محبوبترین') {
      Provider.of<Places>(context, listen: false).sOrderBy = 'rate';
      Provider.of<Places>(context, listen: false).sSort = 'DESC';
    } else if (sortValue == 'پربازدیدترین') {
      Provider.of<Places>(context, listen: false).sOrderBy = 'visit';
      Provider.of<Places>(context, listen: false).sSort = 'DESC';
    } else if (sortValue == 'پرطرفدارترین') {
      Provider.of<Places>(context, listen: false).sOrderBy = 'likes_count';
      Provider.of<Places>(context, listen: false).sSort = 'DESC';
    } else if (sortValue == 'کم بازدیدترین') {
      Provider.of<Places>(context, listen: false).sOrderBy = 'visit';
      Provider.of<Places>(context, listen: false).sSort = 'ASC';
    } else if (sortValue == 'جدیدترین') {
      Provider.of<Places>(context, listen: false).sOrderBy = '';
      Provider.of<Places>(context, listen: false).sSort = '';
    } else {
      Provider.of<Places>(context, listen: false).sOrderBy = 'name';
      Provider.of<Places>(context, listen: false).sSort = 'ASC';
    }
  }

  Future<void> setSortSearch(String sortValue) async {
    await setSort(sortValue);
    page = 1;
    Provider.of<Places>(context, listen: false).sPage = page;
    loadedPlacesToList.clear();
    searchItems();
  }

  Future<void> changeTab(int tabIndex) async {
    if (tabIndex == 0) {
      cleanFilter();
      Provider.of<Places>(context, listen: false).sPlaceType = '';
    } else if (tabIndex == 1) {
      Provider.of<Places>(context, listen: false).sPlaceType = '1';
    } else if (tabIndex == 2) {
      Provider.of<Places>(context, listen: false).sPlaceType = '2';
    } else if (tabIndex == 3) {
      Provider.of<Places>(context, listen: false).sPlaceType = '3';
    } else if (tabIndex == 4) {
      Provider.of<Places>(context, listen: false).sPlaceType = '4';
    }
  }

  Future<void> changeTabSearch(int tabIndex) async {
    await changeTab(tabIndex);
    page = 1;
    Provider.of<Places>(context, listen: false).sPage = page;
    loadedPlacesToList.clear();

    searchItems();
  }

  var sortValue = 'براساس نام';

  final List<String> sortList = [
    'محبوبترین',
    'جدیدترین',
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
    var currencyFormat = intl.NumberFormat.decimalPattern();
    final List<Tab> myTabs = <Tab>[
      Tab(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(
            'همه',
            style: TextStyle(
                fontFamily: 'Iransans', fontSize: textScaleFactor * 16.0),
          ),
        ),
      ),
      Tab(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(
            'سالن',
            style: TextStyle(
                fontFamily: 'Iransans', fontSize: textScaleFactor * 16.0),
          ),
        ),
      ),
      Tab(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(
            'باشگاه ها',
            style: TextStyle(
                fontFamily: 'Iransans', fontSize: textScaleFactor * 16.0),
          ),
        ),
      ),
      Tab(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(
            'مجموعه ورزشی',
            style: TextStyle(
                fontFamily: 'Iransans', fontSize: textScaleFactor * 16.0),
          ),
        ),
      ),
      Tab(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(
            'مجموعه تفریحی',
            style: TextStyle(
                fontFamily: 'Iransans', fontSize: textScaleFactor * 16.0),
          ),
        ),
      ),
    ];

    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
//        backgroundColor: Color(0xffF9F9F9),
        appBar: AppBar(
          elevation: 0,
          backgroundColor: AppTheme.appBarColor,
          iconTheme: new IconThemeData(color: AppTheme.appBarIconColor),
          actions: <Widget>[
            Consumer<Cities>(
              builder: (_, cities, ch) => Padding(
                padding: const EdgeInsets.only(left: 20.0),
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
                          softWrap: true,
                          style: TextStyle(
                              color: AppTheme.black,
                              fontFamily: 'Iransans',
                              fontSize: textScaleFactor * 12.0),
                        ),
                        Icon(
                          Icons.arrow_drop_down,
                          size: 25,
                        )
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
        body: GestureDetector(
          onTap: () {
            FocusScope.of(context).requestFocus(new FocusNode());
          },
          child: Builder(
            builder: (context) => SingleChildScrollView(
              child: Padding(
                padding: EdgeInsets.symmetric(
                    vertical: deviceWidth * 0.04,
                    horizontal: deviceWidth * 0.04),
                child: Stack(
                  children: <Widget>[
                    Column(
                      children: <Widget>[
                        Container(
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
                              borderRadius:
                                  new BorderRadius.all(Radius.circular(50))),
                          child: Padding(
                            padding: const EdgeInsets.only(left: 8, right: 16),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: <Widget>[
                                Expanded(
                                  child: TextFormField(
                                    controller: searchTextController,
                                    textInputAction: TextInputAction.search,
                                    onFieldSubmitted: (_) {
                                      Provider.of<Places>(context,
                                                  listen: false)
                                              .searchKey =
                                          searchTextController.text;
                                      page = 1;
                                      Provider.of<Places>(context,
                                              listen: false)
                                          .sPage = page;
                                      loadedPlacesToList.clear();

                                      searchItems();
                                    },
                                    onChanged: (_) {
                                      Provider.of<Places>(context,
                                                  listen: false)
                                              .searchKey =
                                          searchTextController.text;
                                      page = 1;
                                      Provider.of<Places>(context,
                                              listen: false)
                                          .sPage = page;
                                      loadedPlacesToList.clear();

                                      searchItems();
                                    },
                                    style: TextStyle(
                                      color: AppTheme.black,
                                      fontFamily: 'Iransans',
                                    ),
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
                                    Provider.of<Places>(context, listen: false)
                                        .searchKey = searchTextController.text;
                                    page = 1;
                                    Provider.of<Places>(context, listen: false)
                                        .sPage = page;
                                    loadedPlacesToList.clear();

                                    searchItems();
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
                        Column(
                          children: <Widget>[
                            Padding(
                              padding: const EdgeInsets.only(top: 16.0),
                              child: Container(
                                width: deviceWidth,
//                                height: deviceHeight * 0.055,
                                child: Row(
                                  children: <Widget>[
                                    InkWell(
                                        onTap: () {
                                          Scaffold.of(context).openEndDrawer();
                                        },
                                        child: Container(
                                          decoration: BoxDecoration(
                                            color: AppTheme.white,
                                            border: Border.all(
                                                color: AppTheme.white
                                                    .withOpacity(0.5),
                                                width: 0.5),
                                            borderRadius:
                                                BorderRadius.circular(5),
                                          ),
                                          child: Padding(
                                            padding: const EdgeInsets.all(4.0),
                                            child: Icon(
                                              Icons.filter_list,
                                              color: AppTheme.grey,
                                              size: 30,
                                            ),
                                          ),
                                        )),
                                    Expanded(
                                      child: TabBar(
                                          onTap: (i) {
                                            changeTabSearch(i);
                                          },
                                          indicator: BoxDecoration(
                                            color: AppTheme.white,
                                          ),
                                          isScrollable: true,
                                          indicatorWeight: 0,
                                          unselectedLabelColor: AppTheme.grey,
                                          labelColor: AppTheme.black,
                                          labelPadding:
                                              EdgeInsets.only(top: 2, left: 4),
                                          labelStyle: TextStyle(
                                            fontFamily: 'Iransans',
                                            fontWeight: FontWeight.w500,
                                            fontSize: textScaleFactor * 15.0,
                                          ),
                                          unselectedLabelStyle: TextStyle(
                                            fontFamily: 'Iransans',
                                            fontSize: textScaleFactor * 14.0,
                                            fontWeight: FontWeight.w500,
                                          ),
                                          controller: _tabController,
                                          tabs: myTabs),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            Padding(
                              padding:
                                  const EdgeInsets.only(bottom: 8.0, top: 8),
                              child: Container(
                                height: deviceHeight * 0.04,
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: <Widget>[
                                    Directionality(
                                      textDirection: TextDirection.ltr,
                                      child: DropdownButton<String>(
                                        value: sortValue,
                                        icon: Padding(
                                          padding:
                                              const EdgeInsets.only(bottom: 6),
                                          child: Icon(
                                            Icons.arrow_drop_down,
                                            color: AppTheme.black,
                                          ),
                                        ),
                                        style: TextStyle(
                                          color: Colors.black,
                                          fontFamily: 'Iransans',
                                          fontSize: textScaleFactor * 13.0,
                                        ),
                                        onChanged: (String newValue) {
                                          setState(() {
                                            sortValue = newValue;
                                          });
                                          setSortSearch(newValue);
                                        },
                                        underline: Container(
                                          color: Colors.white,
                                        ),
                                        items: sortList
                                            .map<DropdownMenuItem<String>>(
                                                (String value) {
                                          return DropdownMenuItem<String>(
                                            value: value,
                                            child: Container(
                                              width: deviceWidth * 0.25,
                                              child: Text(
                                                value,
                                                textAlign: TextAlign.end,
                                                style: TextStyle(
                                                  color: Colors.black,
                                                  fontFamily: 'Iransans',
                                                  fontSize:
                                                      textScaleFactor * 13.0,
                                                ),
                                              ),
                                            ),
                                          );
                                        }).toList(),
                                      ),
                                    ),
                                    Spacer(),
                                    Consumer<Places>(
                                        builder: (_, products, ch) {
                                      return Container(
                                        child: Wrap(
                                            alignment: WrapAlignment.start,
                                            crossAxisAlignment:
                                                WrapCrossAlignment.center,
                                            direction: Axis.horizontal,
                                            children: <Widget>[
                                              Padding(
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                        horizontal: 3,
                                                        vertical: 5),
                                                child: Text(
                                                  'تعداد:',
                                                  style: TextStyle(
                                                    fontFamily: 'Iransans',
                                                    fontSize:
                                                        textScaleFactor * 12.0,
                                                  ),
                                                ),
                                              ),
                                              Padding(
                                                padding: const EdgeInsets.only(
                                                    right: 4.0, left: 6),
                                                child: Text(
                                                  searchDetails != null
                                                      ? EnArConvertor()
                                                          .replaceArNumber(
                                                              searchDetails
                                                                  .total
                                                                  .toString())
                                                      : EnArConvertor()
                                                          .replaceArNumber('0'),
                                                  style: TextStyle(
                                                    fontFamily: 'Iransans',
                                                    fontSize:
                                                        textScaleFactor * 13.0,
                                                  ),
                                                ),
                                              ),
//                                            Padding(
//                                              padding:
//                                                  const EdgeInsets.symmetric(
//                                                      horizontal: 3,
//                                                      vertical: 5),
//                                              child: Text(
//                                                filterList.length == 0
//                                                    ? ''
//                                                    : 'فیلتر',
//                                                style: TextStyle(
//                                                  fontFamily: 'Iransans',
//                                                  fontSize:
//                                                      textScaleFactor * 12.0,
//                                                ),
//                                              ),
//                                            ),
//                                            Container(
//                                              width: deviceWidth * 0.65,
//                                              height: deviceHeight * 0.06,
//                                              child: filterList.length == 0
//                                                  ? Padding(
//                                                      padding:
//                                                          const EdgeInsets
//                                                                  .symmetric(
//                                                              horizontal: 3,
//                                                              vertical: 5),
//                                                      child: Container(
//                                                        child: Text(
//                                                          '',
//                                                          style: TextStyle(
//                                                            fontFamily:
//                                                                'Iransans',
//                                                            fontSize:
//                                                                textScaleFactor *
//                                                                    12.0,
//                                                          ),
//                                                        ),
//                                                        alignment: Alignment
//                                                            .centerRight,
//                                                      ),
//                                                    )
//                                                  : ListView.builder(
//                                                      scrollDirection:
//                                                          Axis.horizontal,
//                                                      itemCount:
//                                                          filterList.length,
//                                                      itemBuilder: (ctx, i) =>
//                                                          Padding(
//                                                        padding:
//                                                            const EdgeInsets
//                                                                .all(2.0),
//                                                        child: Chip(
//                                                          label: Text(
//                                                            filterList[i],
//                                                            style: TextStyle(
//                                                              fontFamily:
//                                                                  'Iransans',
//                                                              fontSize:
//                                                                  textScaleFactor *
//                                                                      12.0,
//                                                            ),
//                                                          ),
//                                                          padding:
//                                                              EdgeInsets.all(
//                                                                  0),
//                                                          backgroundColor:
//                                                              Colors.black12,
//                                                        ),
//                                                      ),
//                                                    ),
//                                            ),
                                            ]),
                                      );
                                    }),
                                  ],
                                ),
                              ),
                            ),
                            Container(
                              width: double.infinity,
                              height: deviceHeight * 0.67,
                              child: ListView.builder(
                                controller: _scrollController,
                                scrollDirection: Axis.vertical,
                                itemCount: loadedPlacesToList.length,
                                itemBuilder: (ctx, i) =>
                                    ChangeNotifierProvider.value(
                                  value: loadedPlacesToList[i],
                                  child: Container(
                                    height: 280,
                                    child: PlaceItem(
                                      place: loadedPlacesToList[i],
                                    ),
                                  ),
                                ),
                              ),
                            ),
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
                                child: loadedPlacesToList.isEmpty
                                    ? Center(
                                        child: Text(
                                          'موردی وجود ندارد',
                                          style: TextStyle(
                                            fontFamily: 'Iransans',
                                            fontSize: textScaleFactor * 15.0,
                                          ),
                                        ),
                                      )
                                    : Container(),
                              ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
        drawer: Theme(
          data: Theme.of(context).copyWith(
            // Set the transparency here
            canvasColor: Colors
                .white, //or any other color you want. e.g Colors.blue.withOpacity(0.5)
          ),
          child: MainDrawer(),
        ),
        endDrawer: FilterDrawer(filterItems),
      ),
    );
  }
}
