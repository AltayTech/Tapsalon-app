import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:smooth_star_rating/smooth_star_rating.dart';

import '../provider/app_theme.dart';

import '../models/favorite.dart';
import '../provider/complexes.dart';
import '../screen/complex_detail/complex_detail_screen.dart';

class FavoriteComplexItem extends StatelessWidget {
  final Favorite loadedComplex;

  FavoriteComplexItem({this.loadedComplex});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraint) => InkWell(
        onTap: () {
          Navigator.of(context)
              .pushNamed(ComplexDetailScreen.routeName, arguments: {
            'complexId': loadedComplex.complex.id,
            'title': loadedComplex.complex.name,
            'imageUrl': loadedComplex.complex.image.url.medium,
            'stars': loadedComplex.complex.stars.toString()
          });
        },
        child: Stack(
          children: <Widget>[
            ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: Card(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Container(
                      width: double.infinity,
                      height: constraint.maxHeight * 0.5,
                      child: FadeInImage(
                        placeholder:
                            AssetImage('assets/images/tapsalon_icon_200.png'),
                        image: NetworkImage(
                            loadedComplex.complex.image.url.toString()),
                        fit: BoxFit.cover,
                      ),
                    ),
                    SizedBox(
                      width: double.infinity,
                      height: constraint.maxHeight * 0.05,
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      child: Container(
                        height: constraint.maxHeight * 0.1,
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Container(
                              width: constraint.maxWidth * 0.6,
                              child: Text(
                                loadedComplex.complex.name != null
                                    ? loadedComplex.complex.name
                                    : '',
                                textAlign: TextAlign.right,
                                overflow: TextOverflow.ellipsis,
                                maxLines: 1,
                                style: TextStyle(
                                  fontFamily: 'Iransans',
                                  fontSize:
                                      MediaQuery.of(context).textScaleFactor *
                                          12.0,
                                ),
                              ),
                            ),
                            Container(
                              width: constraint.maxWidth * 0.3,
                              child: Directionality(
                                textDirection: TextDirection.ltr,
                                child: SmoothStarRating(
                                    allowHalfRating: false,
                                    onRatingChanged: (v) {},
                                    starCount: 5,
                                    rating: loadedComplex.complex.stars,
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
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      child: Container(
                        width: constraint.minWidth,
                        height: constraint.maxHeight * 0.1,
                        child: ListView.builder(
//                        shrinkWrap: true,
                          scrollDirection: Axis.horizontal,
                          itemCount: loadedComplex.complex.fields.length,
                          itemBuilder: (ctx, i) => ChangeNotifierProvider.value(
                              value: loadedComplex.complex.fields[i],
                              child: Chip(
                                padding: const EdgeInsets.all(0),
                                label: Center(
                                  child: Text(
                                    i <
                                            (loadedComplex
                                                    .complex.fields.length -
                                                1)
                                        ? (loadedComplex
                                                .complex.fields[i].name +
                                            ',')
                                        : loadedComplex.complex.fields[i].name,
                                    style: TextStyle(
                                      fontFamily: 'Iransans',
                                      color: Colors.black54,
                                      fontSize: MediaQuery.of(context)
                                              .textScaleFactor *
                                          10.0,
                                    ),
                                    textAlign: TextAlign.center,
                                  ),
                                ),
                              )

//                            Container(
//                              child: Padding(
//                                padding: const EdgeInsets.all(3.0),
//                                child:
//                              ),
//                            ),
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
                        fontSize: MediaQuery.of(context).textScaleFactor * 11.0,
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
                        fontSize: MediaQuery.of(context).textScaleFactor * 11.0,
                      ),
                    ),
                  ),
                ),
              ),
            ),
            Positioned(
              top: constraint.maxHeight * 0.030,
              right: constraint.maxHeight * 0.030,
              child: InkWell(
                onTap: () async {
                  await Provider.of<Complexes>(context, listen: false)
                      .sendLike(loadedComplex.complex.id);
                },
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(5),
                  child: Container(
                    color: Colors.white.withOpacity(0.3),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          vertical: 4, horizontal: 3),
                      child: Icon(
                        Icons.clear,
                        color: Colors.black,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
