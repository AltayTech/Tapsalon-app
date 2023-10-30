import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart' as intl;
import 'package:provider/provider.dart';
import 'package:tapsalon/models/places_models/place_in_search.dart';
import 'package:tapsalon/provider/places.dart';
import 'package:tapsalon/screen/place_detail/place_detail_screen.dart';

import '../../provider/app_theme.dart';
import '../en_to_ar_number_convertor.dart';

class PlaceItem extends StatelessWidget {
  final PlaceInSearch place;

  PlaceItem({required this.place});

  @override
  Widget build(BuildContext context) {
    double deviceHeight = MediaQuery.of(context).size.height;
    double deviceWidth = MediaQuery.of(context).size.width;
    double textScaleFactor = MediaQuery.of(context).textScaleFactor;
    var currencyFormat = intl.NumberFormat.decimalPattern();
    var defaultImage = Provider.of<Places>(context, listen: false).defaultImage;
    return Padding(
      padding: const EdgeInsets.only(top: 16),
      child: LayoutBuilder(
        builder: (context, constraint) => InkWell(
          onTap: () {
            Navigator.of(context).pushNamed(
              PlaceDetailScreen.routeName,
              arguments: {
                'placeId': place.id,
                'name': place.name,
                'imageUrl': place.image.url.medium,
                'stars': place.rate.toString()
              },
            );
          },
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: AppTheme.primary.withOpacity(1),
                  blurRadius: 10.10,
                  spreadRadius: 5.510,
                  offset: Offset(
                    0,
                    0,
                  ),
                )
              ],
              borderRadius: new BorderRadius.all(
                Radius.circular(3),
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                ClipRRect(
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(5),
                    topRight: Radius.circular(5),
                  ),
                  child: Container(
                    width: constraint.maxWidth,
                    height: constraint.maxHeight * 0.55,
                    child: FadeInImage(
                      placeholder: AssetImage(defaultImage.url.medium),
                      image: NetworkImage(place.image.url.medium.toString()),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                Container(
                  width: constraint.maxWidth,
                  child: Padding(
                    padding: const EdgeInsets.only(top: 7, right: 18, left: 16),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        Text(
                          place.name,
                          overflow: TextOverflow.ellipsis,
                          textAlign: TextAlign.right,
                          maxLines: 1,
                          style: TextStyle(
                            fontFamily: 'Iransans',
                            fontWeight: FontWeight.bold,
                            fontSize: textScaleFactor * 16.0,
                          ),
                        ),
                        Spacer(),
                        place.rate != 0.0 && place.rate != 0
                            ? Row(
                                children: <Widget>[
                                  Padding(
                                    padding: const EdgeInsets.only(
                                        right: 1, left: 3.0, top: 1, bottom: 6),
                                    child: Icon(
                                      Icons.star,
                                      color: AppTheme.iconColor,
                                      size: 25,
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(
                                        right: 5, left: 0, top: 1, bottom: 4),
                                    child: Text(
                                      EnArConvertor().replaceArNumber(
                                        place.rate.toString(),
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
                      ],
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 5, right: 14, left: 16),
                  child: Container(
                    width: constraint.maxWidth,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        Padding(
                          padding: const EdgeInsets.only(
                              left: 3.0, top: 4, bottom: 5),
                          child: Icon(
                            Icons.location_on,
                            color: AppTheme.iconColor,
                            size: 25,
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.only(
                              left: 3.0, top: 4, bottom: 1),
                          child: Text(
                            place.region.name,
                            textAlign: TextAlign.right,
                            overflow: TextOverflow.ellipsis,
                            maxLines: 1,
                            style: TextStyle(
                              fontFamily: 'Iransans',
                              color: AppTheme.grey,
                              fontSize: textScaleFactor * 14.0,
                            ),
                          ),
                        ),
                        Spacer(),
                        place.price != null &&
                                place.price != 0.0 &&
                                place.price != 0
                            ? Wrap(
                                direction: Axis.horizontal,
                                crossAxisAlignment: WrapCrossAlignment.center,
                                children: <Widget>[
                                  Container(
                                    child: Padding(
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 4, horizontal: 10),
                                      child: Text(
                                        place.price != null
                                            ? EnArConvertor()
                                                .replaceArNumber(currencyFormat
                                                    .format(double.parse(
                                                        place.price.toString()))
                                                    .toString())
                                                .toString()
                                            : EnArConvertor()
                                                .replaceArNumber('0'),
                                        style: TextStyle(
                                          color: AppTheme.black,
                                          fontFamily: 'Iransans',
                                          fontSize: textScaleFactor * 16.0,
                                        ),
                                      ),
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
                            : Container(
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                    vertical: 4,
                                  ),
                                  child: Text(
//                             'هزینه ثبت نشده',
                                    '',
                                    style: TextStyle(
                                      color: AppTheme.grey,
                                      fontFamily: 'Iransans',
                                      fontSize: textScaleFactor * 14.0,
                                    ),
                                  ),
                                ),
                              ),
                      ],
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(
                      right: 18, left: 16, top: 5, bottom: 4),
                  child: Container(
                    width: constraint.minWidth,
                    child: Wrap(
                      children: place.fields
                          .map((e) => ChangeNotifierProvider.value(
                                value: e,
                                child: Text(
                                  place.fields.indexOf(e) <
                                          (place.fields.length - 1)
                                      ? (e.name + ' ،')
                                      : e.name,
                                  style: TextStyle(
                                    fontFamily: 'Iransans',
                                    color: AppTheme.grey,
                                    fontSize: textScaleFactor * 14.0,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                              ))
                          .toList(),
                    ),
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
