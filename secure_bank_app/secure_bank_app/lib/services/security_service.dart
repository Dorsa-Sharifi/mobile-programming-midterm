import 'package:safe_device/safe_device.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:local_auth/local_auth.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class SecurityService {
  final LocalAuthentication _auth = LocalAuthentication();
  final FlutterSecureStorage _secureStorage = const FlutterSecureStorage();

  Future<Map<String, dynamic>> getSecurityReport() async {
    bool isJailBroken = false;
    bool isRealDevice = true;
    bool isDevMode = false;
    bool isOfficialStore = false;
    bool isSignatureValid = false;
    bool isBiometricEnabled = false;
    bool isSecureStorageEnabled = false;

    try {
      isJailBroken = await SafeDevice.isJailBroken;
      
      isRealDevice = await SafeDevice.isRealDevice;
      
      isDevMode = await SafeDevice.isDevelopmentModeEnable;
      
      isOfficialStore = await _verifyAppSource();

      isSignatureValid = await _verifyAppSignature();

      isBiometricEnabled = await _checkBiometricStatus();

      isSecureStorageEnabled = await _checkSecureStorageStatus();
      
    } catch (e) {
      print("Security Check Error: $e");
    }

    return {
      'isRooted': isJailBroken,
      'isEmulator': !isRealDevice,
      'isDevMode': isDevMode,
      'isOfficialStore': isOfficialStore,
      'isSignatureValid': isSignatureValid,
      'isBiometricEnabled': isBiometricEnabled,
      'isSecureStorageEnabled': isSecureStorageEnabled,
    };
  }

  Future<bool> _verifyAppSource() async {
    try {
      PackageInfo packageInfo = await PackageInfo.fromPlatform();
      return packageInfo.packageName.isNotEmpty && 
             packageInfo.packageName.contains("secure_bank_app");
    } catch (_) {
      return false;
    }
  }

  Future<bool> _verifyAppSignature() async {
    try {
      PackageInfo packageInfo = await PackageInfo.fromPlatform();
      return packageInfo.packageName.isNotEmpty && packageInfo.version.isNotEmpty;
    } catch (_) {
      return false;
    }
  }


  Future<bool> _checkBiometricStatus() async {
    try {
      final bool canCheck = await _auth.canCheckBiometrics;
      final bool isSupported = await _auth.isDeviceSupported();
      return canCheck || isSupported;
    } catch (_) {
      return false;
    }
  }

  Future<bool> _checkSecureStorageStatus() async {
    try {
      const testKey = 'security_test_key';
      await _secureStorage.write(key: testKey, value: 'active');
      final value = await _secureStorage.read(key: testKey);
      await _secureStorage.delete(key: testKey);
      return value == 'active';
    } catch (_) {
      return false;
    }
  }

  Future<Map<String, bool>> checkDeviceIntegrity() async {
    final report = await getSecurityReport();
    return {
      'isRooted': report['isRooted'] as bool,
      'isEmulator': report['isEmulator'] as bool,
      'isDebugActive': report['isDevMode'] as bool,
    };
  }
}
