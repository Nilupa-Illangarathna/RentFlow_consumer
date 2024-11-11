import 'dart:convert';
import 'package:flutter/material.dart';

import 'subordinate_classes/item_class.dart';
import 'subordinate_classes/user_data.dart';

class UserItemsData {
  late UserData _userData;
  late List<ItemData> _items;

  UserItemsData({
    required UserData userData,
    required List<ItemData> items,
  })  : _userData = userData,
        _items = items;

  // Getters
  UserData get userData => _userData;
  List<ItemData> get items => _items;

  // Setters
  set userData(UserData value) {
    _userData = value;
  }

  set items(List<ItemData> value) {
    _items = value;
  }

  // Convert to JSON
  Map<String, dynamic> toJson() {
    return {
      'userData': _userData.toJson(),
      'items': _items.map((item) => item.toJson()).toList(),
    };
  }

  // Create a UserItemsData object from JSON
  factory UserItemsData.fromJson(Map<String, dynamic> json) {
    return UserItemsData(
      userData: UserData.fromJson(json['userData']),
      items: List<ItemData>.from(json['items'].map((itemJson) => ItemData.fromJson(itemJson))),
    );
  }

  // Print method
  void printData() {
    print('User Data:');
    _userData.printData();
    print('Items:');
    _items.forEach((item) => item.printItemData());
  }


  // TODO: Method to calculate borrowed and due counts
  Map<String, int> calculateBorrowedDueCounts() {
    int borrowedCount = _items.where((item) => item.type == 'borrowed').length;
    int dueCount = _items.where((item) => item.type == 'due').length;
    return {
      'borrowed': borrowedCount,
      'due': dueCount,
    };
  }

  // TODO: Method to get profile data
  Map<String, dynamic> getProfileData() {
    return {
      'name': _userData.name,
      'isActive': true, // Assuming user is active for now
    };
  }

  // TODO: Method to filter due or borrowed items
  List<ItemData> filterItems({required String type}) {
    return _items.where((item) => item.type == type).toList();
  }
}
