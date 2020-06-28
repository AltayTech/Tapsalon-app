import 'package:flutter/material.dart';
import 'package:intl/intl.dart' as intl;
import 'package:tapsalon/provider/app_theme.dart';

import '../models/comment.dart';
import '../widget/en_to_ar_number_convertor.dart';

class CommentItem extends StatelessWidget {
  final Comment comment;

  CommentItem({this.comment});

  @override
  Widget build(BuildContext context) {
    double deviceHeight = MediaQuery.of(context).size.height;
    double deviceWidth = MediaQuery.of(context).size.width;
    var textScaleFactor = MediaQuery.of(context).textScaleFactor;
    var currencyFormat = intl.NumberFormat.decimalPattern();

    return LayoutBuilder(
      builder: (context, constraint) => Padding(
        padding: const EdgeInsets.only(top: 16.0),
        child: Container(
          width: constraint.maxWidth * 0.9,
          decoration: BoxDecoration(
              color: AppTheme.white,
//                          border: Border.all(width: 5, color: AppTheme.bg),
              borderRadius: BorderRadius.circular(10)),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: Column(
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.all(5.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: <Widget>[
                      Icon(
                        Icons.account_circle,
                        color: Colors.blue,
                        size: 25,
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          '${comment.user.fname} ${comment.user.lname}',
                          textAlign: TextAlign.right,
                          maxLines: 1,
                          style: TextStyle(
                            fontFamily: 'Iransans',
                            fontSize: textScaleFactor * 13.0,
                          ),
                        ),
                      ),
                      Spacer(),
                      Text(
                        EnArConvertor().replaceArNumber(DateTime.now()
                                .difference(DateTime.parse(comment.createdAt))
                                .inDays
                                .toString()) +
                            ' روز پیش',
                        textAlign: TextAlign.right,
                        style: TextStyle(
                          fontFamily: 'Iransans',
                          color: Colors.grey,
                          fontSize: textScaleFactor * 12.0,
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  width: double.infinity,
                  child: Padding(
                    padding: const EdgeInsets.only(
                      right: 30.0,
                      left: 30,
                      bottom: 15,
                    ),
                    child: Text(
                      comment.content,
                      textAlign: TextAlign.right,
                      style: TextStyle(
                        fontFamily: 'Iransans',
                        color: AppTheme.black,
                        fontSize: textScaleFactor * 14.0,
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(bottom: 8.0),
                  child: Container(
                    width: deviceWidth * 0.9,
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        Spacer(),
                        Padding(
                          padding: const EdgeInsets.only(
                              right: 1, left: 3.0, top: 1, bottom: 4),
                          child: Icon(
                            Icons.star,
                            color: AppTheme.iconColor,
                            size: 25,
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(
                              right: 5, left: 10, top: 1, bottom: 4),
                          child: Text(
                            EnArConvertor().replaceArNumber(
                              comment.rate.toString(),
                            ),
                            textAlign: TextAlign.right,
                            overflow: TextOverflow.ellipsis,
                            maxLines: 1,
                            style: TextStyle(
                              fontFamily: 'Iransans',
                              color: AppTheme.grey,
                              fontSize: textScaleFactor * 16.0,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
