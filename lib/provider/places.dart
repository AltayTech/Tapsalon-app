import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tapsalon/models/city.dart';
import 'package:tapsalon/models/image.dart';
import 'package:tapsalon/models/image_url.dart';
import 'package:tapsalon/models/main_regions.dart';
import 'package:tapsalon/models/places_models/main_places.dart';
import 'package:tapsalon/models/places_models/place.dart';
import 'package:tapsalon/models/places_models/place_in_search.dart';

import '../models/comment.dart';
import '../models/facility.dart';
import '../models/field.dart';
import '../models/main_comments.dart';
import '../models/places_models/favorite.dart';
import '../models/places_models/main_favorite.dart';
import '../models/priceRange.dart';
import '../models/region.dart';
import '../models/searchDetails.dart';
import '../provider/urls.dart';

class Places with ChangeNotifier {
//parameter definition
  List<PlaceInSearch> _items = [];

  List<Favorite> favoriteItems = [];
  List<Region> _itemsRegions = [];
  List<Facility> _itemsFacilities = [];
  List<Field> _itemsFields = [];
  PriceRange _itemPriceRange = PriceRange(
    min: '0',
    max: '200000',
  );
  List<Comment> _itemsComments = [];

  ImageObj _placeDefaultImage = ImageObj(
      id: 0,
      filename: '',
      url: ImageUrl(
        medium: 'assets/images/place_placeholder.jpeg',
        large: 'assets/images/place_placeholder.jpeg',
        thumb: 'assets/images/place_placeholder.jpeg',
      ));
  ImageObj _gymDefaultImage = ImageObj(
      id: 0,
      filename: '',
      url: ImageUrl(
        medium: 'assets/images/gym_placeholder.jpg',
        large: 'assets/images/gym_placeholder.jpg',
        thumb: 'assets/images/gym_placeholder.jpg',
      ));

  ImageObj _entDefaultImage = ImageObj(
      id: 0,
      filename: '',
      url: ImageUrl(
        medium: 'assets/images/ent_placeholder.jpg',
        large: 'assets/images/ent_placeholder.jpg',
        thumb: 'assets/images/ent_placeholder.jpg',
      ));

  //search parameters
  String searchKey = '';
  var _sPage = 1;
  var _sPerPage = 10;
  var _sPlaceType = '';

  var _sProvinceId = '';
  var _sCityId = '';
  var _sField = '';
  var _sFacility = '';
  var _sOrderBy = 'name';
  var _sSort = 'DESC';
  var _sRange = '';
  var _sRegion = '';

  List<String> filterTitle = [];
  static SearchDetails _searchDetailsZero = SearchDetails(
    current_page: 1,
    from: 1,
    last_page: 0,
    last_page_url: '',
    next_page_url: '',
    path: '',
    per_page: 10,
    prev_page_url: '',
    to: 10,
    total: 10,
  );
  SearchDetails _placeSearchDetails = _searchDetailsZero;
  SearchDetails _favoriteComplexSearchDetails = _searchDetailsZero;
  SearchDetails _facilitiesSearchDetails = _searchDetailsZero;
  SearchDetails _fieldsSearchDetails = _searchDetailsZero;

  Place _itemPlace;

  SearchDetails _commentsSearchDetails;

  bool isLiked;

  Map<String, String> searchBody = {};

  Place get itemPlace => _itemPlace;

  SearchDetails get favoriteComplexSearchDetails =>
      _favoriteComplexSearchDetails;

  //Methods

  void searchBuilder() {
    searchBody = {
      'name': searchKey,
      'page': _sPage.toString(),
      'per_page': _sPerPage.toString(),
      'order': _sSort,
      'orderby': _sOrderBy,
      'range': _sRange,
      'place_type_id': _sPlaceType,
      'ostan_id': _sProvinceId,
      'city_id': _sCityId,
      'region_id': _sRegion,
      'fields': _sField,
      'facilities': _sFacility,
    };
    removeNullAndEmptyParams(searchBody);
  }

  void removeNullAndEmptyParams(Map<String, Object> mapToEdit) {
// Remove all null values; they cause validation errors
    final keys = mapToEdit.keys.toList(growable: false);
    for (String key in keys) {
      final value = mapToEdit[key];
      if (value == null) {
        mapToEdit.remove(key);
      } else if (value is String) {
        if (value.isEmpty) {
          mapToEdit.remove(key);
        }
      } else if (value is Map) {
        removeNullAndEmptyParams(value);
      }
    }
  }

//getters and setters

  get sPage => _sPage;

  set sPage(value) {
    _sPage = value;
  }

  get sPerPage => _sPerPage;

  set sPerPage(value) {
    _sPerPage = value;
  }

  get sPlaceType => _sPlaceType;

