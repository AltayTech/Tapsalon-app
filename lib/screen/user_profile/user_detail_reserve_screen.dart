import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:provider/provider.dart';
import 'package:tapsalon/models/user_models/user.dart';
import 'package:tapsalon/provider/app_theme.dart';
import 'package:tapsalon/provider/cities.dart';
import 'package:tapsalon/provider/user_info.dart';
import 'package:tapsalon/screen/user_profile/user_detail_reserve_list_view.dart';
import 'package:tapsalon/widget/dialogs/select_city_dialog.dart';
import 'package:tapsalon/widget/main_drawer.dart';

class UserDetailReserveScreen extends StatefulWidget {
  static const routeName = '/UserDetailReserveScreen';

  final User user;

  UserDetailReserveScreen({this.user});

  @override
  _UserDetailReserveScreenState createState() => _UserDetailReserveScreenState();
}

class _UserDetailReserveScreenState extends State<UserDetailReserveScreen> {
  User user;
  var _isLoading = false;
  bool _isInit = true;

  @override
  void didChangeDependencies() {
    if (_isInit) {
      cashOrder();
    }
    _isInit = false;
    super.didChangeDependencies();
  }

  Future<void> cashOrder() async {
    setState(() {
      _isLoading = true;
    });
    await Provider.of<UserInfo>(context, listen: false).getUser();
    user = Provider.of<UserInfo>(context, listen: false).user;

    setState(() {
      _isLoading = false;
      print(_isLoading.toString());
    });
    print(_isLoading.toString());
  }

  @override
  Widget build(BuildContext context) {
    double deviceWidth = MediaQuery.of(context).size.width;
    double deviceHeight = MediaQuery.of(context).size.height;
    double textScaleFactor = MediaQuery.of(context).textScaleFactor;

    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: AppTheme.appBarColor,
          elevation: 0,
          iconTheme: IconThemeData(color: AppTheme.appBarIconColor),
          actions: <Widget>[
            Consumer<Cities>(
              builder: (_, cities, ch) => Padding(
                padding: const EdgeInsets.only(left: 20.0),
                child: InkWell(
                  onTap: () {
                    showDialog(
                        context: context, builder: (ctx) => SelectCityDialog());
                  },
                  child: Directionality(
                    textDirection: TextDirection.ltr,
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        Text(
                          cities.selectedCity.name,
                          softWrap: true,
                          style: TextStyle(
                              color: AppTheme.black,
                              fontFamily: 'Iransans',
                              fontSize: textScaleFactor * 12.0),
                        ),
                        Icon(
                          Icons.arrow_drop_down,
                          size: 25,
                        )
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
        drawer: Theme(
          data: Theme.of(context).copyWith(
            // Set the transparency here
            canvasColor: AppTheme
                .white, //or any other color you want. e.g Colors.blue.withOpacity(0.5)
          ),
          child: MainDrawer(),
        ),
        body: _isLoading
            ? Align(
                alignment: Alignment.center,
                child: SpinKitFadingCircle(
                  itemBuilder: (BuildContext context, int index) {
                    return DecoratedBox(
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: index.isEven ? Colors.grey : Colors.grey,
                      ),
                    );
                  },
                ),
              )
            : UserDetailReserveView(user: user,),
      ),
    );
  }
}


