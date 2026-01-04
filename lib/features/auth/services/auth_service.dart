import 'dart:convert';
import 'package:crypto/crypto.dart';
import 'package:inventory_system/core/config/app_config.dart';
import 'package:inventory_system/core/database/hive_service.dart';
import 'package:inventory_system/core/database/models/user_model.dart';
import 'package:hive/hive.dart';

class AuthService {
  static UserModel? _currentUser;

  static UserModel? get currentUser => _currentUser;

  static Box<UserModel> get _box => HiveService.getBox<UserModel>('users');

  static String hashPassword(String password) {
    final bytes = utf8.encode(password);
    final digest = sha256.convert(bytes);
    return digest.toString();
  }

  static Future<void> initDefaultAdmin() async {
    if (_box.isEmpty) {
      final admin = UserModel()
        ..username = AppConfig.defaultAdminUsername
        ..passwordHash = hashPassword(AppConfig.defaultAdminPassword)
        ..role = UserRole.admin
        ..permissions = ['all']
        ..isActive = true
        ..createdAt = DateTime.now()
        ..updatedAt = DateTime.now();

      final id = await _box.add(admin);
      admin.id = id;
      await admin.save();
    }
  }

  static Future<bool> login(String username, String password) async {
    final passwordHash = hashPassword(password);
    try {
      final user = _box.values.firstWhere(
        (u) => u.username == username,
      );

      if (user.passwordHash == passwordHash && user.isActive) {
        _currentUser = user;
        return true;
      }
    } catch (_) {}
    return false;
  }

  static void logout() {
    _currentUser = null;
  }

  static Future<bool> changePassword(
      String oldPassword, String newPassword) async {
    if (_currentUser == null) return false;

    final oldHash = hashPassword(oldPassword);
    if (_currentUser!.passwordHash != oldHash) return false;

    _currentUser!.passwordHash = hashPassword(newPassword);
    _currentUser!.updatedAt = DateTime.now();

    await _currentUser!.save();
    return true;
  }
}
