import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';
import 'package:smooth_star_rating/smooth_star_rating.dart';
import 'package:tapsalon/models/city.dart';
import 'file:///C:/AndroidStudioProjects/Pro_tapsalon/tapsalon_flutter/tapsalon/lib/models/places_models/place_in_search.dart';

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

  @override
  void didChangeDependencies() {
    if (_isInit) {
      Provider.of<Places>(context, listen: false).searchBuilder();
      _tabController.index = 0;

      try {
        selectedCity = Provider.of<Cities>(context, listen: false).selectedCity;
      } catch (error) {}
      _lastMapPosition = LatLng(selectedCity.latitude, selectedCity.longitude);
      retrieveItems();
    }
    _isInit = false;
    super.didChangeDependencies();
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
      await searchItems();
    }

    setState(() {
      _isLoading = false;
    });
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
        Provider.of<Places>(context, listen: false).complexSearchDetails;
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

      _markers.add(Marker(
        markerId: MarkerId(list[i].id.toString()),
        onTap: () {
          changePick(list, i);
        },
        infoWindow: InfoWindow(title: list[i].name),
        position: latLng,
        icon: BitmapDescriptor.defaultMarkerWithHue(240),
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

  @override
  void initState() {
    super.initState();
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

  final List<Tab> myTabs = <Tab>[
    Tab(
      text: 'همه',
    ),
    Tab(
      text: 'ورزشی',
    ),
    Tab(
      text: 'باشگاه ها',
    ),
    Tab(
      text: 'تفریحی',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    double deviceHeight = MediaQuery.of(context).size.height;
    double deviceWidth = MediaQuery.of(context).size.width;
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
          Positioned(
            top: deviceHeight * 0.055 + 5,
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Align(
                alignment: Alignment.topLeft,
                child: Container(
                  width: deviceWidth * 0.12,
                  child: Column(
                    children: <Widget>[
                      FloatingActionButton(
                        heroTag: "btn1",

                        onPressed: _onMapTypeButtonPressed,
                        materialTapTargetSize: MaterialTapTargetSize.padded,
                        backgroundColor: Colors.green,
                        child: const Icon(
                          Icons.map,
                          size: 25.0,
                          color: Colors.white,
                        ),
                      ),
                      SizedBox(height: 5.0),
                      FloatingActionButton(
                        heroTag: "btn2",

                        onPressed: () {
                          myController.animateCamera(
                            CameraUpdate.newCameraPosition(
                              CameraPosition(
                                  target: LatLng(
                                      _position.latitude, _position.longitude),
                                  zoom: 20.0),
                            ),
                          );
                        },
                        materialTapTargetSize: MaterialTapTargetSize.padded,
                        backgroundColor: Colors.green,
                        child: const Icon(
                          Icons.my_location,
                          size: 25.0,
                          color: Colors.white,
                        ),
                      ),
                      SizedBox(height: 5.0),
                      Builder(
                        builder: (context) {
                          return FloatingActionButton(
                            heroTag: "btn3",

                            onPressed: () {
                              Scaffold.of(context).openEndDrawer();
                            },
                            materialTapTargetSize: MaterialTapTargetSize.padded,
                            backgroundColor: Colors.green,
                            child: const Icon(
                              Icons.filter_list,
                              size: 25.0,
                              color: Colors.white,
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
          _isInfoShow
              ? Positioned(
                  bottom: deviceHeight * 0.01,
                  left: deviceWidth * 0.010,
                  right: deviceWidth * 0.01,
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
                                  'stars': selectedPlace.stars.toString(),
                                },
                              );
                            },
                            child: Container(
                              height: deviceHeight * 0.1,
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(50),
                                  color: Colors.white),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
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
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceEvenly,
                                      children: <Widget>[
                                        Text(
                                          selectedPlace.name,
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                          style: TextStyle(
                                            fontFamily: 'Iransans',
                                            color: Colors.black,
                                            fontSize: MediaQuery.of(context)
                                                    .textScaleFactor *
                                                11.0,
                                          ),
                                        ),
                                        Text(
                                          selectedPlace.region.name,
                                          style: TextStyle(
                                            fontFamily: 'Iransans',
                                            color: Colors.black,
                                            fontSize: MediaQuery.of(context)
                                                    .textScaleFactor *
                                                11.0,
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
                                                rating: selectedPlace.stars,
                                                size:
                                                    constraint.maxWidth * 0.05,
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
                                          placeholder: AssetImage(
                                              'assets/images/tapsalon_icon_200.png'),
                                          image: NetworkImage(selectedPlace
                                              .image.url.medium
                                              .toString()),
                                          fit: BoxFit.cover,
                                        ),
                                      ),
                                    ),
                                  )
                                ],
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
            left: 5,
            right: 5,
            top: 5,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: Container(
                height: deviceHeight * 0.055,
                decoration: BoxDecoration(
                    border: Border.all(color: Colors.red),
                    borderRadius: BorderRadius.circular(10)),
                child: TabBar(
                    onTap: (i) {
                      if (i == 0) {
                        Provider.of<Places>(context, listen: false)
                            .sComplexType = '';
                      } else if (i == 1) {
                        Provider.of<Places>(context, listen: false)
                            .sComplexType = '1';
                      } else if (i == 2) {
                        Provider.of<Places>(context, listen: false)
                            .sComplexType = '2';
                      } else if (i == 3) {
                        Provider.of<Places>(context, listen: false)
                            .sComplexType = '3';
                      }

                      Provider.of<Places>(context, listen: false).sPage = 1;
                      loadedPlacesToList.clear();

                      retrieveItems();
                    },
                    indicator: BoxDecoration(
                      color: Colors.red,
                    ),
                    indicatorColor: Colors.red,
                    indicatorWeight: 0,
                    unselectedLabelColor: Colors.red,
                    labelColor: Colors.white,
                    labelPadding: EdgeInsets.only(top: 2, left: 4),
                    labelStyle: TextStyle(
                      fontFamily: 'Iransans',
                      fontSize: textScaleFactor * 13.0,
                    ),
                    unselectedLabelStyle: TextStyle(
                      fontFamily: 'Iransans',
                      fontSize: textScaleFactor * 13.0,
                    ),
                    controller: _tabController,
                    tabs: myTabs),
              ),
            ),
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
      endDrawer: FilterDrawer(retrieveItems),
    );
  }
}
