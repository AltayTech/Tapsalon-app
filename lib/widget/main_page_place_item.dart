import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:tapsalon/models/places_models/place_in_search.dart';
import 'package:tapsalon/screen/place_detail/place_detail_screen.dart';

import '../provider/app_theme.dart';
import 'en_to_ar_number_convertor.dart';

class MainPagePlaceItem extends StatelessWidget {
  final PlaceInSearch loadedPlace;

  MainPagePlaceItem({this.loadedPlace});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: LayoutBuilder(
        builder: (context, constraint) => InkWell(
          onTap: () {
            Navigator.of(context)
                .pushNamed(PlaceDetailScreen.routeName, arguments: {
              'placeId': loadedPlace.id,
              'name': loadedPlace.name,
              'imageUrl': loadedPlace.image.url.medium,
              'stars': loadedPlace.rate.toString()
            });
          },
          child: Stack(
            children: <Widget>[
              Container(
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
                    borderRadius: new BorderRadius.all(Radius.circular(3))),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Container(
                      height: constraint.maxHeight * 0.65,
                      child: FadeInImage(
                        placeholder:
                            AssetImage('assets/images/tapsalon_icon_200.png'),
                        image: NetworkImage(
                            loadedPlace.image.url.medium.toString()),
                        fit: BoxFit.cover,
                      ),
                    ),
                    SizedBox(
                      height: constraint.maxHeight * 0.05,
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      child: Container(
                        height: constraint.maxHeight * 0.12,
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Container(
                              width: constraint.maxWidth * 0.7,
                              child: Text(
                                loadedPlace.name,
                                textAlign: TextAlign.right,
                                overflow: TextOverflow.ellipsis,
                                maxLines: 1,
                                style: TextStyle(
                                  fontFamily: 'Iransans',
                                  fontSize:
                                      MediaQuery.of(context).textScaleFactor *
                                          14.0,
                                ),
                              ),
                            ),
                            Spacer(),
                            Text(
                              EnArConvertor().replaceArNumber('20%'),
                              textAlign: TextAlign.right,
                              overflow: TextOverflow.ellipsis,
                              maxLines: 1,
                              style: TextStyle(
                                fontFamily: 'Iransans',
                                color: AppTheme.black,
                                fontSize:
                                    MediaQuery.of(context).textScaleFactor *
                                        14.0,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    Container(
                      width: constraint.maxWidth,
                      height: constraint.maxHeight * 0.1,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                          Padding(
                            padding: const EdgeInsets.only(
                                right: 1, left: 3.0, top: 1, bottom: 4),
                            child: Icon(
                              Icons.location_on,
                              color: AppTheme.iconColor,
                              size: 20,
                            ),
                          ),
                          Container(
                            width: constraint.maxWidth*0.4,
                            child: Text(
                              loadedPlace.region.name,
                              textAlign: TextAlign.right,
                              overflow: TextOverflow.ellipsis,
                              maxLines: 1,
                              style: TextStyle(
                                fontFamily: 'Iransans',
                                color: AppTheme.grey,
                                fontSize:
                                    MediaQuery.of(context).textScaleFactor * 12.0,
                              ),
                            ),
                          ),
                          Spacer(),
                          Padding(
                            padding: const EdgeInsets.only(
                                right: 1, left: 3.0, top: 1, bottom: 4),
                            child: Icon(
                              Icons.star,
                              color: AppTheme.iconColor,
                              size: 15,
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(
                                right: 5, left:10, top: 1, bottom: 4),
                            child: Text(
                              EnArConvertor().replaceArNumber(
                                loadedPlace.rate.toString(),
                              ),
                              textAlign: TextAlign.right,
                              overflow: TextOverflow.ellipsis,
                              maxLines: 1,
                              style: TextStyle(

                                fontFamily: 'Iransans',
                                color: AppTheme.grey,

                                fontSize:
                                    MediaQuery.of(context).textScaleFactor *
                                        12.0,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),


            ],
          ),
        ),
      ),
    );
  }
}
