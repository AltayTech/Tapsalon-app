import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tapsalon/models/city.dart';
import 'package:tapsalon/models/province.dart';
import 'package:tapsalon/models/role.dart';

import '../models/main_notifications.dart';
import '../models/notification.dart' as notification;
import '../models/rule_data.dart';
import '../models/searchDetails.dart';
import '../models/user_models/user.dart';
import '../provider/urls.dart';

class UserInfo with ChangeNotifier {
  List<RuleData> _ruleList = [RuleData(id: 0, title: '', content: '')];
  static SearchDetails _searchDetails_zero = SearchDetails(
    current_page: 1,
    from: 1,
    last_page: 0,
    last_page_url: '',
    next_page_url: '',
    path: '',
    prev_page_url: '',
    to: 10,
    total: 0,
  );

  static User _user_zero = User(
    id: 1,
    ostan: Province(id: 0, name: ''),
    city: City(
      id: 0,
      provinceId: 0,
      name: '',
      latitude: 0.0,
      longitude: 0.0,
    ),
    role: Role(id: 0, description: '', name: ''),
  );

  User _user = _user_zero;

  SearchDetails get notificationSearchDetails => _notificationSearchDetails;
  late String searchEndPoint;
  SearchDetails _notificationSearchDetails = _searchDetails_zero;

  List<notification.Notification> _notificationItems = [];

  User get user => _user;

  List<notification.Notification> get notificationItems => _notificationItems;

  Future<void> getUser() async {
    print('getUser');

    final url = Urls.rootUrl + Urls.userEndPoint;
    print(url);

    final prefs = await SharedPreferences.getInstance();

    _token = prefs.getString('token')!;

    try {
      final response = await post(Uri.parse(url), headers: {
        'Authorization': 'Bearer $_token',
      });

      final extractedData = json.decode(response.body);
      print(extractedData);

      User user = User.fromJson(extractedData);

      _user = user;

      notifyListeners();
    } catch (error) {
      print(error.toString());
      throw (error);
    }
  }

  late String _token;

  late String fname;

  late String lname;
  late String mobile;
  late String address;

  int gender = 1;
  int ostanId = 1;
  int cityId = 1;

  void endBuilder() {
    searchEndPoint = '';
    if (!(gender == null)) {
      searchEndPoint = searchEndPoint + '?gender=$gender';
    }
    if (!(fname == '')) {
      searchEndPoint = searchEndPoint + '&fname=$fname';
    }
    if (!(lname == '')) {
      searchEndPoint = searchEndPoint + '&lname=$lname';
    }

    if (!(ostanId == null)) {
      searchEndPoint = searchEndPoint + '&ostan_id=$ostanId';
    }
    if (!(cityId == null)) {
      searchEndPoint = searchEndPoint + '&city_id=$cityId';
    }
    if (!(mobile == null)) {
      searchEndPoint = searchEndPoint + '&mobile=$mobile';
    }
    if (!(address == null)) {
      searchEndPoint = searchEndPoint + '&address=$address';
    }
    print(searchEndPoint);
  }

  Future<void> sendCustomer() async {
    print('sendCustomer');

    final url = Urls.rootUrl + Urls.userEndPoint + searchEndPoint;
    print(url);

    final prefs = await SharedPreferences.getInstance();

    _token = prefs.getString('token')!;

    try {
      final response = await put(
        Uri.parse(url),
        headers: {
          'Authorization': 'Bearer $_token',
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
      );

      final extractedData = json.decode(response.body);
      print(extractedData);
      notifyListeners();
    } catch (error) {
      print(error.toString());
      throw (error);
    }
  }

  Future<void> getNotification() async {
    print('getNotification');

    final url = Urls.rootUrl + Urls.userEndPoint + '/notifications';
    print(url);

    final prefs = await SharedPreferences.getInstance();

    _token = prefs.getString('token')!;
    if (_token != null) {
      try {
        final response = await get(Uri.parse(url), headers: {
          'Authorization': 'Bearer $_token',
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        });

        final extractedData = json.decode(response.body);

        MainNotifications mainNotifications =
            MainNotifications.fromJson(extractedData);

        _notificationItems = mainNotifications.data;
        _notificationSearchDetails = SearchDetails(
          current_page: mainNotifications.current_page,
          first_page_url: mainNotifications.first_page_url,
          from: mainNotifications.from,
          last_page: mainNotifications.last_page,
          last_page_url: mainNotifications.last_page_url,
          next_page_url: mainNotifications.next_page_url,
          path: mainNotifications.path,
          per_page: mainNotifications.per_page,
          prev_page_url: mainNotifications.prev_page_url,
          to: mainNotifications.to,
          total: mainNotifications.total,
        );

        notifyListeners();
      } catch (error) {
        print(error.toString());
        throw (error);
      }
    }
  }

  List<RuleData> get ruleList => _ruleList;
}
