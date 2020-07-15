import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:intl/intl.dart' as intl;
import 'package:provider/provider.dart';
import 'package:tapsalon/models/city.dart';
import 'package:tapsalon/models/places_models/place_in_search.dart';
import 'package:tapsalon/widget/en_to_ar_number_convertor.dart';
import 'package:tapsalon/widget/fancy_fab.dart';

import '../models/searchDetails.dart';
import '../provider/app_theme.dart';
import '../provider/cities.dart';
import '../provider/places.dart';
import '../widget/filter_drawer.dart';
import 'place_detail/place_detail_screen.dart';

class MapScreen extends StatefulWidget {
  static const routeName = '/MapScreen';

  @override
  _MapScreenState createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> with TickerProviderStateMixin {
  bool _isInit = true;
  bool _isInfoShow = false;
  var _isLoading;
  List<PlaceInSearch> loadedPlaces = [];
  List<PlaceInSearch> loadedPlacesToList = [];
  SearchDetails searchDetails;

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

  City selectedCity;

  PlaceInSearch selectedPlace;

  Animation<double> _animation;
  AnimationController _FBanimationController;

  @override
  void didChangeDependencies() {
    if (_isInit) {
      Provider.of<Places>(context, listen: false).searchBuilder();
      _tabController.index = 0;
      cleanFilter();
      try {
        selectedCity = Provider.of<Cities>(context, listen: false).selectedCity;
      } catch (error) {}
      _lastMapPosition = LatLng(selectedCity.latitude, selectedCity.longitude);
      retrieveItems();
    }
    _isInit = false;
    super.didChangeDependencies();
  }

  Future<void> cleanFilter() async {
    setState(() {
      _isLoading = true;
    });

    Provider.of<Places>(context, listen: false).searchKey = '';
    Provider.of<Places>(context, listen: false).filterTitle.clear();

    Provider.of<Places>(context, listen: false).sFacility = '';
    Provider.of<Places>(context, listen: false).sField = '';
    Provider.of<Places>(context, listen: false).sRange = '';
    Provider.of<Places>(context, listen: false).sPage = 1;
    Provider.of<Places>(context, listen: false).sPerPage = 10;
    Provider.of<Places>(context, listen: false).sRegion = '';
    Provider.of<Places>(context, listen: false).searchBuilder();

    setState(() {
      _isLoading = false;
      print(_isLoading.toString());
    });
    print(_isLoading.toString());
  }

  Future<void> retrieveItems() async {
    setState(() {
      _isLoading = true;
    });

    if (selectedCity.id == null) {
      await Provider.of<Cities>(context, listen: false).getSelectedCity();
      selectedCity = Provider.of<Cities>(context, listen: false).selectedCity;

      cleanFilters(context);
      Provider.of<Places>(context, listen: false).sCityId =
          selectedCity.id.toString();

      await searchItems();
    } else {
      cleanFilters(context);

      Provider.of<Places>(context, listen: false).sCityId =
          selectedCity.id.toString();
      loadedPlacesToList.clear();
      await searchItems();
    }

    setState(() {
      _isLoading = false;
    });
  }

  Future<void> filterItems() async {
    loadedPlacesToList.clear();
    await retrieveItems();
  }

  Future<void> cleanFilters(BuildContext context) async {
    Provider.of<Places>(context, listen: false).searchKey = '';
    Provider.of<Places>(context, listen: false).filterTitle.clear();
    Provider.of<Places>(context, listen: false).sProvinceId = '';
    Provider.of<Places>(context, listen: false).sType = '';
    Provider.of<Places>(context, listen: false).sField = '';
    Provider.of<Places>(context, listen: false).sFacility = '';
    Provider.of<Places>(context, listen: false).sRange = '';
    Provider.of<Places>(context, listen: false).searchBuilder();
  }

  Future<void> searchItems() async {
    Provider.of<Places>(context, listen: false).sPerPage = 1000;
    Provider.of<Places>(context, listen: false).searchBuilder();
    await Provider.of<Places>(context, listen: false).searchItem();
    searchDetails =
        Provider.of<Places>(context, listen: false).placeSearchDetails;
    loadedPlaces.clear();
    loadedPlaces = Provider.of<Places>(context, listen: false).items;
    loadedPlacesToList.addAll(loadedPlaces);
    _onAddMarker(loadedPlacesToList);
  }

  void _onMapTypeButtonPressed() {
    setState(() {
      _currentMapType = _currentMapType == MapType.normal
          ? MapType.satellite
          : MapType.normal;
    });
  }

  Future<void> changePick(List<PlaceInSearch> list, int i) async {
    if (_isInfoShow) {
      await _animationController.reverse();
      setState(() {});

      selectedPlace = list[i];

      _animationController.forward();

      setState(() {});
    } else {
      _isInfoShow = true;
      setState(() {});
      selectedPlace = list[i];

      _animationController.forward();
      setState(() {});
    }
  }

  Future<void> putOn() async {
    print('putOn');

    await _animationController.reverse();
    setState(() {});
    _isInfoShow = false;
  }

  void _onAddMarker(List<PlaceInSearch> list) async {
    _markers.clear();
    for (int i = 0; i < list.length; i++) {
      print(list[i].latitude);
      print(list[i].longitude);
      var latLng = LatLng(list[i].latitude, list[i].longitude);
      var pinLocationIcon;
      if (list[i].placeType.id == 1) {
        pinLocationIcon = pinLocationIconSalon;
      } else if (list[i].placeType.id == 2) {
        pinLocationIcon = pinLocationIconEnt;
      } else if (list[i].placeType.id == 3) {
        pinLocationIcon = pinLocationIconGym;
      } else {
        pinLocationIcon = pinLocationIconSalon;
      }

      _markers.add(Marker(
        markerId: MarkerId(list[i].id.toString()),
        onTap: () {
          changePick(list, i);
        },
        infoWindow: InfoWindow(
          title: list[i].name,
          onTap: () {
            Navigator.of(context).pushNamed(
              PlaceDetailScreen.routeName,
              arguments: {
                'placeId': selectedPlace.id,
                'name': selectedPlace.name,
                'imageUrl': selectedPlace.image.url.medium,
                'stars': selectedPlace.rate.toString(),
              },
            );
          },
        ),
        position: latLng,
        icon: pinLocationIcon,
      ));
    }
  }

  void _onAddMarkerButtonPressed(LatLng latLng) {
    setState(() {
      _markers.add(Marker(
        // This marker id can be anything that uniquely identifies each marker.
        markerId: MarkerId(_lastMapPosition.toString()),
        position: latLng,
        infoWindow: InfoWindow(
          title: 'Really cool place',
          snippet: '5 Star Rating',
        ),
        icon: BitmapDescriptor.defaultMarker,
      ));
    });
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

  TabController _tabController;
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

    _tabController = TabController(vsync: this, length: 4);
    _tabController.addListener(_handleTabSelection);
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

  void _handleTabSelection() {
    setState(() {});
  }

  void updateLocation() async {
    try {
      Position newPosition = await Geolocator()
          .getCurrentPosition(desiredAccuracy: LocationAccuracy.high)
          .timeout(new Duration(seconds: 5));

      setState(() {
        _lastMapPosition = LatLng(newPosition.latitude, newPosition.longitude);
        _position = newPosition;
      });
    } catch (e) {
      print('Error: ${e.toString()}');
    }
  }

  @override
  Widget build(BuildContext context) {
    double deviceHeight = MediaQuery.of(context).size.height;
    double deviceWidth = MediaQuery.of(context).size.width;
    var currencyFormat = intl.NumberFormat.decimalPattern();

    var textScaleFactor = MediaQuery.of(context).textScaleFactor;
    return Scaffold(
      body: Stack(
        children: <Widget>[
          GoogleMap(
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
            onTap: (_) {
              putOn();
            },
            zoomGesturesEnabled: true,
            onLongPress: (latlng) => _onAddMarkerButtonPressed(latlng),
          ),
          _isInfoShow
              ? Positioned(
                  bottom: 0,
                  left: 0,
                  right: 0,
                  child: AnimatedContainer(
                    duration: _animationController.duration,
                    curve: Curves.easeIn,
                    child: FadeTransition(
                      opacity: _opacityAnimation,
                      child: SlideTransition(
                        position: _slideAnimation,
                        child: LayoutBuilder(
                          builder: (cxt, constraint) => InkWell(
                            onTap: () {
                              Navigator.of(context).pushNamed(
                                PlaceDetailScreen.routeName,
                                arguments: {
                                  'placeId': selectedPlace.id,
                                  'name': selectedPlace.name,
                                  'imageUrl': selectedPlace.image.url.medium,
                                  'stars': selectedPlace.rate.toString(),
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
                              height: deviceHeight * 0.2,
                              width: deviceWidth * 0.9,
                              child: Padding(
                                padding: const EdgeInsets.all(10.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
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
                                              padding: const EdgeInsets.only(
                                                  right: 5.0),
                                              child: Text(
                                                selectedPlace.name,
                                                overflow: TextOverflow.ellipsis,
                                                textAlign: TextAlign.right,
                                                maxLines: 1,
                                                style: TextStyle(
                                                  fontFamily: 'Iransans',
                                                  fontWeight: FontWeight.bold,
                                                  fontSize:
                                                      textScaleFactor * 16.0,
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
                                                      selectedPlace.rate
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
                                              padding: const EdgeInsets.only(
                                                  right: 5.0),
                                              child: Container(
                                                width:
                                                    constraint.minWidth * 0.7,
                                                child: Wrap(
                                                  children: selectedPlace.fields
                                                      .map(
                                                        (e) =>
                                                            ChangeNotifierProvider
                                                                .value(
                                                          value: e,
                                                          child: Text(
                                                            selectedPlace.fields
                                                                        .indexOf(
                                                                            e) <
                                                                    (selectedPlace
                                                                            .fields
                                                                            .length -
                                                                        1)
                                                                ? (e.name +
                                                                    ' ،')
                                                                : e.name,
                                                            style: TextStyle(
                                                              fontFamily:
                                                                  'Iransans',
                                                              color:
                                                                  AppTheme.grey,
                                                              fontSize:
                                                                  textScaleFactor *
                                                                      15.0,
                                                            ),
                                                            textAlign: TextAlign
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
                                                  selectedPlace.price != null
                                                      ? EnArConvertor()
                                                          .replaceArNumber(currencyFormat
                                                              .format(double.parse(
                                                                  selectedPlace
                                                                      .price
                                                                      .toString()))
                                                              .toString())
                                                          .toString()
                                                      : EnArConvertor()
                                                          .replaceArNumber('0'),
                                                  style: TextStyle(
                                                    color: AppTheme.black,
                                                    fontFamily: 'Iransans',
                                                    fontSize:
                                                        textScaleFactor * 18.0,
                                                  ),
                                                ),
                                                Text(
                                                  'هزار \n تومان',
                                                  textAlign: TextAlign.center,
                                                  style: TextStyle(
                                                    fontFamily: 'Iransans',
                                                    color: AppTheme.grey,
                                                    fontSize:
                                                        textScaleFactor * 10.0,
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
                                            padding: const EdgeInsets.only(
                                                left: 3.0, top: 4, bottom: 5),
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
                                                selectedPlace.address,
                                                textAlign: TextAlign.right,
                                                overflow: TextOverflow.ellipsis,
                                                maxLines: 1,
                                                style: TextStyle(
                                                  fontFamily: 'Iransans',
                                                  color: AppTheme.grey,
                                                  fontSize:
                                                      textScaleFactor * 15.0,
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
                )
              : Container(),
          Positioned(
            top: 10,
            left: 0,
            width: deviceWidth * 0.2,
            height: deviceHeight * 0.05,
            child: Builder(
              builder: (context) => InkWell(
                onTap: () {
                  Scaffold.of(context).openEndDrawer();
                },
                child: Container(
                  decoration: BoxDecoration(
                      color: AppTheme.white,
                      borderRadius: BorderRadius.only(
                        topRight: Radius.circular(10),
                        bottomRight: Radius.circular(10),
                      ),
                      boxShadow: [
                        BoxShadow(
                            color: AppTheme.grey.withOpacity(0.5),
                            blurRadius: 10,
                            spreadRadius: 1)
                      ]),
                  child: Center(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        'فیلترها',
                        style: TextStyle(
                          fontFamily: 'Iransans',
                          color: Colors.black,
                          fontSize: textScaleFactor * 14.0,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
          Positioned(
              top: deviceHeight * 0.07,
              left: 15,
              child: FancyFab(
                onPressed0: () {
                  Provider.of<Places>(context, listen: false).sPlaceType = '';
                  Provider.of<Places>(context, listen: false).sPage = 1;
                  loadedPlacesToList.clear();

                  retrieveItems();
                },
                onPressed1: () {
                  Provider.of<Places>(context, listen: false).sPlaceType = '1';
                  Provider.of<Places>(context, listen: false).sPage = 1;
                  loadedPlacesToList.clear();

                  retrieveItems();
                },
                onPressed2: () {
                  Provider.of<Places>(context, listen: false).sPlaceType = '2';
                  Provider.of<Places>(context, listen: false).sPage = 1;
                  loadedPlacesToList.clear();

                  retrieveItems();
                },
                onPressed3: () {
                  Provider.of<Places>(context, listen: false).sPlaceType = '3';
                  Provider.of<Places>(context, listen: false).sPage = 1;
                  loadedPlacesToList.clear();

                  retrieveItems();
                },
                onPressed4: () {
                  Provider.of<Places>(context, listen: false).sPlaceType = '4';
                  Provider.of<Places>(context, listen: false).sPage = 1;
                  loadedPlacesToList.clear();

                  retrieveItems();
                },
              )),
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
      endDrawer: FilterDrawer(filterItems),
    );
  }
}
