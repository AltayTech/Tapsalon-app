import 'package:flutter/material.dart';
import 'package:intl/intl.dart' as intl;
import 'package:provider/provider.dart';
import 'package:tapsalon/models/places_models/place_in_search.dart';
import 'package:tapsalon/provider/app_theme.dart';
import 'package:tapsalon/screen/place_detail/complex_detail_screen.dart';
import 'package:tapsalon/screen/place_detail/place_detail_screen.dart';

import '../en_to_ar_number_convertor.dart';

class MapInfoWindowItem extends StatefulWidget {
  final PlaceInSearch selectedPlace;

  MapInfoWindowItem({this.selectedPlace});

  @override
  _MapInfoWindowItemState createState() => _MapInfoWindowItemState();
}

class _MapInfoWindowItemState extends State<MapInfoWindowItem> {
  var _isLoading = false;

  @override
  Widget build(BuildContext context) {
    double deviceHeight = MediaQuery.of(context).size.height;
    double deviceWidth = MediaQuery.of(context).size.width;
    var textScaleFactor = MediaQuery.of(context).textScaleFactor;
    var currencyFormat = intl.NumberFormat.decimalPattern();

    return LayoutBuilder(
      builder: (cxt, constraint) => InkWell(
        onTap: () {
          Navigator.of(context).pushNamed(
            widget.selectedPlace.placeType.id==3? ComplexDetailScreen.routeName: PlaceDetailScreen.routeName,
            arguments: {
              'placeId': widget.selectedPlace.id,
              'name': widget.selectedPlace.name,
              'imageUrl': widget.selectedPlace.image.url.medium,
              'stars': widget.selectedPlace.rate.toString(),
            },
          );
        },
        child: Container(
          decoration: BoxDecoration(
              color: AppTheme.white,
              borderRadius: BorderRadius.only(
                topRight: Radius.circular(15),
                topLeft: Radius.circular(15),
              )),
          height: deviceHeight * 0.23,
          width: deviceWidth,
          child: Padding(
            padding: const EdgeInsets.all(10.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Expanded(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      Expanded(
                        flex: 8,
                        child: Padding(
                          padding: const EdgeInsets.only(right: 5.0),
                          child: Text(
                            widget.selectedPlace.name,
                            overflow: TextOverflow.ellipsis,
                            textAlign: TextAlign.right,
                            maxLines: 1,
                            style: TextStyle(
                              fontFamily: 'Iransans',
                              fontWeight: FontWeight.bold,
                              fontSize: textScaleFactor * 16.0,
                            ),
                          ),
                        ),
                      ),
                      Expanded(
                        flex: 2,
                        child: widget.selectedPlace.rate != null &&
                                widget.selectedPlace.rate != 0
                            ? Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: <Widget>[
                                  Icon(
                                    Icons.star,
                                    color: AppTheme.iconColor,
                                    size: 25,
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(
                                      right: 5,
                                      top: 5,
                                    ),
                                    child: Text(
                                      EnArConvertor().replaceArNumber(
                                        widget.selectedPlace.rate.toString(),
                                      ),
                                      textAlign: TextAlign.right,
                                      overflow: TextOverflow.ellipsis,
                                      maxLines: 1,
                                      style: TextStyle(
                                        fontFamily: 'Iransans',
                                        color: AppTheme.grey,
                                        fontSize: textScaleFactor * 16.0,
                                      ),
                                    ),
                                  ),
                                ],
                              )
                            : Container(),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      Expanded(
                        flex: 8,
                        child: Padding(
                          padding: const EdgeInsets.only(right: 5.0),
                          child: Container(
                            width: constraint.minWidth * 0.7,
                            child: Wrap(
                              children: widget.selectedPlace.fields
                                  .map(
                                    (e) => ChangeNotifierProvider.value(
                                      value: e,
                                      child: Text(
                                        widget.selectedPlace.fields.indexOf(e) <
                                                (widget.selectedPlace.fields
                                                        .length -
                                                    1)
                                            ? (e.name + ' ،')
                                            : e.name,
                                        style: TextStyle(
                                          fontFamily: 'Iransans',
                                          color: AppTheme.grey,
                                          fontSize: textScaleFactor * 15.0,
                                        ),
                                        textAlign: TextAlign.center,
                                      ),
                                    ),
                                  )
                                  .toList(),
                            ),
                          ),
                        ),
                      ),
                      Expanded(
                        flex: 3,
                        child: widget.selectedPlace.price != null &&
                                widget.selectedPlace.price != 0
                            ? Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: <Widget>[
                                  Text(
                                    widget.selectedPlace.price != null
                                        ? EnArConvertor()
                                            .replaceArNumber(currencyFormat
                                                .format(double.parse(widget
                                                    .selectedPlace.price
                                                    .toString()))
                                                .toString())
                                            .toString()
                                        : EnArConvertor().replaceArNumber('0'),
                                    style: TextStyle(
                                      color: AppTheme.black,
                                      fontFamily: 'Iransans',
                                      fontSize: textScaleFactor * 18.0,
                                    ),
                                  ),
                                  Text(
                                    'هزار \n تومان',
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      fontFamily: 'Iransans',
                                      color: AppTheme.grey,
                                      fontSize: textScaleFactor * 10.0,
                                    ),
                                  ),
                                ],
                              )
                            : Container(),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      Padding(
                        padding:
                            const EdgeInsets.only(left: 3.0, top: 4, bottom: 5),
                        child: Icon(
                          Icons.location_on,
                          color: AppTheme.iconColor,
                          size: 25,
                        ),
                      ),
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.only(
                              left: 3.0, top: 4, bottom: 1),
                          child: Text(
                            widget.selectedPlace.address,
                            textAlign: TextAlign.right,
                            overflow: TextOverflow.ellipsis,
                            maxLines: 1,
                            style: TextStyle(
                              fontFamily: 'Iransans',
                              color: AppTheme.grey,
                              fontSize: textScaleFactor * 15.0,
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
        ),
      ),
    );
  }
}
