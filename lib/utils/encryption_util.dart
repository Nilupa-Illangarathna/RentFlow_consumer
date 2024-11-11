import 'package:encrypt/encrypt.dart' as encrypt;
import 'dart:convert';

class EncryptionUtil {
  static final key = encrypt.Key.fromLength(32); // 32 bytes key for AES encryption
  static final iv = encrypt.IV.fromLength(16); // 16 bytes IV for AES encryption

  static Map<String, dynamic> encryptData(Map<String, dynamic> data) {
    final plainText = jsonEncode(data);
    final encrypter = encrypt.Encrypter(encrypt.AES(key));
    final encrypted = encrypter.encrypt(plainText, iv: iv);
    return {
      'encrypted': encrypted.base64,
      'key': key.base64,
      'iv': iv.base64,
    };
  }

  static Map<String, dynamic> decryptData(Map<String, dynamic> encryptedData) {
    final encrypter = encrypt.Encrypter(encrypt.AES(encrypt.Key.fromBase64(encryptedData['key'])));
    final decrypted = encrypter.decrypt64(encryptedData['encrypted'], iv: encrypt.IV.fromBase64(encryptedData['iv']));
    return jsonDecode(decrypted);
  }
}