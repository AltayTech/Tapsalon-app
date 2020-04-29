import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:shamsi_date/shamsi_date.dart';
import 'package:tapsalon/classes/table_sticky_header.dart';
import 'package:tapsalon/models/app_theme.dart';
import 'package:tapsalon/models/place.dart';
import 'package:tapsalon/models/timing.dart';
import 'package:tapsalon/provider/salons.dart';
import 'package:tapsalon/widget/en_to_ar_number_convertor.dart';

class SalonDetailTimingScreen extends StatefulWidget {
  final Place place;

  SalonDetailTimingScreen({this.place});

  @override
  _SalonDetailTimingScreenState createState() =>
      _SalonDetailTimingScreenState();
}

class _SalonDetailTimingScreenState extends State<SalonDetailTimingScreen> {
  var _isLoadingMonth;
  var _isLoadingTable;
  bool _isInit = true;

  List<Timing> loadedTiming;

  List<double> hours;

  double cellHeight = 50;
  double cellWidth = 60;
  double headerHeight = 50;
  double sideWidth = 60;

  String startDate = '2020-03-02 00:00:00';
  String endDate = '2020-03-08 00:00:00';
  int startYear = 1398;
  int startMonth = 12;
  int startDay = 1;
  List<Map<String, List<Timing>>> dayTiming;

  List<String> monthValueList = [];
  List<Jalali> monthList = [];

  int nowYears;

  int nowMonth;

  String monthValue;

