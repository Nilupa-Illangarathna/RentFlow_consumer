// regex.dart

class Regex {
  static final emailRegExp = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
  static final passwordRegExp = RegExp(r'^(?=.*[A-Z])(?=.*[!@#$%^&*(),.?":{}|<>]).{6,}$');
  static final mobileRegExp = RegExp(r'^\+?[0-9]{1,11}$');
}
