import 'dart:io' show Platform;

class LoginRequest {
  final String email;
  final String password;
  final String? deviceId;
  final String? deviceName;
  final String? deviceType;

  const LoginRequest({
    required this.email,
    required this.password,
    this.deviceId,
    this.deviceName,
    this.deviceType,
  });

  Map<String, dynamic> toJson() {
    return {
      'email': email,
      'password': password,
      if (deviceId != null) 'deviceId': deviceId,
      if (deviceName != null) 'deviceName': deviceName,
      if (deviceType != null) 'deviceType': deviceType,
    };
  }

  /// Best-effort device type label; used when logging in.
  static String get currentDeviceType {
    if (Platform.isAndroid) return 'android';
    if (Platform.isIOS) return 'ios';
    return Platform.operatingSystem;
  }
}
