import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:tapsalon/models/places_models/place.dart';
import 'package:url_launcher/url_launcher.dart' as UrlLauncher;

import '../../widget/en_to_ar_number_convertor.dart';

class PlaceDetailInfoScreen extends StatelessWidget {

  final Place place;

  PlaceDetailInfoScreen({this.place});

  Completer<GoogleMapController> _controller = Completer();

  void _onMapCreated(GoogleMapController controller) {
    _controller.complete(controller);
  }

  final Set<Marker> _markers = {};

  LatLng _lastMapPosition;

  void _onCameraMove(CameraPosition position) {
    _lastMapPosition = position.target;
  }

  @override
  Widget build(BuildContext context) {
    double deviceHeight = MediaQuery.of(context).size.height;
    double deviceWidth = MediaQuery.of(context).size.width;
    var textScaleFactor = MediaQuery.of(context).textScaleFactor;

    final LatLng _center = LatLng(
      place.latitude != null ? place.latitude : 46,
      place.longitude != null ? place.longitude : 38,
    );
    final List<String> contactInfo = [
      '${place.user.fname} ${place.user.lname}',
      place.phone,
      place.mobile,
      place.region.name
    ];
    final List<IconData> iconDatas = <IconData>[
      Icons.supervisor_account,
      Icons.phone,
      Icons.phonelink_ring,
      Icons.location_searching,
      Icons.email,
    ];
    _markers.add(
      Marker(
        markerId: MarkerId(place.id.toString()),
        position: _center,
        infoWindow: InfoWindow(
          title: place.name,
          snippet: place.rate.toString(),
        ),
        icon: BitmapDescriptor.defaultMarker,
      ),
    );

    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              'درباره مجموعه',
              style: TextStyle(
                fontFamily: 'Iransans',
                fontSize: MediaQuery.of(context).textScaleFactor * 18.0,
              ),
            ),
            Divider(),
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: Text(
                place.about,
                style: TextStyle(
                  fontFamily: 'Iransans',
                  fontSize: MediaQuery.of(context).textScaleFactor * 11.0,
                ),
                textAlign: TextAlign.justify,
              ),
            ),
            new SalonItemsList(
              title: 'اطلاعات تماس',
              entries: contactInfo,
              icons: iconDatas,
              color: Colors.green,
            ),
            Container(
                width: double.infinity,
                height: MediaQuery.of(context).size.height * 0.06,
                child: RaisedButton(
                  color: Colors.green,
                  onPressed: () => UrlLauncher.launch('tel:${place.phone}'),
                  child: Text(
                    'تماس بگیرید',
                    style: TextStyle(
                      color: Colors.white,
                      fontFamily: 'Iransans',
                      fontSize: MediaQuery.of(context).textScaleFactor * 18.0,
                    ),
                  ),
                )),
            Container(
              height: deviceWidth * 0.7,
              width: double.infinity,
              child: GoogleMap(
                onMapCreated: _onMapCreated,
                initialCameraPosition: CameraPosition(
                  target: _center,
                  zoom: 13.0,
                ),
                compassEnabled: true,
                mapType: MapType.normal,
                markers: _markers,
                onCameraMove: _onCameraMove,
                scrollGesturesEnabled: true,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class SalonItemsList extends StatelessWidget {
  const SalonItemsList({
    Key key,
    @required this.title,
    @required this.entries,
    @required this.icons,
    @required this.color,
  }) : super(key: key);

  final List<String> entries;
  final List<IconData> icons;
  final String title;
  final color;

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.ltr,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.only(top: 10, right: 10),
            child: Text(
              title.isNotEmpty ? title : '',
              style: TextStyle(
                fontFamily: 'Iransans',
                fontSize: MediaQuery.of(context).textScaleFactor * 18.0,
              ),
            ),
          ),
          Divider(),
          Container(
            child: ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: entries.length,
                itemBuilder: (BuildContext context, int index) {
                  return ListTile(
                    title: Text(
                      EnArConvertor().replaceArNumber(entries[index]),
                      textAlign: TextAlign.right,
                      style: TextStyle(
                        fontFamily: 'Iransans',
                        fontSize: MediaQuery.of(context).textScaleFactor * 14.0,
                      ),
                    ),
                    trailing: Icon(
                      icons[index],
                      color: color,
                    ),
                  );
                }),
          ),
        ],
      ),
    );
  }
}
