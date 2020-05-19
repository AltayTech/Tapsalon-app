import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../models/complex.dart';
import '../../widget/place_item.dart';

class ComplexDetailPlaceListScreen extends StatelessWidget {
  final Complex complex;

  ComplexDetailPlaceListScreen({this.complex});

  @override
  Widget build(BuildContext context) {
    double deviceHeight = MediaQuery.of(context).size.height;
    double deviceWidth = MediaQuery.of(context).size.width;
    return Container(
      width: double.infinity,
      child: ListView.builder(
        shrinkWrap: true,
        scrollDirection: Axis.vertical,
        itemCount: complex.placeList.length,
        itemBuilder: (ctx, i) => ChangeNotifierProvider.value(
          value: complex.placeList[i],
          child: Container(
            height: deviceHeight * 0.3,
            child: PlaceItem(
              place: complex.placeList[i],
            ),
          ),
        ),
      ),
    );
  }
}
