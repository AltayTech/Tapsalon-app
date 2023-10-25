import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:intl/intl.dart' as intl;
import 'package:provider/provider.dart';

import '../models/city.dart';
import '../models/facility.dart';
import '../models/field.dart';
import '../models/priceRange.dart';
import '../models/region.dart';
import '../provider/app_theme.dart';
import '../provider/cities.dart';
import '../provider/places.dart';
import 'en_to_ar_number_convertor.dart';

class FilterDrawer extends StatefulWidget {
  final Function callback;

  FilterDrawer(this.callback);

  @override
  _FilterDrawerState createState() => _FilterDrawerState();
}

class _FilterDrawerState extends State<FilterDrawer> {
  bool _isInit = true;
  var _isLoading;

  double startValue = 0;

  double endValue = 30000000;

  var _isPrice = false;
  bool isDiscounted = false;
  bool isReservable = false;

  late City selectedCity;

  List<Region> regionList = [];

  List<Facility> facilitiesList = [];

  List<Field> fieldsList = [];

  PriceRange priceRange =
      PriceRange(min: 0.toString(), max: 30000000.toString());

  Widget buildListTile(String title, IconData icon, Function tapHandler) {
    return ListTile(
      leading: Icon(
        icon,
        size: 26,
      ),
      title: Text(
        title,
        style: TextStyle(
          fontSize: 24,
          fontWeight: FontWeight.bold,
        ),
      ),
      onTap: () => tapHandler,
    );
  }

  double _minPriceValueC = 0;
  double _maxPriceValueC = 30000000;

  List<int> _selectedRegionIndexs = [];
  List<int> _selectedRegionId = [];
  List<String> _selectedRegionTitle = [];

  List<int> _selectedFacilityIndexs = [];
  List<int> _selectedFacilityId = [];
  List<String> _selectedFacilityTitle = [];

  List<int> _selectedFieldIndexs = [];
  List<int> _selectedFieldId = [];
  List<String> _selectedFieldTitle = [];

  String endPointBuilder(List<dynamic> input) {
    String outPutString = '';
    for (int i = 0; i < input.length; i++) {
      i == 0
          ? outPutString = input[i].toString()
          : outPutString = outPutString + ',' + input[i].toString();
    }
    return outPutString;
  }

  @override
  void didChangeDependencies() {
    if (_isInit) {
      selectedCity = Provider.of<Cities>(context, listen: false).selectedCity;

      getFilterItems();
    }
    _isInit = false;
    super.didChangeDependencies();
  }

  Future<void> getFilterItems() async {
    setState(() {
      _isLoading = true;
    });

    Provider.of<Places>(context, listen: false).searchBuilder();
    await Provider.of<Places>(context, listen: false)
        .retrieveRegions(selectedCity.id);
    regionList = Provider.of<Places>(context, listen: false).itemsRegions;

    await Provider.of<Places>(context, listen: false).retrieveFacilities();
    facilitiesList =
        Provider.of<Places>(context, listen: false).itemsFacilities;
    await Provider.of<Places>(context, listen: false).retrieveFields();
    fieldsList = Provider.of<Places>(context, listen: false).itemsFields;
    await Provider.of<Places>(context, listen: false).retrievePriceRange();
    priceRange = Provider.of<Places>(context, listen: false).itemPriceRange;
    _minPriceValueC = double.parse(priceRange.min);
    _maxPriceValueC = double.parse(priceRange.max);
    startValue = _minPriceValueC;

    endValue = _maxPriceValueC;

    setState(() {
      _isLoading = false;
      print(_isLoading.toString());
    });
    print(_isLoading.toString());
  }

