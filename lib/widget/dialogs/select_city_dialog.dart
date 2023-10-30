import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:provider/provider.dart';
import 'package:tapsalon/screen/navigation_bottom_screen.dart';

import '../../models/city.dart';
import '../../models/province.dart';
import '../../provider/cities.dart';

class SelectCityDialog extends StatefulWidget {
  @override
  _SelectCityDialogState createState() => _SelectCityDialogState();
}

class _SelectCityDialogState extends State<SelectCityDialog> {
  bool _isInit = true;
  var _isLoading;

  List<String> provinceValueList = [];
  var provinceValue;
  List<Province> provinceList = [];
  late int provinceId;

  var citiesValue;
  List<String> citiesValueList = [];
  List<City> citiesList = [];
  late int cityId;

  late City selectedCity;

  @override
  void didChangeDependencies() async {
    if (_isInit) {
      loadProvince();
      setState(() {});
      _isInit = false;
    }
    super.didChangeDependencies();
  }

  Future<void> loadProvince() async {
    setState(() {
      _isLoading = true;
    });
    await Provider.of<Cities>(context, listen: false).retrieveProvince();
    provinceList = Provider.of<Cities>(context, listen: false).provincesItems;

    for (int i = 0; i < provinceList.length; i++) {
      print(i.toString());
      provinceValueList.add(provinceList[i].name);
    }

    setState(() {
      _isLoading = false;
      print(_isLoading.toString());
    });
    print(_isLoading.toString());
  }

