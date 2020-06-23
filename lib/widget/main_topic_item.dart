import 'package:flutter/material.dart';
import 'package:tapsalon/provider/app_theme.dart';

class MainTopicItem extends StatelessWidget {
  const MainTopicItem({
    Key key,
    @required this.title,
    @required this.number,
    @required this.bgColor,
    @required this.icon,
  }) : super(key: key);

  final int number;
  final String title;
  final Color bgColor;
  final String icon;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width * 0.28,
      height: MediaQuery.of(context).size.width * 0.28,
      decoration: BoxDecoration(
          color: bgColor,
          boxShadow: [
            BoxShadow(
              color: AppTheme.primary.withOpacity(1),
              blurRadius: 0,
              spreadRadius: 0,
              offset: Offset(
                0,
                0,
              ),
            )
          ],
          borderRadius:
          new BorderRadius.all(Radius.circular(25))),
      child: LayoutBuilder(
        builder: (_, constraint) => Stack(
          children: <Widget>[
            Align(
              alignment: Alignment.center,
              child: Container(
                height: constraint.maxHeight * 0.4,
                width: constraint.maxWidth * 0.4,
                child: FittedBox(
                  child: Image.asset(
                    icon,
                    fit: BoxFit.cover,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  title,
                  style: TextStyle(
                    color: Colors.white,
                    fontFamily: 'Iransans',
                    fontSize: MediaQuery.of(context).textScaleFactor * 9.0,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
