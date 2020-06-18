import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tapsalon/models/place_in_search.dart';
import 'package:tapsalon/widget/main_page_place_item.dart';

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
              child: Text(listTitle),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: InkWell(
                onTap: () {
                  cleanFilters(context);
//                  Provider.of<Complexes>(context, listen: false)
//                      .sType = '3';

                  Navigator.of(context)
                      .pushNamed(SearchScreen.routeName, arguments: 0);
                },
                child: Wrap(
                  direction: Axis.horizontal,
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.only(top: 2.0),
                      child: Text(
                        'همه',
                        style: TextStyle(
                          fontFamily: 'Iransans',
                          fontSize:
                              MediaQuery.of(context).textScaleFactor * 12.0,
                        ),
                      ),
                    ),
                    Icon(
                      Icons.arrow_forward_ios,
                      size: 20,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
        Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height * 0.35,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            padding: EdgeInsets.all(10.0),
            itemCount: list.length,
            itemBuilder: (ctx, i) {
              return Container(
                  width: MediaQuery.of(context).size.width * 0.47,
                  height: MediaQuery.of(context).size.height * 0.35,
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
