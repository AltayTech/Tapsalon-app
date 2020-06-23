import 'package:flutter/material.dart';
import 'package:flutter_calendar_carousel/flutter_calendar_carousel.dart';

import '../models/event.dart';

class ReserveDetailScreen extends StatefulWidget {
  static const routeName = '/reserveDetail';

  @override
  _ReserveDetailScreenState createState() => _ReserveDetailScreenState();
}

class _ReserveDetailScreenState extends State<ReserveDetailScreen> {
  DateTime _currentDate;

  var _markedDateMap;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: 16.0),
        child: CalendarCarousel(
          onDayPressed: (DateTime date, List<Event> events) {
            this.setState(() => _currentDate = date);
          },
          weekendTextStyle: TextStyle(
            color: Colors.red,
          ),
          thisMonthDayBorderColor: Colors.grey,

          customDayBuilder: (
            /// you can provide your own build function to make custom day containers
            bool isSelectable,
            int index,
            bool isSelectedDay,
            bool isToday,
            bool isPrevMonthDay,
            TextStyle textStyle,
            bool isNextMonthDay,
            bool isThisMonthDay,
            DateTime day,
          ) {
            /// If you return null, [CalendarCarousel] will build container for current [day] with default function.
            /// This way you can build custom containers for specific days only, leaving rest as default.

            // Example: every 15th of month, we have a flight, we can place an icon in the container like that:
            if (day.day == 15) {
              return Center(
                child: Icon(Icons.local_airport),
              );
            } else {
              return null;
            }
          },
          weekFormat: false,
          markedDatesMap: _markedDateMap,
          height: 420.0,
          selectedDateTime: _currentDate,
          daysHaveCircularBorder: true,
          isScrollable: false,

          scrollDirection: Axis.horizontal,

          /// null for not rendering any border, true for circular border, false for rectangular border
        ),
      ),
    );
  }
}
