import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:tapsalon/widget/en_to_ar_number_convertor.dart';

import '../models/timing.dart';
import '../provider/app_theme.dart';

class TimingTable extends StatefulWidget {
  final List<Timing> timingList;
  final double headerHeight;
  final double rowHeight;
  final double titleWidth;
  final double timeStep;

  TimingTable({
    this.timingList,
    this.headerHeight,
    this.rowHeight,
    this.titleWidth,
    this.timeStep,
  });

  @override
  _TimingTableState createState() => _TimingTableState();
}

class _TimingTableState extends State<TimingTable> {
  List<String> headerTime = ['0:0'];

  List<Positioned> widgetList = [];

  List<String> weekDay = [
    'روزهای\n هفته',
    'شنبه',
    'یکشنبه',
    'دوشنبه',
    'سه شنبه',
    'چهارشنبه',
    'پنج شنبه',
    'جمعه',
  ];

  Future<void> initialTable() async {
    widgetList = widget.timingList
        .map(
          (e) => Positioned(
            top: getHeight(e.date_start, widget.rowHeight),
            right: double.parse((DateTime.parse(e.date_start).hour * 60 +
                    DateTime.parse(e.date_start).minute)
                .toString()),
            width: getDuration(e.date_start, e.date_end, widget.rowHeight),
            child: Container(
              decoration: BoxDecoration(
                color: e.gender == 'male' ? Colors.blue : Colors.redAccent,
                border: Border.all(
                  color: AppTheme.grey,
                ),
                borderRadius: BorderRadius.circular(5),
              ),
              height: widget.rowHeight,
              width: getDuration(e.date_start, e.date_end, widget.rowHeight),
              child: Row(
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.only(right: 4.0),
                    child: FittedBox(
                      child: Text(
                        EnArConvertor().replaceArNumber(
                            '${DateTime.parse(e.date_start).hour}:${DateTime.parse(e.date_start).minute}'),
                        style: TextStyle(
                          fontFamily: 'Iransans',
                          color: AppTheme.white,
                          fontSize:
                              MediaQuery.of(context).textScaleFactor * 16.0,
                        ),
                      ),
                    ),
                  ),
                  Spacer(),
                  Text(
                    EnArConvertor().replaceArNumber('${e.discount}%'),
                    style: TextStyle(
                      fontFamily: 'Iransans',
                      fontWeight: FontWeight.bold,
                      color: AppTheme.white,
                      fontSize: MediaQuery.of(context).textScaleFactor * 17.0,
                    ),
                  ),
                  Spacer(),
                  Padding(
                    padding: const EdgeInsets.only(left: 4.0),
                    child: FittedBox(
                      child: Text(
                        EnArConvertor().replaceArNumber(
                            '${DateTime.parse(e.date_end).hour}:${DateTime.parse(e.date_end).minute}'),
                        style: TextStyle(
                          fontFamily: 'Iransans',
                          color: AppTheme.white,
                          fontSize:
                              MediaQuery.of(context).textScaleFactor * 16.0,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        )
        .toList();
    var timeNumber = 60 * 24 / widget.timeStep;
    print('timeNumber  $timeNumber');
    widgetList.add(Positioned(
      right: (0 * widget.timeStep),
      child: Container(
          height: 7 * widget.rowHeight,
          child: VerticalDivider(
            color: AppTheme.grey,
            indent: 0,
            endIndent: 0,
          )),
    ));
    for (int i = 1; i < timeNumber; i++) {
      headerTime.add(durationToString((i * widget.timeStep).round()));
      widgetList.add(Positioned(
        right: ((i) * widget.timeStep),
        child: Container(
            height: 7 * widget.rowHeight,
            child: VerticalDivider(
              width: 1,
              color: AppTheme.grey,
              indent: 5,
              endIndent: 5,
            )),
      ));
    }

    setState(() {});
  }

  @override
  void didChangeDependencies() async {
    await initialTable();

    super.didChangeDependencies();
  }

  String durationToString(int value) {
    final int hour = value ~/ 60;
    final int minutes = value % 60;
    return '${hour.toString().padLeft(2, "0")}:${minutes.toString().padLeft(2, "0")}';
  }

  double getHeight(String startDate, double rowHeight) {
    double height = ((DateTime.parse(startDate).weekday - 1) * rowHeight);

    return height;
  }

  double getDuration(String startDate, String endTime, double rowHeight) {
    int duration;
    duration = (DateTime.parse(endTime).difference(DateTime.parse(startDate)))
        .inMinutes;
    print(DateTime.parse(endTime)
        .difference(DateTime.parse(startDate))
        .inMinutes);

    return double.parse(duration.toString());
  }

  @override
  Widget build(BuildContext context) {
    double deviceHeight = MediaQuery.of(context).size.height;
    double deviceWidth = MediaQuery.of(context).size.width;
    var textScaleFactor = MediaQuery.of(context).textScaleFactor;
    initialTable();

    return Container(
      height: 7 * widget.rowHeight + widget.headerHeight + 2,
      width: 1440 + widget.titleWidth + widget.titleWidth,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Container(
            height: 7 * widget.rowHeight + widget.headerHeight,
            width: widget.titleWidth,
            child: ListView.builder(
              primary: false,
              scrollDirection: Axis.vertical,
              padding: const EdgeInsets.all(8),
              itemCount: weekDay.length,
              itemBuilder: (BuildContext context, int index) {
                return index == 0
                    ? Container(
                        height: widget.headerHeight,
                        width: widget.titleWidth,
                        child: Padding(
                          padding: const EdgeInsets.all(3.0),
                          child: FittedBox(
                            child: Text(
                              weekDay[index],
                              maxLines: 2,
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontFamily: 'Iransans',
                                fontWeight: FontWeight.bold,
                                color: AppTheme.black,
                                fontSize: textScaleFactor * 12.0,
                              ),
                            ),
                          ),
                        ),
                      )
                    : Container(
                        height: widget.headerHeight,
                        width: widget.titleWidth,
                        child: Center(
                          child: Text(
                            weekDay[index],
                            maxLines: 1,
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontFamily: 'Iransans',
                              fontWeight: FontWeight.bold,
                              color: AppTheme.black,
                              fontSize: textScaleFactor * 14.0,
                            ),
                          ),
                        ),
                      );
              },
            ),
          ),
          Expanded(
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Container(
                height: 7 * widget.rowHeight + widget.headerHeight + 2,
                width: 1440,
                child: Column(
                  children: <Widget>[
                    Container(
                      height: widget.headerHeight,
                      width: 1440,
                      child: ListView.builder(
                        physics: const NeverScrollableScrollPhysics(),
                        scrollDirection: Axis.horizontal,
                        padding: const EdgeInsets.all(8),
                        itemCount: headerTime.length,
                        itemBuilder: (BuildContext context, int index) {
                          return Container(
                            width: widget.timeStep,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: <Widget>[
                                Center(
                                  child: VerticalDivider(
                                    width: 1,
                                    thickness: 1,
                                    color: Colors.black,
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(4.0),
                                  child: Text(
                                    EnArConvertor()
                                        .replaceArNumber(headerTime[index]),
                                    style: TextStyle(
                                      fontFamily: 'Iransans',
                                      fontWeight: FontWeight.bold,
                                      color: AppTheme.black,
                                      fontSize: textScaleFactor * 17.0,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          );
                        },
                      ),
                    ),
                    Divider(
                      height: 1,
                    ),
                    Container(
                      height: 7 * widget.rowHeight,
                      width: 1440,
                      child: Stack(
                        fit: StackFit.passthrough,
                        children: widgetList,
                      ),
                    ),
                    Divider(
                      height: 1,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