  Future<void> loadCities() async {
    setState(() {
      _isLoading = true;
    });
    try {
      await Provider.of<Cities>(context, listen: false)
          .retrieveOstanCities(provinceId);

      citiesList = Provider.of<Cities>(context, listen: false).citiesItems;
      citiesValueList.clear();
      for (int i = 0; i < provinceList.length; i++) {
        print(i.toString());
        citiesValueList.add(citiesList[i].name);
      }
    } catch (error) {
      setState(() {
        _isLoading = false;
        print(_isLoading.toString());
      });
    }
    setState(() {
      _isLoading = false;
      print(_isLoading.toString());
    });
    print(_isLoading.toString());
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(Consts.padding),
      ),
      elevation: 0.0,
      backgroundColor: Colors.transparent,
      child: dialogContent(context),
    );
  }

  dialogContent(BuildContext context) {
    double deviceWidth = MediaQuery.of(context).size.width;
    double deviceHeight = MediaQuery.of(context).size.height;
    var textScaleFactor = MediaQuery.of(context).textScaleFactor;
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Stack(
        children: <Widget>[
          LayoutBuilder(
            builder: (ctx, constraint) {
              return Container(
                padding: EdgeInsets.only(
                  top: Consts.avatarRadius + Consts.padding,
                  bottom: Consts.padding,
                  left: Consts.padding,
                  right: Consts.padding,
                ),
                margin: EdgeInsets.only(top: Consts.avatarRadius),
                decoration: new BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.rectangle,
                  borderRadius: BorderRadius.circular(5),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black26,
                      blurRadius: 10.0,
                      offset: const Offset(0.0, 10.0),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min, // To make the card compact
                  children: <Widget>[
                    Text(
                      'لطفا استان و شهر مورد نظر را انتخاب کنید',
                      style: TextStyle(
                        color: Colors.black,
                        fontFamily: 'Iransans',
                        fontSize: textScaleFactor * 13.0,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 8.0, bottom: 12),
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(5),
                        ),
                        child: Wrap(
                          crossAxisAlignment: WrapCrossAlignment.start,
                          children: <Widget>[
                            Text(
                              'استان : ',
                              style: TextStyle(
                                color: Colors.grey,
                                fontFamily: 'Iransans',
                                fontSize: textScaleFactor * 13.0,
                              ),
                            ),
                            Container(
                              width: deviceWidth,
                              decoration: BoxDecoration(
                                color: Colors.white,
                                border:
                                    Border.all(color: Colors.grey, width: 0.5),
                                borderRadius: BorderRadius.circular(5),
                              ),
                              child: Directionality(
                                textDirection: TextDirection.ltr,
                                child: Container(
                                  alignment: Alignment.centerRight,
                                  decoration: BoxDecoration(
                                      color: Colors.white,
                                      border: Border.all(
                                          color: Colors.grey, width: 0.3)),
                                  child: DropdownButton<String>(
                                    hint: Text(
                                      _isLoading
                                          ? 'لطفا صبر نمایید'
                                          : 'استان مورد نظر را انتخاب نمایید',
                                      style: TextStyle(
                                        color: Colors.grey,
                                        fontFamily: 'Iransans',
                                        fontSize: textScaleFactor * 11.0,
                                      ),
                                    ),
                                    value: provinceValue,
                                    icon: Padding(
                                      padding: const EdgeInsets.only(bottom: 6),
                                      child: Icon(
                                        Icons.arrow_drop_down,
                                        color: Colors.black,
                                      ),
                                    ),
                                    style: TextStyle(
                                      color: Colors.black,
                                      fontFamily: 'Iransans',
                                      fontSize: textScaleFactor * 13.0,
                                    ),
                                    onChanged: (newValue) {
                                      setState(() {
                                        provinceValue = newValue;
                                        provinceId = provinceList[
                                                provinceValueList
                                                    .lastIndexOf(newValue!)]
                                            .id;
                                      });
                                      loadCities();
                                    },
                                    elevation: 0,
                                    underline: Container(
                                      color: Colors.white,
                                    ),
                                    items: provinceValueList
                                        .map<DropdownMenuItem<String>>(
                                            (String value) {
                                      return DropdownMenuItem<String>(
                                        value: value,
                                        child: Container(
                                          width: constraint.maxWidth * 0.5,
                                          child: Text(
                                            value,
                                            textAlign: TextAlign.start,
                                            style: TextStyle(
                                              color: Colors.black,
                                              fontFamily: 'Iransans',
                                              fontSize: textScaleFactor * 13.0,
                                            ),
                                            textDirection: TextDirection.rtl,
                                          ),
                                        ),
                                      );
                                    }).toList(),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    Text(
                      'شهر : ',
                      style: TextStyle(
                        color: Colors.grey,
                        fontFamily: 'Iransans',
                        fontSize: textScaleFactor * 13.0,
                      ),
                    ),
                    Divider(
                      thickness: 0.3,
                      height: 1,
                    ),
                    ConstrainedBox(
                      constraints: BoxConstraints(
                        maxHeight: constraint.maxHeight * 0.5,
                        minWidth: constraint.maxHeight * 0.010,
                      ),
                      child: ListView.builder(
                          itemCount: citiesList.length,
                          itemBuilder: (ctx, i) {
                            return Container(
                              color: selectedCity != null
                                  ? selectedCity.id != citiesList[i].id
                                      ? Colors.white
                                      : Colors.grey.withOpacity(0.2)
                                  : Colors.white,
                              child: ListTile(
                                title: Text(
                                  citiesList[i].name,
                                  style: TextStyle(
                                    fontFamily: "Iransans",
                                    fontWeight: FontWeight.w400,
                                    fontSize: textScaleFactor * 15,
                                    color: Colors.black,
                                  ),
                                  textAlign: TextAlign.right,
                                ),
                                onTap: () {
                                  selectedCity = citiesList[i];
                                  setState(() {});
                                },
                              ),
                            );
                          }),
                    ),
                    SizedBox(height: 24.0),
                    Align(
                      alignment: Alignment.bottomCenter,
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(15),
                        child: InkWell(
                          onTap: () async {
                            Provider.of<Cities>(context, listen: false)
                                .setSelectedCity(selectedCity);

                              await Navigator.of(context).popAndPushNamed(
                                  NavigationBottomScreen.routeName);

                          },
                          child: Container(
                            height: constraint.maxHeight * 0.06,
                            width: constraint.maxWidth * 0.4,
                            decoration: BoxDecoration(
                              color: selectedCity == null
                                  ? Colors.grey
                                  : Color(0xffFF6D6B),
                              borderRadius: BorderRadius.circular(25),
                            ),
                            child: Center(
                              child: Text(
                                'تایید',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontFamily: 'Iransans',
                                  fontSize: textScaleFactor * 16,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              );
            },
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
                                color: index.isEven ? Colors.grey : Colors.grey,
                              ),
                            );
                          },
                        )
                      : Container()))
        ],
      ),
    );
  }
}

class Consts {
  Consts._();

  static const double padding = 16.0;
  static const double avatarRadius = 10;
}
