import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:tapsalon/widget/en_to_ar_number_convertor.dart';
import 'package:tapsalon/widget/main_drawer.dart';
import 'package:url_launcher/url_launcher.dart';

import '../provider/app_theme.dart';

class ContactWithUs extends StatefulWidget {
  static const routeName = '/ContactWithUs';

  @override
  _ContactWithUsState createState() => _ContactWithUsState();
}

class _ContactWithUsState extends State<ContactWithUs> {
  bool _isLoading = false;

  bool _isInit = true;

  _launchURL(String url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  List<String> aboutInfotitle = [];

  List<String> aboutInfoContent = [];

  @override
  void didChangeDependencies() async {
    if (_isInit) {
      aboutInfoContent = [
        '',
        '',
        '',
        '',
        '',
        '',
      ];
      aboutInfotitle = [
        'درباره فروشگاه',
        'قوانین بازگردانی',
        'حریم خصوصی',
        'نحوه سفارش',
        'سوالات متداول',
        'شیوه پرداخت',
      ];
    }
    _isInit = false;

    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    double deviceHeight = MediaQuery.of(context).size.height;
    double deviceWidth = MediaQuery.of(context).size.width;
    var textScaleFactor = MediaQuery.of(context).textScaleFactor;

    return Scaffold(
      backgroundColor: AppTheme.white,
      appBar: AppBar(
        elevation: 0,
        title: Text(
          'تماس با ما',
          style: TextStyle(
            color: AppTheme.black,
            fontFamily: 'Iransans',
            fontSize: textScaleFactor * 18.0,
          ),
          textAlign: TextAlign.center,
        ),
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
                    color: index.isEven ? Colors.grey : Colors.grey,
                  ),
                );
              },
            )
          : Directionality(
              textDirection: TextDirection.rtl,
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Container(
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        Container(
                          width: deviceWidth * 0.3,
                          height: deviceWidth * 0.3,
                          color: AppTheme.white,
                          child: FadeInImage(
                            placeholder: AssetImage('assets/images/circle.gif'),
                            image: AssetImage(
                                'assets/images/tapsalon_icon_200.png'),
                            fit: BoxFit.contain,
                            height: deviceWidth * 0.5,
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(14.0),
                          child: Text(
                            'تاپ سالن',
                            style: TextStyle(
                              color: AppTheme.h1,
                              fontFamily: 'BFarnaz',
                              fontSize: textScaleFactor * 24.0,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                        Divider(),
                        Column(
                          children: <Widget>[
                            InkWell(
                              onTap: () {
                                _launchURL('https://goo.gl/maps/jFWrYRBtBYARzRWEA');
                              },
                              child: Card(
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Row(
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    children: <Widget>[
                                      Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Icon(
                                          Icons.location_on,
                                          color: Colors.indigoAccent,
                                        ),
                                      ),
                                      Expanded(
                                        flex: 8,
                                        child: Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Text(
                                            'دفتر مرکزی: تبریز - میدان ساعت - خیابان ارتش شمالی، جنب اتاق بازرگانی، ساختمان 49',
                                            style: TextStyle(
                                              color: Colors.black,
                                              fontFamily: 'Iransans',
                                              fontSize: textScaleFactor * 18,
                                            ),
                                            overflow: TextOverflow.clip,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                            InkWell(
                              onTap: () {
                                _launchURL('tel:04135265197');
                              },
                              child: Card(
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: <Widget>[
                                      Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Icon(
                                          Icons.call,
                                          color: Colors.indigoAccent,
                                        ),
                                      ),
                                      Expanded(
                                        flex: 8,
                                        child: Text(
                                          EnArConvertor().replaceArNumber(
                                            '04135265197',
                                          ),
                                          style: TextStyle(
                                            color: Colors.black,
                                            fontFamily: 'Iransans',
                                            fontSize: textScaleFactor * 18,
                                          ),
                                          overflow: TextOverflow.clip,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                            InkWell(
                              onTap: () {
                                _launchURL('tel:09147694436');
                              },
                              child: Card(
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: <Widget>[
                                      Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Icon(
                                          Icons.smartphone,
                                          color: Colors.indigoAccent,
                                        ),
                                      ),
                                      Expanded(
                                        flex: 8,
                                        child: Text(
                                          EnArConvertor()
                                              .replaceArNumber('09147694436'),
                                          style: TextStyle(
                                            color: Colors.black,
                                            fontFamily: 'Iransans',
                                            fontSize: textScaleFactor * 18,
                                          ),
                                          overflow: TextOverflow.clip,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                            Container(
                              height: deviceHeight * 0.10,
                              child: Card(
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: <Widget>[
                                      Expanded(
                                        flex: 8,
                                        child: InkWell(
                                          onTap: () {
                                            _launchURL(
                                                'https://www.instagram.com/tapsalon.ir/');
                                          },
                                          child: Image.asset(
                                              'assets/images/instagram.png'),
                                        ),
                                      ),
                                      Expanded(
                                        flex: 8,
                                        child: InkWell(
                                            onTap: () {
                                              _launchURL(
                                                  'https://www.instagram.com/tapsalon.ir/');
                                            },
                                            child: Image.asset(
                                                'assets/images/telegram.png')),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
      endDrawer: Theme(
        data: Theme.of(context).copyWith(
          // Set the transparency here
          canvasColor: Colors
              .white, //or any other color you want. e.g Colors.blue.withOpacity(0.5)
        ),
        child: MainDrawer(),
      ),
    );
  }
}
