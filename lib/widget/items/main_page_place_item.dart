import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:tapsalon/models/places_models/place_in_search.dart';
import 'package:tapsalon/screen/place_detail/place_detail_screen.dart';

import '../../provider/app_theme.dart';
import '../en_to_ar_number_convertor.dart';

class MainPagePlaceItem extends StatelessWidget {
  final PlaceInSearch loadedPlace;

  MainPagePlaceItem({required this.loadedPlace});

  @override
  Widget build(BuildContext context) {
    double deviceHeight = MediaQuery.of(context).size.height;
    double deviceWidth = MediaQuery.of(context).size.width;
    double textScaleFactor = MediaQuery.of(context).textScaleFactor;

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
                    borderRadius: BorderRadius.all(Radius.circular(5))),
                child: Padding(
                  padding: const EdgeInsets.only(bottom: 3.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      ClipRRect(
                        borderRadius: BorderRadius.only(
                            topRight: Radius.circular(5),
                            topLeft: Radius.circular(5)),
                        child: Container(
                          height: constraint.maxHeight * 0.65,
                          width: constraint.maxWidth,
                          child: FadeInImage(
                            placeholder: AssetImage(
                                'assets/images/place_placeholder.jpeg'),
                            alignment: Alignment.center,
                            image: NetworkImage(
                                loadedPlace.image.url.medium.toString()),
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                      SizedBox(
                        height: constraint.maxHeight * 0.05,
                      ),
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 10),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Expanded(
                                flex: 9,
                                child: Text(
                                  loadedPlace.name,
                                  textAlign: TextAlign.right,
                                  overflow: TextOverflow.ellipsis,
                                  maxLines: 1,
                                  style: TextStyle(
                                    fontFamily: 'Iransans',
                                    fontWeight: FontWeight.w600,
                                    fontSize: textScaleFactor * 14.0,
                                  ),
                                ),
                              ),
//                              Expanded(
//                                flex: 3,
//                                child: Align(
//                                  alignment: Alignment.centerLeft,
//                                  child: Text(
//                                    EnArConvertor().replaceArNumber('20%'),
//                                    textAlign: TextAlign.right,
//                                    overflow: TextOverflow.ellipsis,
//                                    maxLines: 1,
//                                    style: TextStyle(
//                                      fontFamily: 'Iransans',
//                                      color: AppTheme.black,
//                                      fontSize: textScaleFactor * 14.0,
//                                    ),
//                                  ),
//                                ),
//                              ),
                            ],
                          ),
                        ),
                      ),
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.only(left: 10, right: 5),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: <Widget>[
                              Expanded(
                                flex: 9,
                                child: Row(
                                  children: <Widget>[
                                    Icon(
                                      Icons.location_on,
                                      color: AppTheme.iconColor,
                                      size: 20,
                                    ),
                                    Expanded(
                                      child: Padding(
                                        padding: const EdgeInsets.only(
                                            right: 5, top: 5),
                                        child: Text(
                                          loadedPlace.region.name,
                                          textAlign: TextAlign.right,
                                          overflow: TextOverflow.ellipsis,
                                          maxLines: 1,
                                          style: TextStyle(
                                            fontFamily: 'Iransans',
                                            color: AppTheme.grey,
                                            fontSize: textScaleFactor * 12.0,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              loadedPlace.rate != 0.0&&  loadedPlace.rate != 0?  Expanded(
                                flex: 3,
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: <Widget>[
                                    Icon(
                                      Icons.star,
                                      color: AppTheme.iconColor,
                                      size: 15,
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(
                                          right: 5, top: 5),
                                      child: Text(
                                        loadedPlace.rate != 0.0
                                            ? EnArConvertor().replaceArNumber(
                                                loadedPlace.rate.toString(),
                                              )
                                            : '--',
                                        textAlign: TextAlign.left,
                                        overflow: TextOverflow.ellipsis,
                                        maxLines: 1,
                                        style: TextStyle(
                                          fontFamily: 'Iransans',
                                          color: AppTheme.grey,
                                          fontSize: textScaleFactor * 12.0,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ):Container(),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
