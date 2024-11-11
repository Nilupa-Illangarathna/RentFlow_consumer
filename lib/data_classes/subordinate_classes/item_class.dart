import 'dart:convert';
import 'dart:ui';

class ItemData {
  late String _id;
  late String _type; // Either "borrowed" or "due"
  late Color _backgroundColor;
  late String _itemName;
  late DateTime _completeDate; // Borrowed or Due Date
  late DateTime _returnDate; // Return Date (nullable)
  late bool _status; // true if returned, false if not returned
  late String _borrowedBy; // Name of the borrower

  ItemData({
    required String id,
    required String type,
    required Color backgroundColor,
    required String itemName,
    required DateTime completeDate,
    required returnDate,
    required bool status,
    required String borrowedBy,
  })  : _id = id,
        _type = type,
        _backgroundColor = backgroundColor,
        _itemName = itemName,
        _completeDate = completeDate,
        _returnDate = returnDate,
        _status = status,
        _borrowedBy = borrowedBy;

  // Getters
  String get id => _id;
  String get type => _type;
  Color get backgroundColor => _backgroundColor;
  String get itemName => _itemName;
  DateTime get completeDate => _completeDate;
  DateTime get returnDate => _returnDate;
  bool get status => _status;
  String get borrowedBy => _borrowedBy;

  // Setters
  set type(String value) {
    _type = value;
  }

  set backgroundColor(Color value) {
    _backgroundColor = value;
  }

  set itemName(String value) {
    _itemName = value;
  }

  set completeDate(DateTime value) {
    _completeDate = value;
  }

  set returnDate(DateTime value) {
    _returnDate = value;
  }

  set status(bool value) {
    _status = value;
  }

  set borrowedBy(String value) {
    _borrowedBy = value;
  }

  // Convert to JSON
  Map<String, dynamic> toJson() {
    return {
      'id': _id,
      'type': _type,
      'backgroundColor': '#${_backgroundColor.value.toRadixString(16)}',
      'itemName': _itemName,
      'completeDate': _completeDate.toIso8601String(),
      'returnDate': _returnDate?.toIso8601String(),
      'status': _status,
      'borrowedBy': _borrowedBy,
    };
  }

  // Create an ItemData object from JSON
  factory ItemData.fromJson(Map<String, dynamic> json) {
    return ItemData(
      id: json['id'],
      type: json['type'],
      backgroundColor: Color(int.parse(json['backgroundColor'].substring(1), radix: 16)),
      itemName: json['itemName'],
      completeDate: DateTime.parse(json['completeDate']),
      returnDate: json['returnDate'] != null ? DateTime.parse(json['returnDate']) : null,
      status: json['status'],
      borrowedBy: json['borrowedBy'],
    );
  }

  // Print method
  void printItemData() {
    print('Item ID: $_id');
    print('Item Type: $_type');
    print('Background Color: $_backgroundColor');
    print('Item Name: $_itemName');
    print('Complete Date: $_completeDate');
    print('Return Date: $_returnDate');
    print('Status: $_status');
    print('Borrowed By: $_borrowedBy');
  }
}
