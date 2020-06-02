import 'package:flutter/material.dart';
import 'package:smooth_star_rating/smooth_star_rating.dart';
import 'package:tapsalon/models/complex_search.dart';
import 'package:tapsalon/screen/complex_detail/complex_detail_screen.dart';

class MapItem extends StatelessWidget {
  ComplexSearch _complexSearch;

  MapItem(this._complexSearch);

  @override
  Widget build(BuildContext context) {
    double deviceHeight = MediaQuery.of(context).size.height;
    double deviceWidth = MediaQuery.of(context).size.width;
    var textScaleFactor = MediaQuery.of(context).textScaleFactor;
    return LayoutBuilder(
      builder: (context, constraint) => InkWell(
        onTap: () {
          Navigator.of(context).pushNamed(
            ComplexDetailScreen.routeName,
            arguments: {
              'complexId': _complexSearch.id,
              'title': _complexSearch.name,
              'imageUrl': _complexSearch.image.url.medium,
              'stars': _complexSearch.stars.toString(),
            },
          );
        },
        child: Container(
//          height: deviceHeight * 0.1,
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(50), color: Colors.white),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Container(
                width: constraint.maxWidth * 0.2,
                child: Icon(
                  Icons.location_on,
                  color: Colors.blue,
                  size: deviceHeight * 0.07,
                ),
              ),
              Container(
                width: constraint.maxWidth * 0.6,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    Text(
                      _complexSearch.name,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontFamily: 'Iransans',
                        color: Colors.black,
                        fontSize: MediaQuery.of(context).textScaleFactor * 11.0,
                      ),
                    ),
                    Text(
                      _complexSearch.region.name,
                      style: TextStyle(
                        fontFamily: 'Iransans',
                        color: Colors.black,
                        fontSize: MediaQuery.of(context).textScaleFactor * 11.0,
                      ),
                    ),
                    Container(
                      width: constraint.maxWidth * 0.3,
                      child: Directionality(
                        textDirection: TextDirection.ltr,
                        child: SmoothStarRating(
                            allowHalfRating: false,
                            onRated: (v) {},
                            starCount: 5,
                            rating: _complexSearch.stars,
                            size: constraint.maxWidth * 0.05,
                            color: Colors.green,
                            borderColor: Colors.green,
                            spacing: 0.0),
                      ),
                    )
                  ],
                ),
              ),
              Container(
                width: constraint.maxWidth * 0.2,
                height: constraint.maxHeight,
                decoration: BoxDecoration(
                    shape: BoxShape.circle,
//                                  borderRadius: BorderRadius.circular(50),
                    color: Colors.white),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(50),
                    child: FadeInImage(
                      placeholder:
                          AssetImage('assets/images/tapsalon_icon_200.png'),
                      image: NetworkImage(
                          _complexSearch.image.url.medium.toString()),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
