import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:intl/intl.dart' as intl;
import 'package:provider/provider.dart';
import 'package:tapsalon/models/places_models/place.dart';
import 'package:tapsalon/provider/app_theme.dart';
import 'package:tapsalon/widget/en_to_ar_number_convertor.dart';

class PlaceLocationScreen extends StatefulWidget {
  static const routeName = '/PlaceLocationScreen';

  @override
  _PlaceLocationScreenState createState() => _PlaceLocationScreenState();
}

class _PlaceLocationScreenState extends State<PlaceLocationScreen>
    with TickerProviderStateMixin {
  bool _isInit = true;
  var _isLoading = false;

  Completer<GoogleMapController> _controller = Completer();
  GoogleMapController myController;
  static const LatLng _center = const LatLng(38.074065, 46.312711);

  final Set<Marker> _markers = {};

  LatLng _lastMapPosition = _center;

  MapType _currentMapType = MapType.normal;

  double speed;

  AnimationController _animationController;
  Animation<Offset> _slideAnimation;
  Animation<double> _opacityAnimation;

  BitmapDescriptor salonBitmapDescriptor = BitmapDescriptor.defaultMarker;
  BitmapDescriptor gymBitmapDescriptor = BitmapDescriptor.defaultMarker;
  BitmapDescriptor entBitmapDescriptor = BitmapDescriptor.defaultMarker;

  Animation<double> _animation;
  AnimationController _FBanimationController;

  Place selectedPlace;

  @override
  void didChangeDependencies() {
    if (_isInit) {
      searchItem();
      _lastMapPosition =
          LatLng(selectedPlace.latitude, selectedPlace.longitude);
    }
    _isInit = false;
    super.didChangeDependencies();
  }

  Future<void> searchItem() async {
    final Map arguments = ModalRoute.of(context).settings.arguments as Map;
    selectedPlace = arguments != null ? arguments['place'] : Place();
    _onAddMarker(selectedPlace);
    changePick(selectedPlace);
  }

  Future<void> changePick(Place placeInSearch) async {
    setState(() {});
    selectedPlace = placeInSearch;

    _animationController.forward();
    setState(() {});
  }

  void _onAddMarker(Place place) async {
    _markers.clear();
    print(place.latitude);
    print(place.longitude);
    var latLng = LatLng(place.latitude, place.longitude);
    var pinLocationIcon;
    if (place.placeType.id == 1) {
      pinLocationIcon = pinLocationIconSalon;
    } else if (place.placeType.id == 2) {
      pinLocationIcon = pinLocationIconEnt;
    } else if (place.placeType.id == 3) {
      pinLocationIcon = pinLocationIconGym;
    } else {
      pinLocationIcon = pinLocationIconSalon;
    }

    _markers.add(Marker(
      markerId: MarkerId(place.id.toString()),
      onTap: () {
        changePick(place);
      },
      infoWindow: InfoWindow(
        title: place.name,
      ),
      position: latLng,
      icon: pinLocationIcon,
    ));
  }


  void _onCameraMove(CameraPosition position) {
    _lastMapPosition = position.target;
  }

  void _onMapCreated(GoogleMapController controller) {
    myController = controller;
    _controller.complete(controller);
  }

  Geolocator _geolocator;
  Position _position;

  void checkPermission() {
    _geolocator.checkGeolocationPermissionStatus().then((status) {
      print('status: $status');
    });
    _geolocator
        .checkGeolocationPermissionStatus(
            locationPermission: GeolocationPermission.locationAlways)
        .then((status) {
      print('always status: $status');
    });
    _geolocator.checkGeolocationPermissionStatus(
        locationPermission: GeolocationPermission.locationWhenInUse)
      ..then((status) {
        print('whenInUse status: $status');
      });
  }

  BitmapDescriptor pinLocationIconSalon;
  BitmapDescriptor pinLocationIconEnt;
  BitmapDescriptor pinLocationIconGym;

  void setCustomMapPin() async {
    pinLocationIconSalon = await BitmapDescriptor.fromAssetImage(
        ImageConfiguration(
          devicePixelRatio: 2.5,
        ),
        'assets/images/marker_ic_1_v1.png',
        mipmaps: true);
    pinLocationIconEnt = await BitmapDescriptor.fromAssetImage(
        ImageConfiguration(
          devicePixelRatio: 2.5,
        ),
        'assets/images/marker_ic_2_v1.png',
        mipmaps: true);
    pinLocationIconGym = await BitmapDescriptor.fromAssetImage(
        ImageConfiguration(
          devicePixelRatio: 2.5,
        ),
        'assets/images/marker_ic_3_v1.png',
        mipmaps: true);
  }

  @override
  void initState() {
    super.initState();
    _FBanimationController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 260),
    );

    final curvedAnimation = CurvedAnimation(
        curve: Curves.easeInOut, parent: _FBanimationController);
    _animation = Tween<double>(begin: 0, end: 1).animate(curvedAnimation);

    _animationController = AnimationController(
      vsync: this,
      duration: Duration(
        milliseconds: 600,
      ),
    );

    _slideAnimation = Tween<Offset>(
      begin: Offset(3, 0),
      end: Offset(0, 0),
    ).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Curves.fastOutSlowIn,
      ),
    );
    _opacityAnimation = Tween(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Curves.easeIn,
      ),
    );
    _geolocator = Geolocator();
    LocationOptions locationOptions =
        LocationOptions(accuracy: LocationAccuracy.high, distanceFilter: 1);

    checkPermission();

    _geolocator.getPositionStream(locationOptions).listen((Position position) {
      _position = position;
    });
    setCustomMapPin();
  }


  @override
  Widget build(BuildContext context) {
    double deviceHeight = MediaQuery.of(context).size.height;
    double deviceWidth = MediaQuery.of(context).size.width;
    var currencyFormat = intl.NumberFormat.decimalPattern();

    var textScaleFactor = MediaQuery.of(context).textScaleFactor;
    return Directionality(
      textDirection: TextDirection.ltr,
      child: Scaffold(
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
        body: Directionality(
          textDirection: TextDirection.rtl,
          child: _isLoading
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
                    Column(
                      children: [
                        Expanded(
                          child: GoogleMap(
                            onMapCreated: _onMapCreated,
                            initialCameraPosition: CameraPosition(
                              target: _lastMapPosition,
                              zoom: 11.0,
                            ),
                            mapType: _currentMapType,
                            markers: _markers,
                            onCameraMove: _onCameraMove,
                            myLocationEnabled: true,
                            compassEnabled: true,
                            scrollGesturesEnabled: true,
                            mapToolbarEnabled: true,
                            myLocationButtonEnabled: true,
                            zoomGesturesEnabled: true,
                          ),
                        ),
                        Container(
                          height: deviceWidth * 0.5,
                          child: AnimatedContainer(
                            duration: _animationController.duration,
                            curve: Curves.easeIn,
                            child: FadeTransition(
                              opacity: _opacityAnimation,
                              child: SlideTransition(
                                position: _slideAnimation,
                                child: LayoutBuilder(
                                  builder: (cxt, constraint) => Container(
                                    decoration: BoxDecoration(
                                        color: AppTheme.white,
                                        borderRadius: BorderRadius.only(
                                          topRight: Radius.circular(15),
                                          topLeft: Radius.circular(15),
                                        )),
                                    height: deviceHeight * 0.2,
                                    width: deviceWidth * 0.9,
                                    child: Padding(
                                      padding: const EdgeInsets.all(10.0),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: <Widget>[
                                          Expanded(
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.start,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.center,
                                              children: <Widget>[
                                                Expanded(
                                                  flex: 8,
                                                  child: Padding(
                                                    padding:
                                                        const EdgeInsets.only(
                                                            right: 5.0),
                                                    child: Text(
                                                      selectedPlace.name,
                                                      overflow:
                                                          TextOverflow.ellipsis,
                                                      textAlign:
                                                          TextAlign.right,
                                                      maxLines: 1,
                                                      style: TextStyle(
                                                        fontFamily: 'Iransans',
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        fontSize:
                                                            textScaleFactor *
                                                                16.0,
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                                Expanded(
                                                  flex: 2,
                                                  child: Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment.end,
                                                    children: <Widget>[
                                                      Icon(
                                                        Icons.star,
                                                        color:
                                                            AppTheme.iconColor,
                                                        size: 25,
                                                      ),
                                                      Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                .only(
                                                          right: 5,
                                                          top: 5,
                                                        ),
                                                        child: Text(
                                                          EnArConvertor()
                                                              .replaceArNumber(
                                                            selectedPlace.rate
                                                                .toString(),
                                                          ),
                                                          textAlign:
                                                              TextAlign.right,
                                                          overflow: TextOverflow
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
                                              ],
                                            ),
                                          ),
                                          Expanded(
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.start,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.center,
                                              children: <Widget>[
                                                Expanded(
                                                  flex: 8,
                                                  child: Padding(
                                                    padding:
                                                        const EdgeInsets.only(
                                                            right: 5.0),
                                                    child: Container(
                                                      width:
                                                          constraint.minWidth *
                                                              0.7,
                                                      child: Wrap(
                                                        children:
                                                            selectedPlace.fields
                                                                .map(
                                                                  (e) =>
                                                                      ChangeNotifierProvider
                                                                          .value(
                                                                    value: e,
                                                                    child: Text(
                                                                      selectedPlace.fields.indexOf(e) <
                                                                              (selectedPlace.fields.length -
                                                                                  1)
                                                                          ? (e.name +
                                                                              ' ،')
                                                                          : e.name,
                                                                      style:
                                                                          TextStyle(
                                                                        fontFamily:
                                                                            'Iransans',
                                                                        color: AppTheme
                                                                            .grey,
                                                                        fontSize:
                                                                            textScaleFactor *
                                                                                15.0,
                                                                      ),
                                                                      textAlign:
                                                                          TextAlign
                                                                              .center,
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
                                                  child: Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment.end,
                                                    children: <Widget>[
                                                      Text(
                                                        selectedPlace.price !=
                                                                null
                                                            ? EnArConvertor()
                                                                .replaceArNumber(currencyFormat
                                                                    .format(double.parse(
                                                                        selectedPlace
                                                                            .price
                                                                            .toString()))
                                                                    .toString())
                                                                .toString()
                                                            : EnArConvertor()
                                                                .replaceArNumber(
                                                                    '0'),
                                                        style: TextStyle(
                                                          color: AppTheme.black,
                                                          fontFamily:
                                                              'Iransans',
                                                          fontSize:
                                                              textScaleFactor *
                                                                  18.0,
                                                        ),
                                                      ),
                                                      Text(
                                                        'هزار \n تومان',
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
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                          Expanded(
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.start,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.center,
                                              children: <Widget>[
                                                Padding(
                                                  padding:
                                                      const EdgeInsets.only(
                                                          left: 3.0,
                                                          top: 4,
                                                          bottom: 5),
                                                  child: Icon(
                                                    Icons.location_on,
                                                    color: AppTheme.iconColor,
                                                    size: 25,
                                                  ),
                                                ),
                                                Expanded(
                                                  child: Padding(
                                                    padding:
                                                        const EdgeInsets.only(
                                                            left: 3.0,
                                                            top: 4,
                                                            bottom: 1),
                                                    child: Text(
                                                      selectedPlace.address,
                                                      textAlign:
                                                          TextAlign.right,
                                                      overflow:
                                                          TextOverflow.ellipsis,
                                                      maxLines: 1,
                                                      style: TextStyle(
                                                        fontFamily: 'Iransans',
                                                        color: AppTheme.grey,
                                                        fontSize:
                                                            textScaleFactor *
                                                                15.0,
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
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    Positioned(
                      top: 0,
                      bottom: 0,
                      left: 0,
                      right: 0,
                      child: Align(
                        alignment: Alignment.center,
                        child: _isLoading
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
                            : Container(),
                      ),
                    ),
                  ],
                ),
        ),
      ),
    );
  }
}
