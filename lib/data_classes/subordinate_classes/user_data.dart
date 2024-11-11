import 'dart:convert';

class UserData {
  late String _name;
  late String _email;
  late String _contactNumber;
  late String _password;

  UserData({
    required String name,
    required String email,
    required String contactNumber,
    required String password,
  })  : _name = name,
        _email = email,
        _contactNumber = contactNumber,
        _password = password;

  // Getters
  String get name => _name;
  String get email => _email;
  String get contactNumber => _contactNumber;
  String get password => _password;

  // Setters
  set name(String value) {
    _name = value;
  }

  set email(String value) {
    _email = value;
  }

  set contactNumber(String value) {
    _contactNumber = value;
  }

  set password(String value) {
    _password = value;
  }

  // Convert to JSON
  Map<String, dynamic> toJson() {
    return {
      'name': _name,
      'email': _email,
      'contactNumber': _contactNumber,
      'password': _password,
    };
  }

  // Create a UserData object from JSON
  factory UserData.fromJson(Map<String, dynamic> json) {
    return UserData(
      name: json['name'],
      email: json['email'],
      contactNumber: json['contactNumber'],
      password: json['password'],
    );
  }

  // Print method
  void printData() {
    print('Name: $_name');
    print('Email: $_email');
    print('Contact Number: $_contactNumber');
    print('Password: $_password');
  }
}
