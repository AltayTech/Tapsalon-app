import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tapsalon/models/main_cities.dart';
import 'package:tapsalon/models/main_ostans.dart';

import '../models/city.dart';
import '../models/province.dart';
import '../provider/urls.dart';

class Cities with ChangeNotifier {
  City _selectedCity = City(
    id: 0,
    provinceId: 0,
    name: '',
    latitude: 0.0,
    longitude: 0.0,
//    description: '',
//    noUsers: 0,
  );

  City get selectedCity => _selectedCity;

  set selectedCity(City value) {
    _selectedCity = value;
  }

  List<City> _citiesItems = [];
  List<Province> _provincesItems = [];

  List<City> get citiesItems => _citiesItems;

  List<Province> get provincesItems => _provincesItems;

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
    int? _selectedCityId = prefs.getInt('selectedCity');
    if (_selectedCityId != null) {
      final url = Urls.rootUrl + Urls.citiesEndPoint + '/$_selectedCityId';
      print(url);

      try {
        final response = await get(Uri.parse(url));

        final extractedData = json.decode(response.body);
        print(extractedData);

        City dataRaw = City.fromJson(extractedData);
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
      final response = await get(Uri.parse(url));

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
        Uri.parse(url),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
      );

      final extractedData = json.decode(response.body);
      print(extractedData);
      MainCities dataRaw = MainCities.fromJson(extractedData);

      _citiesItems = dataRaw.data;

      notifyListeners();
    } catch (error) {
      print(error.toString());
      throw (error);
    }
  }

  Future<void> retrieveProvince() async {
    print('retrieveProvince');

    final url = Urls.rootUrl + Urls.provincesEndPoint;
    print(url);

    try {
      final response = await get(Uri.parse(url));

      final extractedData = json.decode(response.body);
      print(extractedData);
      MainOstans dataRaw = MainOstans.fromJson(extractedData);

      _provincesItems = dataRaw.data;

      notifyListeners();
    } catch (error) {
      print(error.toString());
      throw (error);
    }
  }
}