  set sPlaceType(value) {
    _sPlaceType = value;
  }

  get sProvinceId => _sProvinceId;

  set sProvinceId(value) {
    _sProvinceId = value;
  }

  get sCityId => _sCityId;

  set sCityId(value) {
    _sCityId = value;
  }

  get sField => _sField;

  set sField(value) {
    _sField = value;
  }

  get sFacility => _sFacility;

  set sFacility(value) {
    _sFacility = value;
  }

  get sOrderBy => _sOrderBy;

  set sOrderBy(value) {
    _sOrderBy = value;
  }

  get sSort => _sSort;

  set sSort(value) {
    _sSort = value;
  }




  get sRange => _sRange;

  set sRange(value) {
    _sRange = value;
  }

  List<PlaceInSearch> get items => _items;

  List<Region> get itemsRegions => _itemsRegions;

  SearchDetails get placeSearchDetails =>
      _placeSearchDetails; //data transportation

  List<Facility> get itemsFacilities => _itemsFacilities;

  List<Field> get itemsFields => _itemsFields;

  SearchDetails get facilitiesSearchDetails => _facilitiesSearchDetails;

  SearchDetails get fieldsSearchDetails => _fieldsSearchDetails;

  PriceRange get itemPriceRange => _itemPriceRange;

  get sRegion => _sRegion;

  set sRegion(value) {
    _sRegion = value;
  }

  SearchDetails get commentsSearchDetails => _commentsSearchDetails;

  List<Comment> get itemsComments => _itemsComments;

  ImageObj get placeDefaultImage => _placeDefaultImage;

  ImageObj get gymDefaultImage => _gymDefaultImage;

  ImageObj get entDefaultImage => _entDefaultImage;

