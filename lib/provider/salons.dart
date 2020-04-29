import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:shamsi_date/shamsi_date.dart';
import 'package:tapsalon/models/place.dart';
import 'package:tapsalon/models/timing.dart';
import 'package:tapsalon/models/urls.dart';

import '../models/salon.dart';

class Salons with ChangeNotifier {
  List<Salon> _items = [];
  List<Timing> _itemTiming = [];
  Place _itemPlace;
  List<double> _hours = [];

  List<Map<String, List<Timing>>> _itemDayTiming = [];

  List<Timing> get itemTiming => _itemTiming;

  Place get itemPlace => _itemPlace;

  List<Salon> get items {
    return [..._items];
  }

  List<double> get hours => _hours;

  List<Map<String, List<Timing>>> get itemDayTiming => _itemDayTiming;

  Future<void> retrievePlace(int placeId) async {
    print('retrievePlace');

    final url = Urls.rootUrl + Urls.placesEndPoint + '/$placeId';
    print(url);

    try {
      final response = await get(url);

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
      int placeId, DateTime start, DateTime end) async {
    print('retrievePlaceTiming');

    final url = Urls.rootUrl + Urls.placesEndPoint + '/10' + '/timings';
    print(url);

    try {
      final response = await post(url,
          headers: {
            'Content-Type': 'application/json',
            'Accept': 'application/json'
          },
          body: json.encode(
            {
              'start': start.toString(),
              'end': end.toString(),
            },
          ));

      var extractedData = json.decode(response.body) as List<dynamic>;
      print(extractedData);

      List<Timing> timings = new List<Timing>();
      timings = extractedData.map((i) => Timing.fromJson(i)).toList();

      _itemTiming = timings;

      _itemDayTiming = [];
      for (int j = 0; j < 30; j++) {
        _itemDayTiming.add({j.toString(): []});
      }

      for (int i = 0; i < _itemTiming.length; i++) {
        Timing time = _itemTiming[i];
        int jalaliDay =
            Jalali.fromDateTime(DateTime.parse(time.date_start)).day;
        _itemDayTiming[jalaliDay][jalaliDay.toString()].add(time);
        print(jalaliDay.toString());
        print('main' +
            Jalali.fromDateTime(DateTime.parse(time.date_start)).toString());
      }

      print(_itemTiming.length);
      notifyListeners();
    } catch (error) {
      print(error.toString());
      throw (error);
    }
  }

  Future<void> produceTable() async {
    print('produceTable');
    _hours.clear();
    for (int i = 0; i < 96; i++) {
      _hours.add((0 + 0.25 * i));
    }

    try {
      notifyListeners();
    } catch (error) {
      print(error.toString());
      throw (error);
    }
  }

  Salon findById(String id) {
    return _items.firstWhere((prod) => prod.id == id);
  }

  void addSalon() {
    // _items.add(value);
    notifyListeners();
  }
}
