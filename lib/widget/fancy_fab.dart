import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tapsalon/provider/app_theme.dart';
import 'package:tapsalon/provider/places.dart';

class FancyFab extends StatefulWidget {
  final Function() onPressed0;
  final Function() onPressed1;
  final Function() onPressed2;
  final Function() onPressed3;
  final String tooltip;
  final IconData icon;

  FancyFab(
      {this.onPressed0,
      this.onPressed1,
      this.onPressed2,
      this.onPressed3,
      this.tooltip,
      this.icon});

  @override
  _FancyFabState createState() => _FancyFabState();
}

class _FancyFabState extends State<FancyFab>
    with SingleTickerProviderStateMixin {
  bool isOpened = false;
  AnimationController _animationController;
  Animation<Color> _buttonColor;
  Animation<double> _animateIcon;
  Animation<double> _translateButton;
  Curve _curve = Curves.easeOut;
  double _fabHeight = 10;

  @override
  initState() {
    _animationController =
        AnimationController(vsync: this, duration: Duration(milliseconds: 500))
          ..addListener(() {
            setState(() {});
          });
    _animateIcon =
        Tween<double>(begin: 0.0, end: 1.0).animate(_animationController);
    _buttonColor = ColorTween(
      begin: Colors.white,
      end: Colors.red,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Interval(
        0.00,
        1.00,
        curve: Curves.linear,
      ),
    ));
    _translateButton = Tween<double>(
      begin: -56,
      end: _fabHeight,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Interval(
        0.0,
        0.75,
        curve: _curve,
      ),
    ));
    super.initState();
  }

  @override
  dispose() {
    _animationController.dispose();
    super.dispose();
  }

  animate() {
    if (!isOpened) {
      _animationController.forward();
    } else {
      _animationController.reverse();
    }
    isOpened = !isOpened;
  }

  Widget all() {
    return Container(
      child: FloatingActionButton(
        heroTag: 'onPressed0',
        elevation: isOpened ? 3 : 0,
        backgroundColor: AppTheme.white,
        onPressed: () {
          widget.onPressed0();
          animate();
        },
        tooltip: 'همه',
        child: Text(
          'همه',
          style: TextStyle(
            fontFamily: 'Iransans',
            color: Colors.black,
            fontSize: MediaQuery.of(context).textScaleFactor * 14.0,
          ),
        ),
      ),
    );
  }

  Widget sport() {
    return Container(
      child: FloatingActionButton(
        heroTag: 'onPressed1',

        elevation: isOpened ? 3 : 0,
        backgroundColor: AppTheme.white,
        onPressed: () {
          widget.onPressed1();
          animate();
        },
        tooltip: 'ورزشی',
        child: Text(
          'ورزشی',
          style: TextStyle(
            fontFamily: 'Iransans',
            color: Colors.black,
            fontSize: MediaQuery.of(context).textScaleFactor * 14.0,
          ),
        ),
        isExtended: true,
      ),
    );
  }

  Widget club() {
    return Container(
      child: FloatingActionButton(
        heroTag: 'onPressed2',

        elevation: isOpened ? 3 : 0,
        backgroundColor: AppTheme.white,
        onPressed: () {
          widget.onPressed2();
          animate();
        },
        tooltip: 'باشگاه',
        child: Text(
          'باشگاه',
          style: TextStyle(
            fontFamily: 'Iransans',
            color: Colors.black,
            fontSize: MediaQuery.of(context).textScaleFactor * 14.0,
          ),
        ),
      ),
    );
  }

  Widget entertainment() {
    return Container(
      child: FloatingActionButton(
        heroTag: 'onPressed3',

        elevation: isOpened ? 3 : 0,
        backgroundColor: AppTheme.white,
        onPressed: () {
          widget.onPressed3();
          animate();
        },
        tooltip: 'تفریحی',
        child: Text(
          'تفریحی',
          style: TextStyle(
            fontFamily: 'Iransans',
            color: Colors.black,
            fontSize: MediaQuery.of(context).textScaleFactor * 14.0,
          ),
        ),
      ),
    );
  }

  String buttonTitle() {
    String title = 'همه';
    String placeTytpe =
        Provider.of<Places>(context, listen: false).sComplexType;
    if (placeTytpe == '1') {
      title = 'ورزشی';
    } else if (placeTytpe == '2') {
      title = 'باشگاه';
    } else if (placeTytpe == '3') {
      title = 'تفریحی';
    } else {
      title = 'همه';
    }
    return title;
  }

  Widget toggle() {
    return Container(
      child: FloatingActionButton(
        backgroundColor: _buttonColor.value,
        onPressed: animate,
        tooltip: 'Toggle',
        child: isOpened
            ? AnimatedIcon(
                icon: AnimatedIcons.menu_close,
                progress: _animateIcon,
              )
            : Text(
                buttonTitle(),
                style: TextStyle(
                  fontFamily: 'Iransans',
                  color: Colors.black,
                  fontSize: MediaQuery.of(context).textScaleFactor * 14.0,
                ),
              ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.end,
      verticalDirection: VerticalDirection.up,
      children: <Widget>[
        Transform(
          transform: Matrix4.translationValues(
            0.0,
            _translateButton.value * 4.0,
            0.0,
          ),
          child: entertainment(),
        ),
        Transform(
          transform: Matrix4.translationValues(
            0.0,
            _translateButton.value * 3.0,
            0.0,
          ),
          child: club(),
        ),
        Transform(
          transform: Matrix4.translationValues(
            0.0,
            _translateButton.value * 2.0,
            0.0,
          ),
          child: sport(),
        ),
        Transform(
          transform: Matrix4.translationValues(
            0.0,
            _translateButton.value,
            0.0,
          ),
          child: all(),
        ),
        toggle(),
      ],
    );
  }
}
