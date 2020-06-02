import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:tapsalon/models/timing.dart';

class TimingTable extends StatefulWidget {
  List<Timing> timingList;
  double height;
  double headerHeight;
  double width;
  double timeStep;

  TimingTable({
    this.timingList,
    this.height,
    this.width,
    this.timeStep,
    this.headerHeight,
  });

  @override
  _TimingTableState createState() => _TimingTableState();
}

class _TimingTableState extends State<TimingTable> {
  List<String> headerTime = ['0:0'];
  final List<int> colorCodes = [];

  @override
  void didChangeDependencies() {
    var timeNumber = 60 * 24 / widget.timeStep;
    print('timeNumber  $timeNumber');
    for (int i = 1; i < timeNumber; i++) {
//      print('timeNumber11111  ${int.parse((i * widget.timeStep).toString())}');
      print('timeNumber  $timeNumber');

      headerTime.add(durationToString((i * widget.timeStep).round()));
//          ;
    }
    super.didChangeDependencies();
  }

  @override
  void initState() {
    super.initState();
  }

  String durationToString(int value) {
    final int hour = value ~/ 60;
    final int minutes = value % 60;
    return '${hour.toString().padLeft(2, "0")}:${minutes.toString().padLeft(2, "0")}';
//    var d = Duration(minutes: minutes);
//    List<String> parts = d.toString().split(':');
//    return '${parts[0].padLeft(2, '0')}:${parts[1].padLeft(2, '0')}';
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: widget.height,
      child: Column(
        children: <Widget>[
          Container(
            height: widget.headerHeight,
//            width: widget.width,
            child: ListView.builder(
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
                          thickness: 1,
                          color: Colors.black,
                        ),
                      ),
                      FittedBox(
                        child: Text(
                          headerTime[index],
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),

          Container(
            height: widget.height,

            child: Stack(

              children:
                widget.timingList.map((e) => Container(child: Text(e.date_start))).toList(),


            ),
          )
        ],
      ),
    );
  }
}
