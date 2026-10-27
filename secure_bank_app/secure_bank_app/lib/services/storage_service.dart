import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class StorageService {
  final _storage = const FlutterSecureStorage();
  static const _tokenKey = 'secure_auth_token';
  static const _phoneKey = 'secure_user_phone'; 

  Future<void> saveToken(String token) async {
    await _storage.write(key: _tokenKey, value: token);
  }

  Future<String?> getToken() async {
    return await _storage.read(key: _tokenKey);
  }


  Future<void> savePhoneNumber(String phone) async {
    await _storage.write(key: _phoneKey, value: phone);
  }

  
  Future<String?> getPhoneNumber() async {
    return await _storage.read(key: _phoneKey);
  }


  Future<void> deleteToken() async {
    await _storage.delete(key: _tokenKey);
    await _storage.delete(key: _phoneKey); 
  }
}
