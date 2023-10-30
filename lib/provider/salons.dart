import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart';

import '../models/places_models/place.dart';
import '../models/timing.dart';
import '../provider/urls.dart';

class Salons with ChangeNotifier {
  List<Timing> _itemTiming = [];
  late Place _itemPlace;

  List<Timing> get itemTiming => _itemTiming;

  Place get itemPlace => _itemPlace;

  Future<void> retrievePlace(int placeId) async {
    print('retrievePlace');

    final url = Urls.rootUrl + Urls.placesEndPoint + '/$placeId';
    print(url);

    try {
      final response = await get(Uri.parse(url));

      final extractedData = json.decode(response.body);

      print(extractedData);

      Place place = Place.fromJson(extractedData);

      _itemPlace = place;

      notifyListeners();
    } catch (error) {
      print(error.toString());
      throw (error);
    }
  }

  Future<void> retrievePlaceTiming(
    int placeId,
  ) async {
    print('retrievePlaceTiming');

    final url = Urls.rootUrl + Urls.placesEndPoint + '/$placeId' + '/timings';
    print(url);

    try {
      final response = await get(
        Uri.parse(url),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json'
        },
      );

      var extractedData = json.decode(response.body) as List<dynamic>;
      print(extractedData);

      List<Timing> timings = [];
      timings = extractedData.map((i) => Timing.fromJson(i)).toList();

      _itemTiming = timings;

      print(_itemTiming.length);
      notifyListeners();
    } catch (error) {
      print(error.toString());
      throw (error);
    }
  }
}
