import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:intl/intl.dart' as intl;
import 'package:provider/provider.dart';

import '../../models/user_models/user.dart';
import '../../provider/app_theme.dart';
import '../../provider/auth.dart';
import '../../provider/user_info.dart';
import '../../screen/user_profile/login_screen.dart';
import '../../widget/en_to_ar_number_convertor.dart';
import 'user_detail_info_screen.dart';
import 'user_detail_reserve_list_screen.dart';
import 'user_detail_wallet_screen.dart';

class ProfileView extends StatefulWidget {
  @override
  _ProfileViewState createState() => _ProfileViewState();
}

class _ProfileViewState extends State<ProfileView>
    with SingleTickerProviderStateMixin {
  var _isLoading = false;
  bool _isInit = true;
  TabController _tabController;

  Future<void> getUser() async {
    setState(() {
      _isLoading = true;
    });
    await Provider.of<UserInfo>(context, listen: false).getUser();

    setState(() {
      _isLoading = false;
    });
  }

  @override
  void initState() {
    _tabController = TabController(vsync: this, length: 3);
    _tabController.addListener(_handleTabSelection);
    super.initState();
  }

  @override
  void didChangeDependencies() {
    if (_isInit) {
      getUser();
    }
    _isInit = false;
    super.didChangeDependencies();
  }

  void _handleTabSelection() {
    setState(() {});
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    bool isLogin = Provider.of<Auth>(context).isAuth;

    double deviceSizeWidth = MediaQuery.of(context).size.width;
    double deviceSizeHeight = MediaQuery.of(context).size.height;
    double textScaleFactor = MediaQuery.of(context).textScaleFactor;
    var currencyFormat = intl.NumberFormat.decimalPattern();

    User user = Provider.of<UserInfo>(context).user;

    final List<Tab> myTabs = <Tab>[
      Tab(
        text: 'اطلاعات کاربر',
        icon: Icon(
          Icons.account_circle,
          color:
              _tabController.index == 0 ? Color(0xff009EFD) : Color(0xffFEA832),
          size: deviceSizeWidth * 0.10,
        ),
      ),
      Tab(
        text: 'رزرو شده',
        icon: Icon(
          Icons.book,
          color:
              _tabController.index == 1 ? Color(0xff009EFD) : Color(0xffFEA832),
          size: deviceSizeWidth * 0.10,
        ),
      ),
      Tab(
        text: 'کیف پول',
        icon: Icon(
          Icons.account_balance_wallet,
          color:
              _tabController.index == 2 ? Color(0xff009EFD) : Color(0xffFEA832),
          size: deviceSizeWidth * 0.10,
        ),
      ),
    ];

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
                              color: index.isEven
                                  ? AppTheme.spinerColor
                                  : AppTheme.spinerColor,
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
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Container(
                                  height: deviceSizeHeight * 0.06,
                                  decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(5),
                                      border: Border.all(
                                          color: Colors.grey, width: 0.2)),
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
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
                                                        .format(double.parse(
                                                            user.wallet))
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
                                ),
                              ),
                              Expanded(
                                child: Directionality(
                                  textDirection: TextDirection.rtl,
                                  child: DefaultTabController(
                                    length: myTabs.length,
                                    child: Container(
                                      height: deviceSizeHeight * 0.9,
                                      child: Column(
                                        children: <Widget>[
                                          Container(
                                            height: deviceSizeHeight * 0.12,
                                            width: deviceSizeWidth,
                                            child: TabBar(
                                              indicatorColor: Colors.blue,
                                              indicatorWeight: 3,
                                              unselectedLabelColor:
                                                  Color(0xffFEA832),
                                              labelColor: Colors.blue,
                                              labelStyle: TextStyle(
                                                fontFamily: 'Iransans',
                                                fontSize: MediaQuery.of(context)
                                                        .textScaleFactor *
                                                    10.0,
                                              ),
                                              unselectedLabelStyle: TextStyle(
                                                fontFamily: 'Iransans',
                                                fontSize: MediaQuery.of(context)
                                                        .textScaleFactor *
                                                    10.0,
                                              ),
                                              controller: _tabController,
                                              tabs: myTabs,
                                            ),
                                          ),
                                          Container(
                                            height: deviceSizeHeight * 0.6,
                                            width: deviceSizeWidth,
                                            child: TabBarView(
                                              controller: _tabController,
                                              children: myTabs.map((Tab tab) {
                                                if (_tabController.index == 0) {
                                                  return UserDetailInfoScreen(
                                                    user: user,
                                                  );
                                                } else if (_tabController.index ==
                                                    1) {
                                                  return UserDetailReserveListScreen(
                                                    user: user,
                                                  );
                                                } else {
                                                  return UserDetailWalletScreen(
                                                    user: user,
                                                  );
                                                }
                                              }).toList(),
                                            ),
                                          )
                                        ],
                                      ),
                                    ),
                                  ),
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
