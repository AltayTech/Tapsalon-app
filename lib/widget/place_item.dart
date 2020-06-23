import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart' as intl;
import 'package:provider/provider.dart';
import 'package:smooth_star_rating/smooth_star_rating.dart';
import 'file:///C:/AndroidStudioProjects/Pro_tapsalon/tapsalon_flutter/tapsalon/lib/models/places_models/place_in_search.dart';
import 'package:tapsalon/screen/place_detail/place_detail_screen.dart';

import '../provider/app_theme.dart';
import 'en_to_ar_number_convertor.dart';

class PlaceItem extends StatelessWidget {
  final PlaceInSearch place;

  PlaceItem({this.place});

  @override
  Widget build(BuildContext context) {
    double deviceHeight = MediaQuery.of(context).size.height;
    double deviceWidth = MediaQuery.of(context).size.width;
    double textScaleFactor = MediaQuery.of(context).textScaleFactor;
    var currencyFormat = intl.NumberFormat.decimalPattern();

    return LayoutBuilder(
      builder: (context, constraint) => InkWell(
        onTap: () {
          Navigator.of(context).pushNamed(
            PlaceDetailScreen.routeName,
            arguments: {
              'placeId': place.id,
              'name': place.name,
              'imageUrl': place.image.url.medium,
              'stars': place.stars.toString()
            },
          );
        },
        child: Stack(
          children: <Widget>[
            Card(
              child: Container(
                width: constraint.maxWidth,
                height: constraint.maxHeight,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Container(
                      width: constraint.maxWidth,
                      height: constraint.maxHeight * 0.55,
                      child: FadeInImage(
                        placeholder:
                            AssetImage('assets/images/tapsalon_icon_200.png'),
                        image: NetworkImage(place.image.url.medium.toString()),
                        fit: BoxFit.cover,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 8, right: 8),
                      child: Text(
                        place.name,
                        overflow: TextOverflow.ellipsis,
                        textAlign: TextAlign.right,
                        maxLines: 1,
                        style: TextStyle(
                          fontFamily: 'Iransans',
                          fontWeight: FontWeight.bold,
                          fontSize: textScaleFactor * 12.0,
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 8, right: 8),
                      child: Text(
                        place.excerpt,
                        overflow: TextOverflow.ellipsis,
                        textAlign: TextAlign.right,
                        maxLines: 2,
                        style: TextStyle(
                          fontFamily: 'Iransans',
                          fontSize: textScaleFactor * 12.0,
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 8, right: 8),
                      child: Container(
                        width: constraint.maxWidth,
                        height: constraint.maxHeight * 0.1,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: <Widget>[
                            Padding(
                              padding: const EdgeInsets.only(
                                  left: 3.0, top: 4, bottom: 5),
                              child: Icon(
                                Icons.location_on,
                                color: Colors.blue,
                                size: 20,
                              ),
                            ),
                            Text(
                              place.region.name,
                              textAlign: TextAlign.right,
                              overflow: TextOverflow.ellipsis,
                              maxLines: 2,
                              style: TextStyle(
                                fontFamily: 'Iransans',
                                fontSize: textScaleFactor * 12.0,
                              ),
                            ),
                            Spacer(),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Directionality(
                                textDirection: TextDirection.ltr,
                                child: SmoothStarRating(
                                    allowHalfRating: false,
                                    onRated: (v) {},
                                    starCount: 5,
                                    rating: place.stars,
                                    size: constraint.maxWidth * 0.05,
                                    color: Colors.green,
                                    borderColor: Colors.green,
                                    spacing: 0.0),
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: Container(
                        width: constraint.minWidth,
                        height: constraint.maxHeight * 0.07,
                        child: ListView.builder(
                          scrollDirection: Axis.horizontal,
                          itemCount: place.fields.length,
                          itemBuilder: (ctx, i) => ChangeNotifierProvider.value(
                            value: place.fields[i],
                            child: Text(
                              i < (place.fields.length - 1)
                                  ? (place.fields[i].name + ' ،')
                                  : place.fields[i].name,
                              style: TextStyle(
                                fontFamily: 'Iransans',
                                color: Colors.black54,
                                fontSize: textScaleFactor * 14.0,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Positioned(
              top: constraint.maxHeight * 0.05,
              left: -1,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(5),
                child: Container(
                  color: AppTheme.discountBgColor,
                  child: Padding(
                    padding:
                        const EdgeInsets.symmetric(vertical: 4, horizontal: 10),
                    child: Text(
                      'تخفیف 20%',
                      style: TextStyle(
                        fontFamily: 'Iransans',
                        color: Colors.white,
                        fontSize: textScaleFactor * 11.0,
                      ),
                    ),
                  ),
                ),
              ),
            ),
            Positioned(
              top: constraint.maxHeight * 0.20,
              left: -1,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(5),
                child: Container(
                  color: AppTheme.priceBgColor,
                  child: Padding(
                    padding:
                        const EdgeInsets.symmetric(vertical: 4, horizontal: 10),
                    child: Text(
                      'قابل روزرو',
                      style: TextStyle(
                        fontFamily: 'Iransans',
                        color: Colors.white,
                        fontSize: textScaleFactor * 11.0,
                      ),
                    ),
                  ),
                ),
              ),
            ),
            Positioned(
              top: constraint.maxHeight * 0.550,
              left: constraint.maxWidth * 0.05,
              child: Wrap(
                direction: Axis.vertical,
                crossAxisAlignment: WrapCrossAlignment.center,
                children: <Widget>[
                  Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(5),
                      color: AppTheme.priceBgColor,
                    ),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          vertical: 4, horizontal: 10),
                      child: Text(
                        place.price != null
                            ? EnArConvertor()
                                .replaceArNumber(currencyFormat
                                    .format(
                                        double.parse(place.price.toString()))
                                    .toString())
                                .toString()
                            : EnArConvertor().replaceArNumber('0'),
                        style: TextStyle(
                          color: Colors.white,
                          fontFamily: 'Iransans',
                          fontSize: textScaleFactor * 16.0,
                        ),
                      ),
                    ),
                  ),
                  Text(
                    'تومان',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontFamily: 'Iransans',
                      fontSize: textScaleFactor * 7.0,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
