import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tapsalon/provider/app_theme.dart';
import 'package:tapsalon/widget/main_page_place_item.dart';

import 'file:///C:/AndroidStudioProjects/Pro_tapsalon/tapsalon_flutter/tapsalon/lib/models/places_models/place_in_search.dart';

import '../provider/places.dart';
import '../screen/search_screen.dart';
//import '../widget/main_page_place_item.dart';

class HorizontalList extends StatelessWidget {
  const HorizontalList({
    @required this.listTitle,
    @required this.list,
  });

  final String listTitle;
  final List<PlaceInSearch> list;

  Future<void> cleanFilters(BuildContext context) async {
    Provider.of<Places>(context, listen: false).searchKey = '';
    Provider.of<Places>(context, listen: false).filterTitle.clear();
    Provider.of<Places>(context, listen: false).sProvinceId = '';
    Provider.of<Places>(context, listen: false).sType = '';
    Provider.of<Places>(context, listen: false).sField = '';
    Provider.of<Places>(context, listen: false).sFacility = '';
    Provider.of<Places>(context, listen: false).searchBuilder();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.only(right: 19.0),
              child: Text(listTitle,
                style: TextStyle(
                  fontFamily: 'Iransans',
                  color: AppTheme.black,
                  fontSize:
                  MediaQuery.of(context).textScaleFactor * 16.0,
                ),),
            ),
            Padding(
              padding: const EdgeInsets.only(left:16.0),
              child: InkWell(
                onTap: () {
                  cleanFilters(context);


                  Navigator.of(context)
                      .pushNamed(SearchScreen.routeName, arguments: 0);
                },
                child: Padding(
                  padding: const EdgeInsets.only(top: 2.0),
                  child: Text(
                    'همه',
                    style: TextStyle(
                      fontFamily: 'Iransans',
                      color: AppTheme.grey,
                      fontSize:
                          MediaQuery.of(context).textScaleFactor * 14.0,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
        Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height * 0.30,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            padding: EdgeInsets.all(10.0),
            itemCount: list.length,
            itemBuilder: (ctx, i) {
              return Container(
                  width: MediaQuery.of(context).size.width * 0.47,
                  height: MediaQuery.of(context).size.height * 0.25,
                  child: MainPagePlaceItem(
                    loadedPlace: list[i],
                  ));
            },
          ),
        ),
      ],
    );
  }
}
