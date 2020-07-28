import 'package:carousel_slider/carousel_options.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:intl/intl.dart' as intl;
import 'package:provider/provider.dart';
import 'package:tapsalon/models/image.dart';
import 'package:tapsalon/models/places_models/place.dart';
import 'package:tapsalon/provider/auth.dart';
import 'package:tapsalon/screen/place_detail/place_detail_timing_screen.dart';
import 'package:tapsalon/screen/place_detail/place_location_screen.dart';
import 'package:tapsalon/widget/dialogs/custom_dialog_enter.dart';
import 'package:tapsalon/widget/dialogs/custom_dialog_show_picture.dart';
import 'package:tapsalon/widget/en_to_ar_number_convertor.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../provider/app_theme.dart';
import '../../provider/places.dart';
import '../../widget/main_drawer.dart';
import 'place_detail_comments_screen.dart';

class PlaceDetailScreen extends StatefulWidget {
  static const routeName = '/PlaceDetailScreen';

  @override
  _PlaceDetailScreenState createState() => _PlaceDetailScreenState();
}

class _PlaceDetailScreenState extends State<PlaceDetailScreen>
    with SingleTickerProviderStateMixin {
  var _isLoading;
  bool _isInit = true;

  Place loadedPlace;

  var title;

  var imageUrl;

  String stars;

  bool isLike = false;
  int _current = 0;

  List<ImageObj> gallery = [];

  @override
  void dispose() {
    super.dispose();
  }

  @override
  void didChangeDependencies() async {
    if (_isInit) {
      ImageObj defaultImage =
          Provider.of<Places>(context, listen: false).defaultImage;
      await searchItems();

      if (loadedPlace.gallery.length < 1) {
        gallery.clear();
        gallery.add(defaultImage);
      } else {
        gallery = loadedPlace.gallery;
      }

      await Provider.of<Places>(context, listen: false)
          .retrieveLikes(loadedPlace.id);

      isLike = Provider.of<Places>(context, listen: false).isLiked;
      setState(() {});
    }
    _isInit = false;
    super.didChangeDependencies();
  }

  Future<void> searchItems() async {
    setState(() {
      _isLoading = true;
    });
    final Map arguments = ModalRoute.of(context).settings.arguments as Map;
    final placeId = arguments != null ? arguments['placeId'] : 0;
    title = arguments != null ? arguments['name'] : '';
    imageUrl = arguments != null ? arguments['imageUrl'] : '';
    stars = arguments != null ? arguments['stars'] : '';

    await Provider.of<Places>(context, listen: false).retrievePlace(placeId);
    loadedPlace = Provider.of<Places>(context, listen: false).itemPlace;
    setState(() {
      _isLoading = false;
    });
  }

  void _showLoginDialog() {
    showDialog(
        context: context,
        builder: (ctx) => CustomDialogEnter(
              title: 'ورود',
              buttonText: 'صفحه ورود ',
              description: 'برای ادامه باید وارد شوید',
            ));
  }

  void _showImageDialog() {
    showDialog(
        context: context,
        builder: (ctx) => CustomDialogShowPicture(
              image: gallery[_current],
            ));
  }

  _launchURL(String url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  @override
  Widget build(BuildContext context) {
    double deviceHeight = MediaQuery.of(context).size.height;
    double deviceWidth = MediaQuery.of(context).size.width;
    var textScaleFactor = MediaQuery.of(context).textScaleFactor;
    var currencyFormat = intl.NumberFormat.decimalPattern();
    bool isLogin = Provider.of<Auth>(context, listen: false).isAuth;
    return Scaffold(
      backgroundColor: AppTheme.bg,
      appBar: AppBar(
        title: Text(
          '',
          style: TextStyle(
            color: Colors.blue,
            fontFamily: 'Iransans',
            fontSize: textScaleFactor * 18.0,
          ),
          textAlign: TextAlign.center,
        ),
        elevation: 0,
        centerTitle: true,
        backgroundColor: AppTheme.appBarColor,
        iconTheme: new IconThemeData(color: AppTheme.appBarIconColor),
      ),
      body: _isLoading
          ? SpinKitFadingCircle(
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
            )
          : Stack(
              children: <Widget>[
                Directionality(
                  textDirection: TextDirection.rtl,
                  child: SingleChildScrollView(
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        children: <Widget>[
                          GestureDetector(
                            onTap: () {
                              _showImageDialog();
                            },
                            child: Container(
                              height: deviceWidth * 0.6,
                              child: Stack(
                                children: <Widget>[
                                  Container(
                                    decoration: BoxDecoration(
                                        color: AppTheme.bg,
                                        border: Border.all(
                                            width: 5, color: AppTheme.bg),
                                        borderRadius:
                                            BorderRadius.circular(10)),
                                    child: CarouselSlider(
                                      options: CarouselOptions(
                                        viewportFraction: 1.0,
                                        initialPage: 0,
                                        enableInfiniteScroll: true,
                                        reverse: false,
                                        autoPlay:
                                            gallery.length == 1 ? true : false,
                                        height: double.infinity,
                                        autoPlayInterval: Duration(seconds: 5),
                                        autoPlayAnimationDuration:
                                            Duration(milliseconds: 800),
                                        enlargeCenterPage: true,
                                        scrollDirection: Axis.horizontal,
                                        onPageChanged: (index, _) {
                                          _current = index;
                                          setState(() {});
                                        },
                                        autoPlayCurve: Curves.fastOutSlowIn,
                                      ),
                                      items: gallery.map((gallery) {
                                        return Builder(
                                          builder: (BuildContext context) {
                                            return Container(
                                              width: deviceWidth,
                                              child: ClipRRect(
                                                borderRadius:
                                                    BorderRadius.circular(10),
                                                child: FadeInImage(

                                                  placeholder: AssetImage(
                                                      'assets/images/circle.gif'),
                                                  image: gallery.url.large
                                                          .startsWith(
                                                              'assets/images')
                                                      ? AssetImage(
                                                          gallery.url.medium)
                                                      : NetworkImage(
                                                          gallery.url.medium),
                                                  fit: BoxFit.cover,
                                                ),
                                              ),
                                            );
                                          },
                                        );
                                      }).toList(),
                                    ),
                                  ),
                                  Positioned(
                                    bottom: 0,
                                    left: 0.0,
                                    right: 0.0,
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: gallery.map<Widget>(
                                        (index) {
                                          return Container(
                                            width: 10.0,
                                            height: 10.0,
                                            margin: EdgeInsets.symmetric(
                                                vertical: 20.0,
                                                horizontal: 2.0),
                                            decoration: BoxDecoration(
                                              shape: BoxShape.circle,
                                              border: Border.all(
                                                  color: AppTheme.h1,
                                                  width: 0.4),
                                              color: _current ==
                                                      gallery.indexOf(index)
                                                  ? AppTheme.iconColor
                                                  : AppTheme.bg,
                                            ),
                                          );
                                        },
                                      ).toList(),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          Container(
                            decoration: BoxDecoration(
                                color: AppTheme.white,
                                border:
                                    Border.all(width: 5, color: AppTheme.bg),
                                borderRadius: BorderRadius.circular(10)),
                            child: Padding(
                              padding: EdgeInsets.all(16),
                              child: Column(
                                children: <Widget>[
                                  Container(
                                    child: Stack(
                                      children: <Widget>[
                                        Positioned(
                                          top: 12,
                                          right: 0,
                                          child: InkWell(
                                            child: Icon(
                                              Icons.favorite,
                                              color: isLike
                                                  ? Colors.red
                                                  : AppTheme.grey,
                                            ),
                                            onTap: () async {
                                              if (isLogin) {
                                                bool isLiked = await Provider
                                                        .of<Places>(context,
                                                            listen: false)
                                                    .sendLike(loadedPlace.id);
                                                isLiked
                                                    ? isLike
                                                        ? isLike = false
                                                        : isLike = true
                                                    : isLike = isLike;
                                                print(isLike.toString());
                                                setState(() {});
                                              } else {
                                                _showLoginDialog();
                                              }
                                            },
                                          ),
                                        ),
                                        Center(
                                          child: Padding(
                                            padding: const EdgeInsets.only(
                                              top: 10,
                                            ),
                                            child: Text(
                                              title.isNotEmpty ? title : '',
                                              style: TextStyle(
                                                  fontFamily: 'Iransans',
                                                  fontSize:
                                                      textScaleFactor * 18.0,
                                                  fontWeight: FontWeight.w600),
                                              textAlign: TextAlign.center,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(
                                        top: 15, bottom: 15),
                                    child: Text(
                                      loadedPlace.address,
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                        fontFamily: 'Iransans',
                                        color: AppTheme.grey,
                                        fontSize: textScaleFactor * 14.0,
                                      ),
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(
                                        bottom: 8, top: 8),
                                    child: Container(
                                      child: Row(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        children: <Widget>[
                                          Expanded(
                                            child: Wrap(
                                              direction: Axis.horizontal,
                                              crossAxisAlignment:
                                                  WrapCrossAlignment.center,
                                              children: <Widget>[
                                                Text(
                                                  'هزینه: ',
                                                  textAlign: TextAlign.center,
                                                  style: TextStyle(
                                                    fontFamily: 'Iransans',
                                                    color: AppTheme.grey,
                                                    fontSize:
                                                        textScaleFactor * 14.0,
                                                  ),
                                                ),
                                                loadedPlace.price != null &&
                                                        loadedPlace.price != 0
                                                    ? Container(
                                                        child: Padding(
                                                          padding:
                                                              const EdgeInsets
                                                                      .symmetric(
                                                                  vertical: 4,
                                                                  horizontal:
                                                                      2),
                                                          child: Text(
                                                            loadedPlace.price !=
                                                                    null
                                                                ? EnArConvertor()
                                                                    .replaceArNumber(currencyFormat
                                                                        .format(double.parse(loadedPlace
                                                                            .price
                                                                            .toString()))
                                                                        .toString())
                                                                    .toString()
                                                                : EnArConvertor()
                                                                    .replaceArNumber(
                                                                        '0'),
                                                            style: TextStyle(
                                                              color: AppTheme
                                                                  .black,
                                                              fontFamily:
                                                                  'Iransans',
                                                              fontSize:
                                                                  textScaleFactor *
                                                                      16.0,
                                                            ),
                                                          ),
                                                        ),
                                                      )
                                                    : Text(
                                                        ' ثبت نشده',
                                                        textAlign:
                                                            TextAlign.center,
                                                        style: TextStyle(
                                                          fontFamily:
                                                              'Iransans',
                                                          color: AppTheme.grey,
                                                          fontSize:
                                                              textScaleFactor *
                                                                  12.0,
                                                        ),
                                                      ),
                                                loadedPlace.price != null &&
                                                        loadedPlace.price != 0
                                                    ? Text(
                                                        'هزار\n تومان',
                                                        textAlign:
                                                            TextAlign.center,
                                                        style: TextStyle(
                                                          fontFamily:
                                                              'Iransans',
                                                          color: AppTheme.grey,
                                                          fontSize:
                                                              textScaleFactor *
                                                                  10.0,
                                                        ),
                                                      )
                                                    : Text(''),
                                              ],
                                            ),
                                          ),
                                          Expanded(
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: <Widget>[
                                                Icon(
                                                  Icons.star,
                                                  color: AppTheme.iconColor,
                                                  size: 25,
                                                ),
                                                Padding(
                                                  padding:
                                                      const EdgeInsets.only(
                                                    right: 5,
                                                    top: 5,
                                                  ),
                                                  child: Text(
                                                    EnArConvertor()
                                                        .replaceArNumber(
                                                      loadedPlace.rate
                                                          .toString(),
                                                    ),
                                                    textAlign: TextAlign.right,
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                    maxLines: 1,
                                                    style: TextStyle(
                                                      fontFamily: 'Iransans',
                                                      color: AppTheme.grey,
                                                      fontSize:
                                                          textScaleFactor *
                                                              16.0,
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                          Expanded(
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.end,
                                              children: <Widget>[
                                                Icon(
                                                  Icons.comment,
                                                  color: AppTheme.iconColor,
                                                  size: 25,
                                                ),
                                                Padding(
                                                  padding:
                                                      const EdgeInsets.only(
                                                          right: 5,
                                                          top: 4,
                                                          bottom: 1),
                                                  child: Text(
                                                    EnArConvertor()
                                                        .replaceArNumber(
                                                      loadedPlace.comments_count
                                                          .toString(),
                                                    ),
                                                    textAlign: TextAlign.right,
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                    maxLines: 1,
                                                    style: TextStyle(
                                                      fontFamily: 'Iransans',
                                                      color: AppTheme.grey,
                                                      fontSize:
                                                          textScaleFactor *
                                                              16.0,
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
                                  Padding(
                                    padding: const EdgeInsets.only(
                                        bottom: 8, top: 8),
                                    child: Container(
                                      decoration: BoxDecoration(
                                          color: AppTheme.white,
                                          border: Border.all(
                                              width: 2, color: AppTheme.white),
                                          borderRadius:
                                              BorderRadius.circular(10)),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        children: <Widget>[
                                          Padding(
                                            padding: const EdgeInsets.only(
                                              top: 6,
                                            ),
                                            child: Text(
                                              'رشته ها',
                                              style: TextStyle(
                                                fontFamily: 'Iransans',
                                                color: AppTheme.grey,
                                                fontSize:
                                                    textScaleFactor * 14.0,
                                              ),
                                            ),
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.all(6.0),
                                            child: Wrap(
                                              crossAxisAlignment:
                                                  WrapCrossAlignment.center,
                                              alignment: WrapAlignment.center,
                                              children: loadedPlace.fields
                                                  .map((e) =>
                                                      ChangeNotifierProvider
                                                          .value(
                                                        value: e,
                                                        child: Text(
                                                          loadedPlace.fields
                                                                      .indexOf(
                                                                          e) <
                                                                  (loadedPlace
                                                                          .fields
                                                                          .length -
                                                                      1)
                                                              ? (e.name + '، ')
                                                              : e.name + ' ',
                                                          style: TextStyle(
                                                              fontFamily:
                                                                  'Iransans',
                                                              color:
                                                                  Colors.black,
                                                              fontSize:
                                                                  textScaleFactor *
                                                                      14.0,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w500),
                                                          textAlign:
                                                              TextAlign.center,
                                                        ),
                                                      ))
                                                  .toList(),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(
                                        bottom: 8, top: 8),
                                    child: Container(
                                      decoration: BoxDecoration(
                                          color: AppTheme.white,
                                          border: Border.all(
                                              width: 2, color: AppTheme.white),
                                          borderRadius:
                                              BorderRadius.circular(10)),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        children: <Widget>[
                                          Padding(
                                            padding: const EdgeInsets.only(
                                              top: 6,
                                            ),
                                            child: Text(
                                              'امکانات',
                                              style: TextStyle(
                                                fontFamily: 'Iransans',
                                                color: AppTheme.grey,
                                                fontSize:
                                                    textScaleFactor * 14.0,
                                              ),
                                            ),
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.all(6.0),
                                            child: Wrap(
                                              crossAxisAlignment:
                                                  WrapCrossAlignment.center,
                                              alignment: WrapAlignment.center,
                                              children: loadedPlace.facilities
                                                  .map((e) =>
                                                      ChangeNotifierProvider
                                                          .value(
                                                        value: e,
                                                        child: Text(
                                                          loadedPlace.facilities
                                                                      .indexOf(
                                                                          e) <
                                                                  (loadedPlace
                                                                          .facilities
                                                                          .length -
                                                                      1)
                                                              ? (e.name + '، ')
                                                              : e.name + ' ',
                                                          style: TextStyle(
                                                            fontFamily:
                                                                'Iransans',
                                                            color: Colors.black,
                                                            fontSize:
                                                                textScaleFactor *
                                                                    14.0,
                                                            fontWeight:
                                                                FontWeight.w500,
                                                          ),
                                                          textAlign:
                                                              TextAlign.center,
                                                        ),
                                                      ))
                                                  .toList(),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(
                                        bottom: 8, top: 12),
                                    child: Container(
                                      child: Row(
                                        children: <Widget>[
                                          loadedPlace.mobile != ''
                                              ? Expanded(
                                                  child: InkWell(
                                                    onTap: () {
                                                      _launchURL(
                                                          'tel:${loadedPlace.mobile}');
                                                    },
                                                    child: Row(
                                                      children: <Widget>[
                                                        Padding(
                                                          padding:
                                                              const EdgeInsets
                                                                      .only(
                                                                  right: 1,
                                                                  left: 3.0,
                                                                  top: 1,
                                                                  bottom: 4),
                                                          child: Icon(
                                                            Icons.phone_android,
                                                            color: AppTheme
                                                                .iconColor,
                                                            size: 25,
                                                          ),
                                                        ),
                                                        Padding(
                                                          padding:
                                                              const EdgeInsets
                                                                      .only(
                                                                  right: 5,
                                                                  left: 10,
                                                                  top: 4,
                                                                  bottom: 1),
                                                          child: Text(
                                                            EnArConvertor()
                                                                .replaceArNumber(
                                                              loadedPlace
                                                                  .mobile,
                                                            ),
                                                            textAlign:
                                                                TextAlign.right,
                                                            overflow:
                                                                TextOverflow
                                                                    .ellipsis,
                                                            maxLines: 1,
                                                            style: TextStyle(
                                                              fontFamily:
                                                                  'Iransans',
                                                              color:
                                                                  AppTheme.grey,
                                                              fontSize:
                                                                  textScaleFactor *
                                                                      16.0,
                                                            ),
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                )
                                              : Container(),
                                          loadedPlace.phone != ''
                                              ? Expanded(
                                                  child: InkWell(
                                                    onTap: () {
                                                      _launchURL(
                                                          'tel:${loadedPlace.phone}');
                                                    },
                                                    child: Row(
                                                      children: <Widget>[
                                                        Padding(
                                                          padding:
                                                              const EdgeInsets
                                                                      .only(
                                                                  right: 1,
                                                                  left: 3.0,
                                                                  top: 1,
                                                                  bottom: 4),
                                                          child: Icon(
                                                            Icons.phone,
                                                            color: AppTheme
                                                                .iconColor,
                                                            size: 25,
                                                          ),
                                                        ),
                                                        Padding(
                                                          padding:
                                                              const EdgeInsets
                                                                      .only(
                                                                  right: 5,
                                                                  left: 10,
                                                                  top: 4,
                                                                  bottom: 1),
                                                          child: Text(
                                                            EnArConvertor()
                                                                .replaceArNumber(
                                                              loadedPlace.phone,
                                                            ),
                                                            textAlign:
                                                                TextAlign.right,
                                                            overflow:
                                                                TextOverflow
                                                                    .ellipsis,
                                                            maxLines: 1,
                                                            style: TextStyle(
                                                              fontFamily:
                                                                  'Iransans',
                                                              color:
                                                                  AppTheme.grey,
                                                              fontSize:
                                                                  textScaleFactor *
                                                                      16.0,
                                                            ),
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                )
                                              : Container(),
                                        ],
                                      ),
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(
                                        bottom: 8, top: 8),
                                    child: InkWell(
                                      onTap: () {
                                        Navigator.of(context).pushNamed(
                                          PlaceDetailTimingScreen.routeName,
                                          arguments: {
                                            'placeId': loadedPlace.id,
                                            'name': loadedPlace.name,
                                            'imageUrl':
                                                loadedPlace.image.url.medium,
                                            'stars': loadedPlace.rate.toString()
                                          },
                                        );
                                      },
                                      child: Container(
                                        height: deviceWidth * 0.13,
                                        decoration: BoxDecoration(
                                          boxShadow: [
                                            BoxShadow(
                                              color:
                                                  Colors.grey.withOpacity(0.5),
                                              blurRadius: 10.0,
                                              // has the effect of softening the shadow
                                              spreadRadius: 1,
                                              // has the effect of extending the shadow
                                              offset: Offset(
                                                1.0, // horizontal, move right 10
                                                1.0, // vertical, move down 10
                                              ),
                                            )
                                          ],
                                          color: Colors.blue,
                                          borderRadius:
                                              BorderRadius.circular(5),
                                        ),
                                        child: Center(
                                          child: Padding(
                                            padding: const EdgeInsets.all(4.0),
                                            child: Text(
                                              'مشاهده تایم ها',
                                              style: AppTheme
                                                  .textTheme.headline6
                                                  .copyWith(height: 2)
                                                  .copyWith(
                                                      color: Colors.white),
//                                            style: TextStyle(
//                                              color: Colors.white,
//                                              fontFamily: 'Iransans',
//                                              fontSize: textScaleFactor * 15.0,
//                                              fontWeight: FontWeight.w600,
//                                            ),

                                              textAlign: TextAlign.center,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(
                                        bottom: 16, top: 8),
                                    child: Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: <Widget>[
                                        InkWell(
                                          onTap: () {
                                            Navigator.of(context).pushNamed(
                                              PlaceLocationScreen.routeName,
                                              arguments: {
                                                'place': loadedPlace,
                                              },
                                            );
                                          },
                                          child: Row(
                                            children: <Widget>[
                                              Padding(
                                                padding: const EdgeInsets.only(
                                                    left: 3.0,
                                                    top: 1,
                                                    bottom: 4),
                                                child: Icon(
                                                  Icons.location_on,
                                                  color: AppTheme.iconColor,
                                                  size: 25,
                                                ),
                                              ),
                                              Padding(
                                                padding: const EdgeInsets.only(
                                                    right: 5,
                                                    left: 10,
                                                    top: 4,
                                                    bottom: 4),
                                                child: Text(
                                                  'نقشه',
                                                  textAlign: TextAlign.right,
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                  maxLines: 1,
                                                  style:
                                                      AppTheme.textTheme.button,

//                                                  style: TextStyle(
//                                                    fontFamily: 'Iransans',
//                                                    color: AppTheme.black,
//                                                    fontSize:
//                                                        textScaleFactor * 16.0,
//                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                        Spacer(),
                                        InkWell(
                                          onTap: () {
                                            Navigator.of(context).pushNamed(
                                              PlaceDetailCommentsScreen
                                                  .routeName,
                                              arguments: {
                                                'place': loadedPlace,
                                              },
                                            );
                                          },
                                          child: Row(
                                            children: <Widget>[
                                              Padding(
                                                padding: const EdgeInsets.only(
                                                    left: 3.0,
                                                    top: 1,
                                                    bottom: 4),
                                                child: Icon(
                                                  Icons.comment,
                                                  color: AppTheme.iconColor,
                                                  size: 25,
                                                ),
                                              ),
                                              Padding(
                                                padding: const EdgeInsets.only(
                                                    right: 5,
                                                    top: 4,
                                                    bottom: 1),
                                                child: Text(
                                                  'نظرات',
                                                  textAlign: TextAlign.right,
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                  maxLines: 1,
                                                  style: Theme.of(context)
                                                      .textTheme
                                                      .button,

//                                                  style: TextStyle(
//                                                    fontFamily: 'Iransans',
//                                                    color: AppTheme.black,
//                                                    fontSize:
//                                                        textScaleFactor * 16.0,
//                                                  ),
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
                          Container(
                            width: deviceWidth,
                            decoration: BoxDecoration(
                                color: AppTheme.white,
                                border:
                                    Border.all(width: 5, color: AppTheme.bg),
                                borderRadius: BorderRadius.circular(10)),
                            child: Padding(
                              padding: EdgeInsets.all(16),
                              child: Column(
                                children: <Widget>[
                                  Padding(
                                    padding: const EdgeInsets.only(
                                        bottom: 8.0, top: 16),
                                    child: Container(
                                      width: deviceWidth,
                                      child: Row(
                                        children: <Widget>[
                                          Icon(
                                            Icons.description,
                                            color: AppTheme.iconColor,
                                            size: 25,
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.only(
                                              right: 5,
                                              top: 5,
                                            ),
                                            child: Text(
                                              'درباره',
                                              textAlign: TextAlign.right,
                                              overflow: TextOverflow.ellipsis,
                                              maxLines: 1,
                                              style: TextStyle(
                                                fontFamily: 'Iransans',
                                                color: AppTheme.grey,
                                                fontSize:
                                                    textScaleFactor * 16.0,
                                              ),
                                            ),
                                          ),
                                          Spacer(),
                                        ],
                                      ),
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(
                                      bottom: 16.0,
                                    ),
                                    child: Container(
                                      width: deviceWidth,
                                      decoration: BoxDecoration(
                                          color: AppTheme.white,
                                          border: Border.all(
                                              width: 5, color: AppTheme.white),
                                          borderRadius:
                                              BorderRadius.circular(10)),
                                      child: Text(
                                        loadedPlace.about != ''
                                            ? EnArConvertor().replaceArNumber(
                                                loadedPlace.about)
                                            : 'توضیحی ارائه نشده است',
                                        style: AppTheme.textTheme.bodyText2
                                            .copyWith(height: 2),
                                        textAlign: TextAlign.justify,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                ),
//                _isImageShown
//                    ? GestureDetector(
//                        onTap: () =>
//                            setState(() => _isImageShown = !_isImageShown),
//                        child: Center(
//                          child: Hero(
//                            tag: loadedPlace.gallery[_current].url.medium,
//                            child: FadeInImage(
//                              placeholder: AssetImage('assets/images/circle.gif'),
//                              image: NetworkImage(
//                                  loadedPlace.gallery[_current].url.large),
//                              width: deviceWidth,
//                              height: deviceHeight * 0.9,
//                              fit: BoxFit.contain,
//                            ),
//                          ),
//                        ),
//                      )
//                    : SizedBox(),
              ],
            ),
      endDrawer: Theme(
        data: Theme.of(context).copyWith(
            // Set the transparency here
            canvasColor: Colors.white),
        child: MainDrawer(),
      ),
    );
  }
}
