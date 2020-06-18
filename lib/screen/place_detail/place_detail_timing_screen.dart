import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:provider/provider.dart';
import 'package:tapsalon/classes/timing_table.dart';
import 'package:tapsalon/provider/app_theme.dart';

import '../../models/place.dart';
import '../../models/timing.dart';
import '../../provider/salons.dart';

class PlaceDetailTimingScreen extends StatefulWidget {
  final Place place;

  PlaceDetailTimingScreen({this.place});

  @override
  _PlaceDetailTimingScreenState createState() =>
      _PlaceDetailTimingScreenState();
}

class _PlaceDetailTimingScreenState extends State<PlaceDetailTimingScreen> {
  var _isLoadingTable;
  bool _isInit = true;

  List<Timing> loadedTiming = [];

  @override
  void didChangeDependencies() async {
    if (_isInit) {
      await timingItems();
    }
    _isInit = false;
    super.didChangeDependencies();
  }

  Future<void> timingItems() async {
    setState(() {
      _isLoadingTable = true;
    });

    await Provider.of<Salons>(context, listen: false).retrievePlaceTiming(
      widget.place.id,
    );

    loadedTiming = Provider.of<Salons>(context, listen: false).itemTiming;

    setState(() {
      _isLoadingTable = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    double deviceHeight = MediaQuery.of(context).size.height;
    double deviceWidth = MediaQuery.of(context).size.width;
    var textScaleFactor = MediaQuery.of(context).textScaleFactor;

    return SingleChildScrollView(
      child: _isLoadingTable
          ? Container(
        height: deviceHeight*0.7,
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
          : Consumer<Salons>(
              builder: (_, itemTiming, ch) => Card(
                child: TimingTable(
                  timeStep: 60,
                  headerHeight: 50,
                  timingList: itemTiming.itemTiming,
                  rowHeight: 50,
                  titleWidth: 70,
                ),
              ),
            ),
    );
  }
}
