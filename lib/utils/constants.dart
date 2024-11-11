class Constants {
  static const String baseUrl = '34.198.66.25';
  static const String salt = 'willow_user_password_salt_123!@#';

  Map<String, dynamic> toJson() {
    return {
      'baseUrl': baseUrl,
      'salt': salt,
    };
  }

  static Constants fromJson(Map<String, dynamic> json) {
    return Constants();
  }

  void printMethod() {
    print('BaseUrl: $baseUrl');
    print('Salt: $salt');
  }
}




// TODO:
Constants constants = Constants();