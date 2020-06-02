import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:provider/provider.dart';
import 'package:shamsi_date/shamsi_date.dart';
import 'package:tapsalon/classes/timing_table.dart';

import '../../models/place.dart';
import '../../models/timing.dart';
import '../../provider/app_theme.dart';
import '../../provider/salons.dart';
import '../../widget/en_to_ar_number_convertor.dart';

class SalonDetailTimingScreen extends StatefulWidget {
  final Place place;

  SalonDetailTimingScreen({this.place});

  @override
  _SalonDetailTimingScreenState createState() =>
      _SalonDetailTimingScreenState();
}

class _SalonDetailTimingScreenState extends State<SalonDetailTimingScreen> {
//  var _isLoadingMonth;
  var _isLoadingTable;
  bool _isInit = true;
//
  List<Timing> loadedTiming;
//
//  List<double> hours;
//
//  double cellHeight = 50;
//  double cellWidth = 60;
//  double headerHeight = 50;
//  double sideWidth = 60;
//
//  String startDate = '2020-03-02 00:00:00';
//  String endDate = '2020-03-08 00:00:00';
//  int startYear = 1398;
//  int startMonth = 12;
//  int startDay = 1;
//  List<Map<String, List<Timing>>> dayTiming;
//
//  List<String> monthValueList = [];
//  List<Jalali> monthList = [];
//
//  int nowYears;
//
//  int nowMonth;
//
//  String monthValue;
//
//  String yearValue;
//
//  @override
//  void initState() {
//    nowYears = Jalali.now().year;
//    nowMonth = Jalali.now().month;
//    super.initState();
//  }
//
  @override
  void didChangeDependencies() {
    if (_isInit) {
//      timingTable();
      timingItems();
    }
    _isInit = false;
    super.didChangeDependencies();
  }

//  Future<void> timingTable() async {
//    setState(() {
//      _isLoadingMonth = true;
//    });
//    monthValueList.clear();
//    monthList.clear();
//    for (int i = 0; i < 12; i++) {
//      print(i.toString());
//
//      Jalali month = Jalali.fromDateTime(
//        DateTime.parse(startDate).add(
//          Duration(
//            days: 30 * i,
//          ),
//        ),
//      );
//      monthList.add(month);
//      print(month.toString());
//      monthValueList.add(EnArConvertor()
//          .replaceArNumber(' ${changeMonth(month.month)} ${month.year}'));
//    }
//
//    print(_isLoadingMonth.toString());
//
//    setState(() {
//      _isLoadingMonth = false;
//      print(_isLoadingMonth.toString());
//    });
//    print(_isLoadingMonth.toString());
//  }

  Future<void> timingItems() async {
    setState(() {
      _isLoadingTable = true;
    });
//    monthValue = monthValueList[nowMonth - 1];

    await Provider.of<Salons>(context, listen: false).produceTable();
//    hours = Provider.of<Salons>(context, listen: false).hours;
    await Provider.of<Salons>(context, listen: false).retrievePlaceTiming(
        widget.place.id, );
    loadedTiming = Provider.of<Salons>(context, listen: false).itemTiming;

    dayTiming = Provider.of<Salons>(context, listen: false).itemDayTiming;

    print(_isLoadingTable.toString());
    setState(() {
      _isLoadingTable = false;
      print(_isLoadingTable.toString());
    });
    print(_isLoadingTable.toString());
  }

//  String changeWeekDay(int dayId) {
//    String dayString = 'شنبه';
//    if (dayId == 6) {
//      dayString = 'شنبه';
//    } else if (dayId == 7) {
//      dayString = 'یکشنبه';
//    } else if (dayId == 1) {
//      dayString = 'دوشنبه';
//    } else if (dayId == 2) {
//      dayString = 'سه شنبه';
//    } else if (dayId == 3) {
//      dayString = 'چهارشنبه';
//    } else if (dayId == 4) {
//      dayString = 'پنج شنبه';
//    } else if (dayId == 5) {
//      dayString = 'جمعه';
//    }
//    return dayString;
//  }
//
//  String changeMonth(int monthId) {
//    String dayString = 'فروردین';
//    if (monthId == 1) {
//      dayString = 'فروردین';
//    } else if (monthId == 2) {
//      dayString = 'اردیبهشت';
//    } else if (monthId == 3) {
//      dayString = 'خرداد';
//    } else if (monthId == 4) {
//      dayString = 'تیر';
//    } else if (monthId == 5) {
//      dayString = 'مرداد';
//    } else if (monthId == 6) {
//      dayString = 'شهریور';
//    } else if (monthId == 7) {
//      dayString = 'مهر';
//    } else if (monthId == 8) {
//      dayString = 'آبان';
//    } else if (monthId == 9) {
//      dayString = 'آذر';
//    } else if (monthId == 10) {
//      dayString = 'دی';
//    } else if (monthId == 11) {
//      dayString = 'بهمن';
//    } else if (monthId == 12) {
//      dayString = 'اسفند';
//    }
//    return dayString;
//  }
//
//  String changeGender(int genderId) {
//    String dayString = 'اقایان';
//    if (genderId == 1) {
//      dayString = 'آقایان';
//    } else if (genderId == 2) {
//      dayString = 'خانمها';
//    }
//    return dayString;
//  }
//
//  Color cellColor(int j, int i) {
//    Color color = Colors.grey.withOpacity(0.1);
//    List<Timing> listTiming = dayTiming[i][i.toString()];
//    DateTime currentTime = Jalali(startYear, startMonth, i)
//        .toDateTime()
//        .add(Duration(minutes: j * 15));
//
//    for (int i = 0; i < listTiming.length; i++) {
//      if (currentTime.isBefore((DateTime.parse(listTiming[i].date_end))) &
//          currentTime.isAfter((DateTime.parse(listTiming[i].date_start)))) {
//        color = Colors.green;
//        break;
//      } else {
//        color = Colors.grey.withOpacity(0.1);
//      }
//    }
//    return color;
//  }
//
//  String getTimeStringFromDouble(double value) {
//    if (value < 0) return 'Invalid Value';
//    int flooredValue = value.floor();
//    double decimalValue = value - flooredValue;
//    String hourValue = getHourString(flooredValue);
//    String minuteString = getMinuteString(decimalValue);
//
//    return '$hourValue:$minuteString';
//  }
//
//  String getMinuteString(double decimalValue) {
//    return '${(decimalValue * 60).toInt()}'.padLeft(2, '0');
//  }
//
//  String getHourString(int flooredValue) {
//    return '${flooredValue % 24}'.padLeft(2, '0');
//  }

  @override
  Widget build(BuildContext context) {
    double deviceHeight = MediaQuery.of(context).size.height;
    double deviceWidth = MediaQuery.of(context).size.width;
    var textScaleFactor = MediaQuery.of(context).textScaleFactor;

    return SingleChildScrollView(
      child:
//      _isLoadingMonth
//          ? Align(
//              alignment: Alignment.center,
//              child: SpinKitFadingCircle(
//                itemBuilder: (BuildContext context, int index) {
//                  return DecoratedBox(
//                    decoration: BoxDecoration(
//                      shape: BoxShape.circle,
//                      color: index.isEven
//                          ? AppTheme.spinerColor
//                          : AppTheme.spinerColor,
//                    ),
//                  );
//                },
//              ),
//            )
//          :
      Container(
              height: 150,
              child: TimingTable(
                height: 150,
                timeStep: 60,
                headerHeight: 50,
                width: deviceWidth,

              )),
    );
  }
}