  String yearValue;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    nowYears = Jalali.now().year;
    nowMonth = Jalali.now().month;
//
  }

  @override
  void didChangeDependencies() {
    if (_isInit) {
      timingTable();
      timingItems();
    }
    _isInit = false;
    // TODO: implement didChangeDependencies
    super.didChangeDependencies();
  }

  Future<void> timingTable() async {
    setState(() {
      _isLoadingMonth = true;
    });
    monthValueList.clear();
    monthList.clear();
    for (int i = 0; i < 12; i++) {
      print(i.toString());

      Jalali month = Jalali.fromDateTime(
        DateTime.parse(startDate).add(
          Duration(
            days: 30 * i,
          ),
        ),
      );
      monthList.add(month);
      print(month.toString());
      monthValueList.add(EnArConvertor()
          .replaceArNumber(' ${changeMonth(month.month)} ${month.year}'));
    }

    print(_isLoadingMonth.toString());

    setState(() {
      _isLoadingMonth = false;
      print(_isLoadingMonth.toString());
    });
    print(_isLoadingMonth.toString());
  }

  Future<void> timingItems() async {
    setState(() {
      _isLoadingTable = true;
    });
    monthValue = monthValueList[nowMonth - 1];

    await Provider.of<Salons>(context, listen: false).produceTable();
    hours = Provider.of<Salons>(context, listen: false).hours;
    await Provider.of<Salons>(context, listen: false).retrievePlaceTiming(
        widget.place.id, DateTime.parse(startDate), DateTime.parse(endDate));
    loadedTiming = Provider.of<Salons>(context, listen: false).itemTiming;

    dayTiming = Provider.of<Salons>(context, listen: false).itemDayTiming;

    print(_isLoadingTable.toString());

    setState(() {
      _isLoadingTable = false;
      print(_isLoadingTable.toString());
    });
    print(_isLoadingTable.toString());
  }

  String changeWeekDay(int dayId) {
    String dayString = 'شنبه';
    if (dayId == 6) {
      dayString = 'شنبه';
    } else if (dayId == 7) {
      dayString = 'یکشنبه';
    } else if (dayId == 1) {
      dayString = 'دوشنبه';
    } else if (dayId == 2) {
      dayString = 'سه شنبه';
    } else if (dayId == 3) {
      dayString = 'چهارشنبه';
    } else if (dayId == 4) {
      dayString = 'پنج شنبه';
    } else if (dayId == 5) {
      dayString = 'جمعه';
    }
    return dayString;
  }

  String changeMonth(int monthId) {
    String dayString = 'فروردین';
    if (monthId == 1) {
      dayString = 'فروردین';
    } else if (monthId == 2) {
      dayString = 'اردیبهشت';
    } else if (monthId == 3) {
      dayString = 'خرداد';
    } else if (monthId == 4) {
      dayString = 'تیر';
    } else if (monthId == 5) {
      dayString = 'مرداد';
    } else if (monthId == 6) {
      dayString = 'شهریور';
    } else if (monthId == 7) {
      dayString = 'مهر';
    } else if (monthId == 8) {
      dayString = 'آبان';
    } else if (monthId == 9) {
      dayString = 'آذر';
    } else if (monthId == 10) {
      dayString = 'دی';
    } else if (monthId == 11) {
      dayString = 'بهمن';
    } else if (monthId == 12) {
      dayString = 'اسفند';
    }
    return dayString;
  }

  String changeGender(int genderId) {
    String dayString = 'اقایان';
    if (genderId == 1) {
      dayString = 'آقایان';
    } else if (genderId == 2) {
      dayString = 'خانمها';
    }
    return dayString;
  }

  Color cellColor(int j, int i) {
    Color color = Colors.grey.withOpacity(0.1);
    List<Timing> listTiming = dayTiming[i][i.toString()];
    DateTime currentTime = Jalali(startYear, startMonth, i)
        .toDateTime()
        .add(Duration(minutes: j * 15));

    for (int i = 0; i < listTiming.length; i++) {
      if (currentTime.isBefore((DateTime.parse(listTiming[i].date_end))) &
          currentTime.isAfter((DateTime.parse(listTiming[i].date_start)))) {
        color = Colors.green;
        break;
      } else {
        color = Colors.grey.withOpacity(0.1);
      }
    }
    return color;
  }

  String getTimeStringFromDouble(double value) {
    if (value < 0) return 'Invalid Value';
    int flooredValue = value.floor();
    double decimalValue = value - flooredValue;
    String hourValue = getHourString(flooredValue);
    String minuteString = getMinuteString(decimalValue);

    return '$hourValue:$minuteString';
  }

  String getMinuteString(double decimalValue) {
    return '${(decimalValue * 60).toInt()}'.padLeft(2, '0');
  }

  String getHourString(int flooredValue) {
    return '${flooredValue % 24}'.padLeft(2, '0');
  }

  @override
  Widget build(BuildContext context) {
    double deviceHeight = MediaQuery.of(context).size.height;
    double deviceWidth = MediaQuery.of(context).size.width;
    final f = new DateFormat('yyyy-MM-dd hh:mm');
    var textScaleFactor = MediaQuery.of(context).textScaleFactor;
    print(Jalali.fromDateTime(DateTime.parse(startDate)).toString());
    print(Jalali.fromDateTime(DateTime.parse(endDate)).toString());
    return SingleChildScrollView(
      child: _isLoadingMonth
          ? Align(
              alignment: Alignment.center,
              child: SpinKitFadingCircle(
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
              ),
            )
          : Column(
              children: <Widget>[
                Padding(
                    padding: const EdgeInsets.only(top: 5, right: 5),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: <Widget>[
                        Text(
                          'ماه:',
                          style: TextStyle(
                            fontFamily: 'Iransans',
                            fontSize: textScaleFactor * 16.0,
                          ),
                          textAlign: TextAlign.justify,
                        ),
                        Container(
                          decoration: BoxDecoration(
                            color: Colors.white,
                            border: Border.all(color: Colors.grey),
                            borderRadius: BorderRadius.circular(5),
                          ),
                          child: Column(
                            children: <Widget>[
                              Container(
                                width: deviceWidth * 0.7,
                                height: deviceHeight * 0.08,
                                alignment: Alignment.centerRight,
                                decoration: BoxDecoration(
                                    color: Colors.grey.withOpacity(0.2),
                                    border: Border.all(color: Colors.grey)),
                                child: ListWheelScrollView.useDelegate(
                                  itemExtent: 40,
                                  offAxisFraction: 1.1,
                                  physics: FixedExtentScrollPhysics(),
                                  onSelectedItemChanged: (i) {
                                    startDate =
                                        monthList[i].toDateTime().toString();
                                    print(startDate);
                                    nowYears = monthList[i].toDateTime().year;
                                    print(nowYears);

                                    nowMonth = monthList[i].toDateTime().month;
                                    print(nowMonth);
                                  },
                                  childDelegate:
                                      ListWheelChildLoopingListDelegate(
                                    children: List<Widget>.generate(
                                      monthValueList.length,
                                      (index) => Padding(
                                        padding: const EdgeInsets.all(4.0),
                                        child: Container(
                                          width: deviceWidth * 0.3,
                                          decoration: BoxDecoration(
                                            color: Colors.green,
                                            border:
                                                Border.all(color: Colors.white),
                                            borderRadius:
                                                BorderRadius.circular(5),
                                          ),
                                          child: Padding(
                                            padding: const EdgeInsets.all(5.0),
                                            child: Center(
                                              child: Text(
                                                '${monthValueList[index]}',
                                                style: TextStyle(
                                                  color: Colors.white,
                                                  fontFamily: 'Iransans',
                                                  fontSize:
                                                      textScaleFactor * 13.0,
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              InkWell(
                                onTap: () {
                                  timingItems();
                                },
                                child: Card(
                                  child: Container(
                                    color: Colors.green,
                                    width: deviceWidth * 0.7,
                                    height: deviceHeight * 0.04,
                                    child: Center(
                                        child: Text(
                                      'تایید',
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontFamily: 'Iransans',
                                        fontSize: textScaleFactor * 13.0,
                                      ),
                                    )),
                                  ),
                                ),
                              )
                            ],
                          ),
                        ),
                      ],
                    )),
                Divider(),
                Padding(
                  padding: const EdgeInsets.all(5.0),
                  child: Text(
                    'جهت رزرو بر روی تایم های آزاد کلیک کرده و هزینه و مدت زمان را در پایین مشاهده کنید',
                    style: TextStyle(
                      fontFamily: 'Iransans',
                      fontSize: textScaleFactor * 9.0,
                    ),
                    textAlign: TextAlign.justify,
                  ),
                ),
                SizedBox(height: 1),
                _isLoadingTable
                    ? Center(
                        child: SpinKitFadingCircle(
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
                        ),
                      )
                    : Container(
                        height: deviceHeight * 0.5,
                        child: StickyHeadersTable(
                          columnsLength: (hours.length / 4).round(),
                          rowsLength: dayTiming.length,
                          columnsTitleBuilder: (i) => Text(
                            EnArConvertor().replaceArNumber(
                                getTimeStringFromDouble(hours[i * 4])
                                    .toString()),
                            style: TextStyle(
                              fontFamily: 'Iransans',
                              fontSize: textScaleFactor * 14.0,
                            ),
                          ),
                          rowsTitleBuilder: (i) => Card(
                            elevation: 2,
                            child: Container(
                              height: cellHeight,
                              width: sideWidth,
                              color: Jalali.fromDateTime(DateTime(startYear,
                                              startMonth, startDay, 1, 1))
                                          .toDateTime()
                                          .add(Duration(days: i))
                                          .weekday ==
                                      5
                                  ? Colors.red.withOpacity(0.2)
                                  : Colors.white,
                              child: Column(
                                children: <Widget>[
                                  Text(
                                    changeWeekDay(Jalali.fromDateTime(DateTime(
                                                startYear,
                                                startMonth,
                                                startDay,
                                                1,
                                                1))
                                            .toDateTime()
                                            .add(Duration(days: i))
                                            .weekday)
                                        .toString(),
                                    style: TextStyle(
                                      color: AppTheme.textColorMainColor,
                                      fontFamily: 'Iransans',
                                      fontSize: textScaleFactor * 12.0,
                                    ),
                                  ),
                                  Text(
                                    EnArConvertor().replaceArNumber(
                                        Jalali.fromDateTime(DateTime(startYear,
                                                startMonth, startDay, 1, 1))
                                            .toDateTime()
                                            .add(Duration(days: i))
                                            .day
                                            .toString()),
                                    style: TextStyle(
                                      fontFamily: 'Iransans',
                                      fontSize: textScaleFactor * 14.0,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          contentCellBuilder: (i, j) => Card(
                            child: Container(
                              width: cellWidth,
                              height: cellHeight,
                              color: cellColor(i * 4, j),
                              child: (Stack(
                                children: <Widget>[
                                  Center(
                                    child: Text(
                                      '',
                                      style: TextStyle(
                                        fontFamily: 'Iransans',
                                        fontSize: textScaleFactor * 14.0,
                                      ),
                                    ),
                                  ),
                                ],
                              )),
                            ),
                          ),
                          legendCell: Container(
                            height: headerHeight,
                            width: sideWidth,
                            decoration: BoxDecoration(
                                border: Border.all(color: Colors.green),
                                borderRadius: BorderRadius.circular(5)),
                            child: Text(
                              '${EnArConvertor().replaceArNumber(Jalali.fromDateTime(DateTime.parse(startDate)).year.toString())} \n ${changeMonth(Jalali.fromDateTime(DateTime.parse(startDate)).month)}',
                              style: TextStyle(
                                color: AppTheme.textColorMainColor,
                                fontFamily: 'Iransans',
                                fontSize: textScaleFactor * 11.0,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ),
                          cellDimensions: CellDimensions(
                              contentCellHeight: cellHeight,
                              contentCellWidth: cellWidth,
                              stickyLegendHeight: headerHeight,
                              stickyLegendWidth: sideWidth),
                        ),
                      ),
                Divider(),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: Container(
                      color: AppTheme.appBarColor,
                      width: double.infinity,
                      child: FlatButton(
                        color: AppTheme.appBarColor,
                        onPressed: () {
                          showDatePicker(
                              context: context,
                              firstDate: DateTime.now(),
                              initialDate: DateTime.now(),
                              lastDate:
                                  DateTime.now().add(Duration(days: 300)));
                        },
                        child: Text(
                          'پرداخت و رزرو',
                          style: TextStyle(
                            color: Colors.white,
                            fontFamily: 'Iransans',
                            fontSize: textScaleFactor * 18.0,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
    );
  }
}