  Future<void> searchItem() async {
    print('searchItem');

    final url = Urls.rootUrl + Urls.placesEndPoint;
    Uri uri = Uri.parse(url);
    final newUrl = uri.replace(queryParameters: searchBody);
    print(url);
    print(newUrl.queryParameters.toString());

    try {
      final response = await get(
        newUrl,
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          'version': Urls.versionCode
        },
      );

      print(response.statusCode.toString());
      if (response.statusCode == 200) {
        final extractedData = json.decode(response.body);
        print(extractedData.toString());

        MainPlaces mainPlaces = MainPlaces.fromJson(extractedData);
        print(response.headers.toString());
        _items.clear();
        _items = mainPlaces.data;
        print('searchItem' + _items.length.toString());

        _placeSearchDetails = SearchDetails(
          current_page: mainPlaces.current_page,
          first_page_url: mainPlaces.first_page_url,
          from: mainPlaces.from,
          last_page: mainPlaces.last_page,
          last_page_url: mainPlaces.last_page_url,
          next_page_url: mainPlaces.next_page_url,
          path: mainPlaces.path,
          per_page: mainPlaces.per_page,
          prev_page_url: mainPlaces.prev_page_url,
          to: mainPlaces.to,
          total: mainPlaces.total,
        );
        print(_placeSearchDetails.total.toString());
        print('searchItem' + _items.length.toString());
      } else {
        _items = [];
        print('_items errrorrr' + _items.length.toString());
      }
      notifyListeners();
    } catch (error) {
      print(error.toString());
      throw (error);
    }
    print('searchItem ffff' + _items.length.toString());
  }

  Future<List<PlaceInSearch>> retrieveCityPlaces(
      int cityId, String orderby) async {
    print('retrieveCityPlaces');
    String url = '';
    if (cityId == 0) {
      url = Urls.rootUrl + Urls.placesEndPoint;
    } else if (orderby != '') {
      url = Urls.rootUrl +
          Urls.placesEndPoint +
          '?city_id=$cityId' +
          '&orderby=$orderby';
    } else {
      url = Urls.rootUrl + Urls.placesEndPoint + '?city_id=$cityId';
    }
    print(url);
    List<PlaceInSearch> loadedPlaces = [];

    try {
      final response = await get(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          'version': Urls.versionCode
        },
      );
      if (response.statusCode == 200) {
        final extractedData = json.decode(response.body);
        print(extractedData.toString());

        MainPlaces mainPlaces = MainPlaces.fromJson(extractedData);
        print(response.headers.toString());
        loadedPlaces.clear();
        loadedPlaces = mainPlaces.data;

        print(_placeSearchDetails.total.toString());
      } else {
        loadedPlaces = [];
      }
      notifyListeners();
    } catch (error) {
      print(error.toString());
      throw (error);
    }
    return loadedPlaces;
  }

  Future<List<PlaceInSearch>> retrieveNewItemInCity(
      City selectedCity, String orderby) async {
    List<PlaceInSearch> loadedPlaces = [];

    loadedPlaces = await retrieveCityPlaces(selectedCity.id, orderby);

    return loadedPlaces;
  }

  Future<void> retrieveRegions(int cityId) async {
    print('retrieveRegions');

    final url = Urls.rootUrl + '/api/cities/$cityId/regions';
    print(url);

    try {
      final response = await get(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          'version': Urls.versionCode
        },
      );
      if (response.statusCode == 200) {
        final extractedData = json.decode(response.body);
        print(extractedData);

        MainRegions mainRegions = MainRegions.fromJson(extractedData);

        _itemsRegions.clear();
        _itemsRegions.addAll(mainRegions.data);

        print(_placeSearchDetails.total.toString());
      } else {
        _itemsRegions = [];
      }
      notifyListeners();
    } catch (error) {
      print(error.toString());
      throw (error);
    }
  }

  Future<void> retrieveComment(int placeId) async {
    print('retrieveComment');
    final url = Urls.rootUrl + Urls.placesEndPoint + '/$placeId/comments';
    print(url);
    try {
      final response = await get(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          'version': Urls.versionCode
        },
      );
      if (response.statusCode == 200) {
        final extractedData = json.decode(response.body);
        print(extractedData.toString());

        MainComments mainComments = MainComments.fromJson(extractedData);
        print(response.headers.toString());
        _itemsComments.clear();
        _itemsComments.addAll(mainComments.data);

        _commentsSearchDetails = SearchDetails(
          current_page: mainComments.current_page,
          first_page_url: mainComments.first_page_url,
          from: mainComments.from,
          last_page: mainComments.last_page,
          last_page_url: mainComments.last_page_url,
          next_page_url: mainComments.next_page_url,
          path: mainComments.path,
          per_page: mainComments.per_page,
          prev_page_url: mainComments.prev_page_url,
          to: mainComments.to,
          total: mainComments.total,
        );
        print(_placeSearchDetails.total.toString());
      } else {
        _itemsRegions = [];
      }
      notifyListeners();
    } catch (error) {
      print(error.toString());
      throw (error);
    }
  }

  Future<void> sendComment(
      int placeId, String content, double rate, String subject) async {
    print('sendComment');

    final url = Urls.rootUrl + Urls.commentEndPoint;
    print(url);

    final prefs = await SharedPreferences.getInstance();

    var _token = prefs.getString('token');
    print(_token);

    try {
      final response = await post(
        url,
        headers: {
          'Authorization': 'Bearer $_token',
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          'version': Urls.versionCode
        },
        body: json.encode(
          {
            'place_id': placeId,
            'content': content,
            'rate': rate,
            'subject': subject,
          },
        ),
      );
      print(response.body);

      if (response.statusCode == 200) {
        final extractedData = json.decode(response.body);
        print(extractedData.toString());
      }
      notifyListeners();
    } catch (error) {
      print(error.toString());
      throw (error);
    }
  }

  Future<void> sendCommentReport(
    int placeId,
    int commentId,
  ) async {
    print('sendCommentReport');

    final url = Urls.rootUrl + Urls.commentEndPoint;
    print(url);

    final prefs = await SharedPreferences.getInstance();

    var _token = prefs.getString('token');
    print(_token);

    try {
      final response = await post(
        url,
        headers: {
          'Authorization': 'Bearer $_token',
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          'version': Urls.versionCode
        },
        body: json.encode(
          {
            'place_id': placeId,
            'comment_ir': commentId,
          },
        ),
      );

      if (response.statusCode == 200) {
        final extractedData = json.decode(response.body);
        print(extractedData.toString());
      }
      notifyListeners();
    } catch (error) {
      print(error.toString());
      throw (error);
    }
  }

  Future<void> retrieveLikes(int placeId) async {
    print('retrieveLikes');

    final url = Urls.rootUrl + '/api/places/$placeId/liked';
    print(url);

    try {
      final prefs = await SharedPreferences.getInstance();

      var _token = prefs.getString('token');
      final response = await get(
        url,
        headers: {
          'Authorization': 'Bearer $_token',
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          'version': Urls.versionCode
        },
      );
      if (response.statusCode == 200) {
        final extractedData = json.decode(response.body);
        print(extractedData.toString());

        isLiked = extractedData['liked'];
      } else {
        isLiked = false;
      }
      notifyListeners();
    } catch (error) {
      print(error.toString());
      throw (error);
    }
  }

  Future<bool> sendLike(int placeId) async {
    print('sendLike');

    final url = Urls.rootUrl + Urls.likePlaceEndPoint;
    print(url);

    final prefs = await SharedPreferences.getInstance();

    var _token = prefs.getString('token');
    print(_token);

    try {
      final response = await post(url,
          headers: {
            'Authorization': 'Bearer $_token',
            'Content-Type': 'application/json',
            'Accept': 'application/json',
            'version': Urls.versionCode
          },
          body: json.encode({
            'place_id': placeId,
          }));
      print(response.body);

      if (response.statusCode >= 200 && response.statusCode < 300) {
        final extractedData = json.decode(response.body);
        print(extractedData.toString());
        notifyListeners();

        return true;
      } else {
        notifyListeners();

        return false;
      }
    } catch (error) {
      print(error.toString());
      throw (error);
    }
  }

  Future<void> retrieveFacilities() async {
    print('retrieveFacilities');

    final url = Urls.rootUrl + Urls.facilitiesEndPoint;
    print(url);

    try {
      final response = await get(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          'version': Urls.versionCode
        },
      );
      if (response.statusCode == 200) {
        final extractedData = json.decode(response.body) as List;
        print(extractedData.toString());

        List<Facility> dataRaw = new List<Facility>();
        dataRaw = extractedData.map((i) => Facility.fromJson(i)).toList();

        _itemsFacilities.clear();
        _itemsFacilities.addAll(dataRaw);
        print(_itemsFacilities[0].name.toString());
      } else {
        _itemsRegions = [];
      }
      notifyListeners();
    } catch (error) {
      print(error.toString());
      throw (error);
    }
  }

  Future<void> retrieveFields() async {
    print('retrieveFields');

    final url = Urls.rootUrl + Urls.fieldsEndPoint;
    print(url);

    try {
      final response = await get(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          'version': Urls.versionCode
        },
      );
      if (response.statusCode == 200) {
        final extractedData = json.decode(response.body) as List;
        print(extractedData.toString());

        List<Field> dataRaw = new List<Field>();
        dataRaw = extractedData.map((i) => Field.fromJson(i)).toList();

        _itemsFields.clear();
        _itemsFields.addAll(dataRaw);
      } else {
        _itemsRegions = [];
      }
      notifyListeners();
    } catch (error) {
      print(error.toString());
      throw (error);
    }
  }

  Future<void> retrievePriceRange() async {
    print('retrievePriceRange');

    final url = Urls.rootUrl + Urls.getPriceRangeEndPoint;
    print(url);

    try {
      final response = await get(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          'version': Urls.versionCode
        },
      );
      if (response.statusCode == 200) {
        final extractedData = json.decode(response.body);
        print(extractedData.toString());

        PriceRange priceRange = PriceRange.fromJson(extractedData);
        print(response.headers.toString());
        _itemPriceRange = priceRange;
      }
      notifyListeners();
    } catch (error) {
      print(error.toString());
      throw (error);
    }
  }

  Future<void> retrievePlace(int placeId) async {
    print('retrievePlace');

    final url = Urls.rootUrl + Urls.placesEndPoint + '/$placeId';
    print(url);

    try {
      final response = await get(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          'version': Urls.versionCode
        },
      );

      final extractedData = json.decode(response.body);

      print(extractedData);

      Place place = Place.fromJson(extractedData);
      print(place.name);

      _itemPlace = place;

      notifyListeners();
    } catch (error) {
      print(error.toString());
      throw (error);
    }
  }

  Future<void> retrieveFavoriteComplex() async {
    print('retrieveFavoriteComplex');

    final url = Urls.rootUrl + Urls.userLikesEndPoint;
    print(url);

    final prefs = await SharedPreferences.getInstance();

    var _token = prefs.getString('token');
    print(_token);

    try {
      final response = await get(
        url,
        headers: {
          'Authorization': 'Bearer $_token',
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          'version': Urls.versionCode
        },
      );
      print(response.body);

      if (response.statusCode >= 200 && response.statusCode < 300) {
        final extractedData = json.decode(response.body);

        MainFavorite mainComplexesSearch = MainFavorite.fromJson(extractedData);
        print(response.headers.toString());
        favoriteItems.clear();
        favoriteItems.addAll(mainComplexesSearch.data);

        _favoriteComplexSearchDetails = SearchDetails(
          current_page: mainComplexesSearch.current_page,
          first_page_url: mainComplexesSearch.first_page_url,
          from: mainComplexesSearch.from,
          last_page: mainComplexesSearch.last_page,
          last_page_url: mainComplexesSearch.last_page_url,
          next_page_url: mainComplexesSearch.next_page_url,
          path: mainComplexesSearch.path,
          per_page: mainComplexesSearch.per_page,
          prev_page_url: mainComplexesSearch.prev_page_url,
          to: mainComplexesSearch.to,
          total: mainComplexesSearch.total,
        );

        print(extractedData.toString());
        notifyListeners();

        return true;
      } else {
        notifyListeners();

        return false;
      }
    } catch (error) {
      print(error.toString());
      throw (error);
    }
  }
}