  Future<void> cleanFilter() async {
    setState(() {
      _isLoading = true;
    });

    Provider.of<Places>(context, listen: false).searchKey = '';
    Provider.of<Places>(context, listen: false).filterTitle.clear();

    Provider.of<Places>(context, listen: false).sFacility = '';
    Provider.of<Places>(context, listen: false).sField = '';
    Provider.of<Places>(context, listen: false).sRange = '';
    Provider.of<Places>(context, listen: false).sPage = 1;
    Provider.of<Places>(context, listen: false).sPerPage = 10;
    Provider.of<Places>(context, listen: false).sRegion = '';
    Provider.of<Places>(context, listen: false).searchBuilder();

    setState(() {
      _isLoading = false;
      print(_isLoading.toString());
    });
    print(_isLoading.toString());
  }

//  void addToFilterList(List<dynamic> input) {
//    for (int i = 0; i < input.length; i++) {
//      Provider.of<Products>(context, listen: false).filterTitle.add(input[i]);
//    }
//  }

  @override
  Widget build(BuildContext context) {
    double deviceHeight = MediaQuery.of(context).size.height;
    double deviceWidth = MediaQuery.of(context).size.width;
    var textScaleFactor = MediaQuery.of(context).textScaleFactor;

    var currencyFormat = intl.NumberFormat.decimalPattern();

    return Drawer(
      child: SingleChildScrollView(
        child: Container(
          color: AppTheme.bg,
          child: Stack(
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.all(14.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    SizedBox(
                      height: 10,
                    ),
                    Padding(
                        padding: const EdgeInsets.only(top: 15.0),
                        child: Text(
                          'منطقه ها: ' +
                              EnArConvertor().replaceArNumber(currencyFormat
                                  .format(regionList.length)
                                  .toString()),
                          style: TextStyle(
                            fontFamily: "Iransans",
                            fontWeight: FontWeight.w400,
                            fontSize: 15,
                            color: Colors.black54,
                          ),
                          textAlign: TextAlign.right,
                        )),
                    Container(
                      height: deviceHeight * 0.07,
                      child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: regionList.length,
                        itemBuilder: (BuildContext context, int index) {
                          return InkWell(
                            onTap: () {
                              if (_selectedRegionIndexs.contains(index)) {
                                _selectedRegionIndexs.remove(index);
                                _selectedRegionId.remove(regionList[index].id);
                                _selectedRegionTitle
                                    .remove(regionList[index].name);
                              } else {
                                _selectedRegionIndexs.add(index);
                                _selectedRegionId.add(regionList[index].id);
                                _selectedRegionTitle
                                    .add(regionList[index].name);
                              }

                              setState(() {});
                            },
                            child: Padding(
                              padding: const EdgeInsets.only(
                                  left: 16, top: 8, bottom: 8),
                              child: Container(
                                decoration: _selectedRegionIndexs
                                        .contains(index)
                                    ? BoxDecoration(
                                        color: AppTheme.white,
                                        borderRadius: BorderRadius.circular(5),
                                        boxShadow: [
                                          BoxShadow(
                                              color:
                                                  Colors.green.withOpacity(0.4),
                                              spreadRadius: 2,
                                              blurRadius: 10),
                                        ],
                                      )
                                    : BoxDecoration(
                                        color: AppTheme.white,
                                        borderRadius: BorderRadius.circular(5)),
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Center(
                                    child: Text(
                                      regionList[index].name,
                                      style: TextStyle(
                                        color: AppTheme.black,
                                        fontFamily: 'Iransans',
                                        fontSize: textScaleFactor * 12.0,
                                      ),
                                      textAlign: TextAlign.center,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                    Divider(
                      height: 3,
                      color: AppTheme.grey.withOpacity(0.6),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 15.0),
                      child: Text(
                        'امکانات: ' +
                            EnArConvertor().replaceArNumber(currencyFormat
                                .format(facilitiesList.length)
                                .toString()),
                        style: TextStyle(
                          fontFamily: "Iransans",
                          fontWeight: FontWeight.w400,
                          fontSize: 15,
                          color: Colors.black54,
                        ),
                        textAlign: TextAlign.right,
                      ),
                    ),
                    Container(
                      height: deviceHeight * 0.07,
                      child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: facilitiesList.length,
                        itemBuilder: (BuildContext context, int index) {
                          return InkWell(
                            onTap: () {
                              if (_selectedFacilityIndexs.contains(index)) {
                                _selectedFacilityIndexs.remove(index);
                                _selectedFacilityId
                                    .remove(facilitiesList[index].id);
                                _selectedFacilityTitle
                                    .remove(facilitiesList[index].name);
                              } else {
                                _selectedFacilityIndexs.add(index);
                                _selectedFacilityId
                                    .add(facilitiesList[index].id);
                                _selectedFacilityTitle
                                    .add(facilitiesList[index].name);
                              }

                              setState(() {});
                            },
                            child: Padding(
                              padding: const EdgeInsets.only(
                                  left: 16, top: 8, bottom: 8),
                              child: Container(
                                decoration: _selectedFacilityIndexs
                                        .contains(index)
                                    ? BoxDecoration(
                                        color: AppTheme.white,
                                        borderRadius: BorderRadius.circular(5),
                                        boxShadow: [
                                          BoxShadow(
                                              color:
                                                  Colors.green.withOpacity(0.4),
                                              spreadRadius: 2,
                                              blurRadius: 10),
                                        ],
                                      )
                                    : BoxDecoration(
                                        color: AppTheme.white,
                                        borderRadius: BorderRadius.circular(5),
                                      ),
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Center(
                                    child: Text(
                                      facilitiesList[index].name,
                                      style: TextStyle(
                                        color: AppTheme.black,
                                        fontFamily: 'Iransans',
                                        fontSize: textScaleFactor * 14.0,
                                      ),
                                      textAlign: TextAlign.center,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                    Divider(
                      height: 3,
                      color: AppTheme.grey.withOpacity(0.6),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 15.0),
                      child: Text(
                        'رشته ها: ' +
                            EnArConvertor().replaceArNumber(currencyFormat
                                .format(fieldsList.length)
                                .toString()),
                        style: TextStyle(
                          fontFamily: "Iransans",
                          fontWeight: FontWeight.w400,
                          fontSize: 15,
                          color: Colors.black54,
                        ),
                        textAlign: TextAlign.right,
                      ),
                    ),
                    Container(
                      height: deviceHeight * 0.07,
                      child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: fieldsList.length,
                        itemBuilder: (BuildContext context, int index) {
                          return InkWell(
                            onTap: () {
                              if (_selectedFieldIndexs.contains(index)) {
                                _selectedFieldIndexs.remove(index);
                                _selectedFieldId.remove(fieldsList[index].id);
                                _selectedFieldTitle
                                    .remove(fieldsList[index].name);
                              } else {
                                _selectedFieldIndexs.add(index);
                                _selectedFieldId.add(fieldsList[index].id);
                                _selectedFieldTitle.add(fieldsList[index].name);
                              }

                              setState(() {});
                            },
                            child: Padding(
                              padding: const EdgeInsets.only(
                                  left: 16, top: 8, bottom: 8),
                              child: Container(
                                decoration: _selectedFieldIndexs.contains(index)
                                    ? BoxDecoration(
                                        color: AppTheme.white,
                                        borderRadius: BorderRadius.circular(5),
                                        boxShadow: [
                                          BoxShadow(
                                              color:
                                                  Colors.green.withOpacity(0.4),
                                              spreadRadius: 2,
                                              blurRadius: 10),
                                        ],
                                      )
                                    : BoxDecoration(
                                        color: AppTheme.white,
                                        borderRadius: BorderRadius.circular(5),
                                      ),
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Center(
                                    child: Text(
                                      fieldsList[index].name,
                                      style: TextStyle(
                                        color: AppTheme.black,
                                        fontFamily: 'Iransans',
                                        fontSize: textScaleFactor * 14.0,
                                      ),
                                      textAlign: TextAlign.center,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                    Divider(
                      height: 3,
                      color: AppTheme.grey.withOpacity(0.6),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 15.0, right: 15),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Switch(
                            value: isDiscounted,
                            onChanged: (value) {
//                      if (value) {
//                        _selectedSellCaseId.add(72);
//                        _selectedSellcaseTitle.remove('قسطی');
//
//                        _selectedSellcaseTitle.add('قسطی');
//                      } else {
//                        _selectedSellCaseId.remove(72);
//                        _selectedSellcaseTitle.remove('قسطی');
//                      }
                              setState(() {
                                isDiscounted = value;
                              });
                            },
                            activeTrackColor: Colors.lightGreenAccent,
                            activeColor: Colors.green,
                          ),
                          Text(
                            'تخفیف دار',
                            style: TextStyle(
                              fontFamily: "Iransans",
                              fontWeight: FontWeight.w400,
                              fontSize: 15,
                              color: Colors.black54,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 15.0, right: 15),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Switch(
                            value: isReservable,
                            onChanged: (value) {
//                      if (value) {
//                        _selectedSellCaseId.add(73);
//                        _selectedSellcaseTitle.remove('تخفیف دار');
//
//                        _selectedSellcaseTitle.add('تخفیف دار');
//                      } else {
//                        _selectedSellCaseId.remove(73);
//                        _selectedSellcaseTitle.remove('تخفیف دار');
//                      }

                              setState(() {
                                isReservable = value;
                              });
                            },
                            activeTrackColor: Colors.lightGreenAccent,
                            activeColor: Colors.green,
                          ),
                          Text(
                            'قابل رزرو آنلاین',
                            style: TextStyle(
                              fontFamily: "Iransans",
                              fontWeight: FontWeight.w400,
                              fontSize: 15,
                              color: Colors.black54,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Divider(
                      height: 3,
                      color: AppTheme.grey.withOpacity(0.6),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(right: 8.0),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                          Padding(
                            padding: const EdgeInsets.only(top: 3),
                            child: Text(
                              'محدوده قیمت',
                              style: TextStyle(
                                fontFamily: "Iransans",
                                fontWeight: FontWeight.w400,
                                fontSize: 15,
                                color: Colors.black54,
                              ),
                              textAlign: TextAlign.right,
                            ),
                          ),
                          Checkbox(
                            onChanged: (value) {
                              _isPrice ? _isPrice = false : _isPrice = true;
                              setState(() {});
                            },
                            value: _isPrice,
                          ),
                        ],
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: <Widget>[
                        Expanded(
                          child: Column(
                            children: <Widget>[
                              Padding(
                                padding: const EdgeInsets.all(4.0),
                                child: Container(
                                  child: Text(
                                    EnArConvertor().replaceArNumber(
                                        currencyFormat
                                            .format((_minPriceValueC))
                                            .toString()),
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      color:
                                          _isPrice ? Colors.blue : Colors.grey,
                                      fontFamily: 'Iransans',
                                      fontSize: textScaleFactor * 15.0,
                                    ),
                                  ),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(2.0),
                                child: Container(
                                  child: Text(
                                    'تومان',
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      color: Colors.grey,
                                      fontFamily: 'Iransans',
                                      fontSize: textScaleFactor * 12.0,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        Expanded(
                          child: Column(
                            children: <Widget>[
                              Padding(
                                padding: const EdgeInsets.all(4.0),
                                child: Container(
                                  child: Text(
                                    EnArConvertor().replaceArNumber(
                                        currencyFormat
                                            .format((_maxPriceValueC))
                                            .toString()),
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      color:
                                          _isPrice ? Colors.blue : Colors.grey,
                                      fontFamily: 'Iransans',
                                      fontSize: textScaleFactor * 15.0,
                                    ),
                                  ),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(2.0),
                                child: Container(
                                  child: Text(
                                    'تومان',
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      color: Colors.grey,
                                      fontFamily: 'Iransans',
                                      fontSize: textScaleFactor * 12.0,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    RangeSlider(
                      labels: RangeLabels(
                          EnArConvertor().replaceArNumber(
                              currencyFormat.format((startValue)).toString()),
                          EnArConvertor().replaceArNumber(
                              currencyFormat.format((endValue)).toString())),
                      onChanged: (value) {
                        startValue = value.start;
                        endValue = value.end;
                        _minPriceValueC = value.start;
                        _maxPriceValueC = value.end;

                        setState(() {});
                      },
                      divisions: int.parse(((double.parse(priceRange.max) -
                                  double.parse(priceRange.min)) /
                              1000)
                          .toStringAsFixed(0)),
                      values: RangeValues(startValue, endValue),
                      min: double.parse(priceRange.min),
                      max: double.parse(priceRange.max),
                      activeColor: _isPrice ? Colors.blue : Colors.grey,
                      inactiveColor: Colors.grey,
                    ),
                    Divider(
                      height: 3,
                      color: AppTheme.grey.withOpacity(0.6),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 15.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: <Widget>[
                          Expanded(
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: InkWell(
                                onTap: () {
                                  cleanFilter();

                                  var regionEndpoint =
                                      endPointBuilder(_selectedRegionId);
                                  var facilitiesEndpoint =
                                      endPointBuilder(_selectedFacilityId);
                                  var fieldsEndpoint =
                                      endPointBuilder(_selectedFieldId);
                                  Provider.of<Places>(context, listen: false)
                                      .sFacility = facilitiesEndpoint;
                                  Provider.of<Places>(context, listen: false)
                                      .sField = fieldsEndpoint;
                                  _isPrice
                                      ? Provider.of<Places>(context,
                                                  listen: false)
                                              .sRange =
                                          '$_minPriceValueC,$_maxPriceValueC'
                                      : Provider.of<Places>(context,
                                              listen: false)
                                          .sRange = '';

                                  Provider.of<Places>(context, listen: false)
                                      .sRegion = regionEndpoint;
                                  Provider.of<Places>(context, listen: false)
                                      .searchBuilder();

                                  widget.callback();
                                  Navigator.pop(context);
                                },
                                child: Container(
                                  height: deviceHeight * 0.06,
                                  decoration: BoxDecoration(
                                    color: Colors.blue,
                                    borderRadius: BorderRadius.circular(5),
                                  ),
                                  child: Center(
                                    child: Padding(
                                      padding: const EdgeInsets.only(
                                          left: 15.0, right: 15, top: 4),
                                      child: Text(
                                        'اعمال فیلتر',
                                        style: TextStyle(
                                          fontFamily: "Iransans",
                                          fontSize: textScaleFactor * 16,
                                          color: Colors.white,
                                        ),
                                        textAlign: TextAlign.center,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                          Expanded(
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: InkWell(
                                onTap: () {
                                  cleanFilter();
                                  widget.callback();
                                  Navigator.pop(context);
                                },
                                child: Container(
                                  height: deviceHeight * 0.06,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(5),
                                    border: Border.all(
                                        color: Colors.grey, width: 0.5),
                                  ),
                                  child: Center(
                                    child: Padding(
                                      padding: const EdgeInsets.only(
                                          left: 15.0, right: 15, top: 4),
                                      child: Text(
                                        'حذف فیلتر',
                                        style: TextStyle(
                                          fontFamily: "Iransans",
                                          fontSize: textScaleFactor * 16,
                                          color: Colors.blue,
                                        ),
                                        textAlign: TextAlign.center,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
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
                                        ? Colors.grey
                                        : Colors.grey,
                                  ),
                                );
                              },
                            )
                          : Container()))
            ],
          ),
        ),
      ),
    );
  }
}
