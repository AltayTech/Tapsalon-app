import 'package:flutter/foundation.dart';

class UserInComment with ChangeNotifier {
  final int id;
  final String fname;
  final String lname;
  final int role_id;
  final int gender;
  final String phone;
  final String mobile;
  final int no_comments;
  final int no_likes;
  final int no_reserves;
  final String wallet;
  final String created_at;
  final String updated_at;

  UserInComment({
    required this.id,
    required  this.fname,
    required this.lname,
    required  this.role_id,
    required  this.gender,
    required this.phone,
    required  this.mobile,
    required  this.no_comments,
    required  this.no_likes,
    required  this.no_reserves,
    required  this.wallet,
    required  this.created_at,
    required  this.updated_at,
  });

  factory UserInComment.fromJson(Map<String, dynamic> parsedJson) {
    return UserInComment(
      id: parsedJson['id'],
      fname: parsedJson['fname'],
      lname: parsedJson['lname'],
      role_id: parsedJson['role_id'],
      gender: parsedJson['gender'],
      phone: parsedJson['phone'],
      mobile: parsedJson['mobile'],
      no_comments: parsedJson['no_comments'],
      no_likes: parsedJson['no_likes'],
      no_reserves: parsedJson['no_reserves'],
      wallet: parsedJson['wallet'],
      created_at: parsedJson['created_at'],
      updated_at: parsedJson['updated_at'],
    );
  }
}
