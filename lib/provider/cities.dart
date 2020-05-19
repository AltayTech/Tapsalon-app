import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'file:///C:/AndroidStudioProjects/Pro_tapsalon/tapsalon_flutter/tapsalon/lib/provider/urls.dart';

import '../models/city.dart';
import '../models/province.dart';

class Cities with ChangeNotifier {
  City _selectedCity = City(
    id: 0,
    provinceId: 0,
    name: '',
//    description: '',
//    noUsers: 0,
  );

  City get selectedCity => _selectedCity;

  set selectedCity(City value) {
    _selectedCity = value;
  }

  List<City> _citiesItems = [];
  List<Province> _ostansItems = [];

  List<City> get citiesItems => _citiesItems;

  List<Province> get ostansItems => _ostansItems;

  Future<void> setSelectedCity(City selectedCity) async {
    print('setSelectedCity');

    final prefs = await SharedPreferences.getInstance();
    prefs.setInt('selectedCity', selectedCity.id);

    _selectedCity = selectedCity;

    notifyListeners();
  }

  Future<void> getSelectedCity() async {
    print('getSelectedCity');

    final prefs = await SharedPreferences.getInstance();
    int _selectedCityId = prefs.getInt('selectedCity');
    if (_selectedCityId != null) {
      final url = Urls.rootUrl + Urls.citiesEndPoint + '/$_selectedCityId';
      print(url);

      try {
        final response = await get(url);

        final extractedData = json.decode(response.body);
        print(extractedData);

        City dataRaw = City.fromJson(extractedData);

//      print(dataRaw[0].description.toString());
//      print(dataRaw[0].id.toString());
        _selectedCity = dataRaw;

        notifyListeners();
      } catch (error) {
        print(error.toString());
        throw (error);
      }
    }
  }

  Future<void> retrieveCities() async {
    print('retrieveCities');

    final url = Urls.rootUrl + Urls.citiesEndPoint;

    try {
      final response = await get(url);

//      final extractedData = json.decode(response.body);
      Iterable extractedData = json.decode(response.body) as List;
      print(extractedData);

      List<City> dataRaw = extractedData.map((i) => City.fromJson(i)).toList();

      _citiesItems = dataRaw;

      notifyListeners();
    } catch (error) {
      print(error.toString());
      throw (error);
    }
  }

  Future<void> retrieveOstanCities(int ostanId) async {
    print('retrieveOstanCities');

    final url = Urls.rootUrl + Urls.provincesEndPoint + '/$ostanId/cities';
    print(url);

    try {
      final response = await get(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
      );

      Iterable extractedData = json.decode(response.body) as List;
      print(extractedData);

      List<City> dataRaw = extractedData.map((i) => City.fromJson(i)).toList();

      _citiesItems = dataRaw;

      notifyListeners();
    } catch (error) {
      print(error.toString());
      throw (error);
    }
  }

  Future<void> retrieveOstans() async {
    print('retrieveOstans');

    final url = Urls.rootUrl + Urls.provincesEndPoint;

    try {
      final response = await get(url);

      final extractedData = json.decode(response.body) as List;
      print(extractedData);
      List<Province> dataRaw =
          extractedData.map((i) => Province.fromJson(i)).toList();

//      print(dataRaw[0].description.toString());
      _ostansItems = dataRaw;

      notifyListeners();
    } catch (error) {
      print(error.toString());
      throw (error);
    }
  }
}
