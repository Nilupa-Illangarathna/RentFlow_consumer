import 'dart:convert';
import 'package:encrypt/encrypt.dart' as encrypt;
import 'package:hex/hex.dart';
import '../global/global_settings.dart';
import '../utils/constants.dart';
import 'package:crypto/crypto.dart';
import 'package:bcrypt/bcrypt.dart';



String encryptMessage(String message, String key, String iv) {
  final keyBytes = encrypt.Key.fromUtf8(key);
  final ivBytes = encrypt.IV.fromUtf8(iv);
  final encrypter = encrypt.Encrypter(encrypt.AES(keyBytes));
  final encrypted = encrypter.encrypt(message, iv: ivBytes);
  return encrypted.base64;
}

String decryptMessage(String encryptedBase64, String key, String iv) {
  final keyBytes = encrypt.Key.fromUtf8(key);
  final ivBytes = encrypt.IV.fromUtf8(iv);
  final encrypter = encrypt.Encrypter(encrypt.AES(keyBytes));
  final decrypted = encrypter.decrypt64(encryptedBase64, iv: ivBytes);
  return decrypted;
}

String hexToString(String hexValue) {
  List<int> bytes = HEX.decode(hexValue);
  String stringValue = String.fromCharCodes(bytes);
  return stringValue;
}

String stringToHex(String stringValue) {
  List<int> bytes = stringValue.codeUnits;
  String hexValue = HEX.encode(bytes);
  return hexValue;
}



// String generateHash(String password) {
//   String saltedPassword = password + globalData.salt; // Combine password and salt
//   List<int> bytes = utf8.encode(saltedPassword); // Encode combined string as UTF-8
//   Digest hash = sha256.convert(bytes); // Generate SHA-256 hash
//   return hash.toString(); // Return the hashed value
// }


String generateHash(String password) {
  // Generate a BCrypt hash with the salted password
  String hashedPassword = BCrypt.hashpw(password, globalData.salt);

  return hashedPassword; // Return the hashed value
}


void main() {
  String key = "12345678901234567890123456789012"; // 256-bit key
  String iv = "1234567890123456"; // 128-bit IV
  String message = "Hello, this is a secret message!";

  // Encrypt the message
  String encryptedMessage = encryptMessage(message, key, iv);
  print("Encrypted message: $encryptedMessage");

  // Decrypt the message
  String decryptedMessage = decryptMessage(encryptedMessage, key, iv);
  print("Decrypted message: $decryptedMessage");





  String hexValue = "31323334353637383930313233343536";
  String stringValue = hexToString(hexValue);
  print(stringValue);

  String newStringValue = "1234567890123456";
  String newHexValue = stringToHex(newStringValue);
  print(newHexValue);




  String password = "password123"; // Example password
  String hashedPassword = generateHash(password);
  print("Hashed password: $hashedPassword");
}
