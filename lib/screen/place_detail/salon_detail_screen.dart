import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:intl/intl.dart' as intl;
import 'package:provider/provider.dart';
import 'package:tapsalon/models/app_theme.dart';
import 'package:tapsalon/models/place.dart';
import 'package:tapsalon/provider/salons.dart';
import 'package:tapsalon/screen/place_detail/salon_detail_tabbar.dart';
import 'package:tapsalon/widget/main_drawer.dart';

class SalonDetailScreen extends StatefulWidget {
  static const routeName = '/salon-detail';

  @override
  _SalonDetailScreenState createState() => _SalonDetailScreenState();
}

class _SalonDetailScreenState extends State<SalonDetailScreen> {
  var _isLoading;
  bool _isInit = true;

  Place loadedPlace;

  String title;

  @override
  void didChangeDependencies() {
    if (_isInit) {
      searchItems();
    }
    _isInit = false;
    // TODO: implement didChangeDependencies
    super.didChangeDependencies();
  }

  Future<void> searchItems() async {
    setState(() {
      _isLoading = true;
    });
    final Map arguments = ModalRoute.of(context).settings.arguments as Map;
    final placeId = arguments != null ? arguments['placeId'] : 0;
    title = arguments != null ? arguments['title'] : '0';

    print(placeId);
    await Provider.of<Salons>(context, listen: false).retrievePlace(placeId);
    loadedPlace = Provider.of<Salons>(context, listen: false).itemPlace;
    print(placeId);

    print(_isLoading.toString());

    setState(() {
      _isLoading = false;
      print(_isLoading.toString());
    });
    print(_isLoading.toString());
  }

  @override
  Widget build(BuildContext context) {
    double deviceHeight = MediaQuery.of(context).size.height;
    double deviceWidth = MediaQuery.of(context).size.width;
    var textScaleFactor = MediaQuery.of(context).textScaleFactor;
    var currencyFormat = intl.NumberFormat.decimalPattern();

    return Scaffold(
      appBar: AppBar(
        title: Text(
          title,
        ),
        centerTitle: true,
        backgroundColor: AppTheme.appBarColor,
      ),
      body: Container(
        width: double.infinity,
        child: Align(
          alignment: Alignment.center,
          child: _isLoading
              ? SpinKitFadingCircle(
                  itemBuilder: (BuildContext context, int index) {
                    return DecoratedBox(
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: index.isEven ? AppTheme.spinerColor : AppTheme.spinerColor,
                      ),
                    );
                  },
                )
              : SalonDetailTabBar(
                  place: loadedPlace,
                ),
        ),
      ),
      endDrawer: MainDrawer(),
    );
  }
}
