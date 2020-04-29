import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:intl/intl.dart' as intl;
import 'package:provider/provider.dart';
import 'package:tapsalon/models/app_theme.dart';
import 'package:tapsalon/models/user.dart';
import 'package:tapsalon/screen/user_profile/login_screen.dart';
import 'package:tapsalon/screen/user_profile/profile_detail_tabbar.dart';
import 'package:tapsalon/widget/en_to_ar_number_convertor.dart';

import '../../provider/auth.dart';
import '../../provider/user_info.dart';

class ProfileView extends StatefulWidget {
  @override
  _ProfileViewState createState() => _ProfileViewState();
}

class _ProfileViewState extends State<ProfileView> {
  var _isLoading = false;
  bool _isInit = true;

  Future<void> cashOrder() async {
    setState(() {
      _isLoading = true;
    });
    await Provider.of<UserInfo>(context, listen: false).getUser();
    print(_isLoading.toString());

    setState(() {
      _isLoading = false;
      print(_isLoading.toString());
    });
    print(_isLoading.toString());
  }

  @override
  void didChangeDependencies() {
    if (_isInit) {
      cashOrder();
    }
    _isInit = false;
    // TODO: implement didChangeDependencies
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    bool isLogin = Provider.of<Auth>(context).isAuth;

    double deviceSizeWidth = MediaQuery.of(context).size.width;
    double deviceSizeHeight = MediaQuery.of(context).size.height;
    double textScaleFactor = MediaQuery.of(context).textScaleFactor;
    var currencyFormat = intl.NumberFormat.decimalPattern();

    User user = Provider.of<UserInfo>(context).user;
    return !isLogin
        ? Container(
            child: Center(
              child: Wrap(
                direction: Axis.vertical,
                crossAxisAlignment: WrapCrossAlignment.center,
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text('شما وارد نشده اید'),
                  ),
                  InkWell(
                    onTap: () {
                      Navigator.of(context).pushNamed(LoginScreen.routeName);
                    },
                    child: Container(
                      child: Padding(
                        padding: const EdgeInsets.all(15.0),
                        child: Text(
                          'ورود به اکانت کاربری',
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                      decoration: BoxDecoration(
                          color: Colors.green,
                          borderRadius: BorderRadius.circular(5)),
                    ),
                  )
                ],
              ),
            ),
          )
        : Padding(
          padding: const EdgeInsets.all(8.0),
          child: Container(
              width: deviceSizeWidth,
              height: deviceSizeHeight,
              child: Align(
                alignment: Alignment.center,
                child: _isLoading
                    ? SpinKitFadingCircle(
                        itemBuilder: (BuildContext context, int index) {
                          return DecoratedBox(
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: index.isEven ? AppTheme.spinerColor: AppTheme.spinerColor,
                            ),
                          );
                        },
                      )
                    : SingleChildScrollView(
                        child: Container(
                          width: deviceSizeWidth,
                          height: deviceSizeHeight,
                          child: Column(
                            children: <Widget>[
                              Container(
                                height: deviceSizeHeight * 0.06,
                                decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(5),
                                    border: Border.all(
                                        color: Colors.grey, width: 0.2)),
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Row(
                                    textDirection: TextDirection.rtl,
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceEvenly,
                                    children: <Widget>[
                                      Text(
                                        user.fname + ' ' + user.lname,
                                        style: TextStyle(
                                          color: Colors.blueGrey,
                                          fontFamily: 'Iransans',
                                          fontSize: textScaleFactor * 12,
                                        ),
                                      ),
                                      Spacer(),
                                      Text(
                                        'اعتبار',
                                        style: TextStyle(
                                          color: Colors.blueGrey,
                                          fontFamily: 'Iransans',
                                          fontSize: textScaleFactor * 12,
                                        ),
                                      ),
                                      Text(
                                        user.wallet.isNotEmpty
                                            ? EnArConvertor().replaceArNumber(
                                                currencyFormat
                                                    .format(
                                                        double.parse(user.wallet))
                                                    .toString())
                                            : EnArConvertor()
                                                    .replaceArNumber('0') +
                                                'تومان',
                                        style: TextStyle(
                                          color: Colors.redAccent,
                                          fontFamily: 'Iransans',
                                          fontSize: textScaleFactor * 18,
                                        ),
                                      ),
                                      Text(
                                        'تومان',
                                        style: TextStyle(
                                          color: Colors.blueGrey,
                                          fontFamily: 'Iransans',
                                          fontSize: textScaleFactor * 12,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              Expanded(
                                child: ProfileDetailTabBar(
                                  user: user,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
              ),
            ),
        );
  }
}
