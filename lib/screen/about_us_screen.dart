import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:tapsalon/widget/main_drawer.dart';

import '../provider/app_theme.dart';

class AboutUsScreen extends StatefulWidget {
  static const routeName = '/AboutUsScreen';

  @override
  _AboutUsScreenState createState() => _AboutUsScreenState();
}

class _AboutUsScreenState extends State<AboutUsScreen> {
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
          'درباره ما',
          style: TextStyle(
            color: AppTheme.bg,
            fontFamily: 'Iransans',
            fontSize: textScaleFactor * 18.0,
          ),
          textAlign: TextAlign.center,
        ),
        centerTitle: true,
        backgroundColor: AppTheme.appBarColor,
        iconTheme: new IconThemeData(color: AppTheme.appBarIconColor),
      ),
      body: Directionality(
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
                        image:
                            AssetImage('assets/images/tapsalon_icon_200.png'),
                        fit: BoxFit.contain,
                        height: deviceWidth * 0.5,
                      )),
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
                  Padding(
                    padding: const EdgeInsets.all(14.0),
                    child: Text(
                      ' رزرو سالن های ورزشی، تفریحی و باشگاه ها',
                      style: TextStyle(
                        color: AppTheme.grey,
                        fontFamily: 'Iransans',
                        fontSize: textScaleFactor * 15.0,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  Align(
                    alignment: Alignment.centerRight,
                    child: Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: Text(
                        'تاسالن یک پلتفرم اطلاع رسانی و رزرو سالن های ورزشی، تفریحی، باشگاه ها می باشد.  تاپسالن درصدد است با تحت پوشش قرار دادن تمامی اماکن ورزشی و تفریحی سراسر کشور بتواند خدمات جامعی در زمینه اطلاعات اماکن ورزشی بدست بیاورید',
                        style: TextStyle(
                          color: AppTheme.black,
                          fontFamily: 'Iransans',
                          fontSize: textScaleFactor * 15.0,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
//                  Container(
//                    height: deviceHeight * 0.7,
//                    width: deviceWidth,
//                    child: ListView.builder(
//                      shrinkWrap: true,
//                      primary: false,
//                      itemCount: shopData.features_list.length,
//                      itemBuilder: (BuildContext context, int index) {
//                        return Padding(
//                          padding: const EdgeInsets.all(8.0),
//                          child: Row(
//                            children: <Widget>[
//                              Icon(Icons.arrow_right,color: AppTheme.secondary,),
//                              Text(
//                                shopData.features_list[index].feature,
//                                style: TextStyle(
//                                  color: AppTheme.h1,
//                                  fontFamily: 'Iransans',
//                                  fontStyle: FontStyle.italic,
//                                  fontSize: textScaleFactor * 15.0,
//                                ),
//                                textAlign: TextAlign.center,
//                              ),
//                            ],
//                          ),
//                        );
//                      },
//                    ),
//                  ),
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
