import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../../models/facility.dart';
import '../../models/field.dart';
import '../../models/place.dart';
import 'package:url_launcher/url_launcher.dart' as UrlLauncher;

class SalonDetailInfoScreen extends StatelessWidget {
  final Place place;

  SalonDetailInfoScreen({this.place});

  @override
  Widget build(BuildContext context) {
    final List<String> contactInfo = [
      place.complexInPlace.name.isNotEmpty ? place.complexInPlace.name : '',
      place.complexInPlace.phone,
    ];
    final List<Field> fields = place.fields;
    final List<Facility> facilities = place.facilities;

    final List<IconData> iconDatas = <IconData>[
      Icons.location_city,
      Icons.contact_mail,
      Icons.email,
      Icons.email,
      Icons.email,
    ];

    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              'درباره سالن',
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
            SizedBox(height: 10),
            new SalonItemsList(
              title: 'اطلاعات تماس',
              entries: contactInfo,
              icons: iconDatas,
              color: Colors.red,
            ),
            Container(
                width: double.infinity,
                height: MediaQuery.of(context).size.height * 0.06,
                child: RaisedButton(
                  color: Colors.green,
                  onPressed: () =>
                      UrlLauncher.launch('tel:${place.complexInPlace.phone}'),
                  child: Text(
                    'تماس بگیرید',
                    style: TextStyle(
                      color: Colors.white,
                      fontFamily: 'Iransans',
                      fontSize: MediaQuery.of(context).textScaleFactor * 18.0,
                    ),
                  ),
                )),
            Directionality(
              textDirection: TextDirection.ltr,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.only(top: 10, right: 10),
                    child: Text(
                      'رشته های ورزشی',
                      style: TextStyle(
                        fontFamily: 'Iransans',
                        fontSize: MediaQuery.of(context).textScaleFactor * 18.0,
                      ),
                    ),
                  ),
                  Divider(),
                  Container(
//            height: 300,
                    child: ListView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: fields.length,
                        itemBuilder: (BuildContext context, int index) {
                          return ListTile(
                            title: Text(
                              fields[index].name,
                              textAlign: TextAlign.right,
                            ),
                            trailing: Icon(
                              iconDatas[index],
                              color: Colors.yellow,
                            ),
                          );
                        }),
                  ),
                ],
              ),
            ),
            Directionality(
              textDirection: TextDirection.ltr,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.only(top: 10, right: 10),
                    child: Text(
                      'امکانات',
                      style: TextStyle(
                        fontFamily: 'Iransans',
                        fontSize: MediaQuery.of(context).textScaleFactor * 18.0,
                      ),
                    ),
                  ),
                  Divider(),
                  Container(
//            height: 300,
                    child: ListView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: facilities.length,
                        itemBuilder: (BuildContext context, int index) {
                          return ListTile(
                            title: Text(
                              facilities[index].name,
                              textAlign: TextAlign.right,
                            ),
                            trailing: Icon(
                              iconDatas[index],
                              color: Colors.blue,
                            ),
                          );
                        }),
                  ),
                ],
              ),
            )
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
//            height: 300,
            child: ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: entries.length,
                itemBuilder: (BuildContext context, int index) {
                  return ListTile(
                    title: Text(
                      entries[index],
                      textAlign: TextAlign.right,
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
