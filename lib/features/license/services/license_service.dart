import 'dart:convert';
import 'package:crypto/crypto.dart';
import 'package:inventory_system/core/database/hive_service.dart';
import 'package:inventory_system/core/database/models/license_model.dart';
import 'package:hive/hive.dart';

class LicenseService {
  static Box<LicenseModel> get _box =>
      HiveService.getBox<LicenseModel>('license');

  static Future<LicenseModel?> getLicense() async {
    return _box.values.firstOrNull;
  }

  static Future<bool> isLicenseValid() async {
    final license = await getLicense();
    if (license == null) return false;

    if (license.isActivated) {
      // Basic validation: check if key matches a simple pattern or hash
      // In a real app, this would be more complex
      return _validateKey(license.licenseKey ?? '');
    }

    if (license.isTrial) {
      final now = DateTime.now();
      final trialExpiry = license.trialStartDate?.add(const Duration(days: 30));
      if (trialExpiry != null && now.isBefore(trialExpiry)) {
        return true;
      }
    }

    return false;
  }

  static Future<void> activateTrial() async {
    final existing = await getLicense();
    final license = existing ?? LicenseModel();

    license.isActivated = false;
    license.isTrial = true;
    license.trialStartDate = DateTime.now();
    license.updatedAt = DateTime.now();

    if (license.id == null) {
      final id = await _box.add(license);
      license.id = id;
      await license.save();
    } else {
      await license.save();
    }
  }

  static Future<bool> activateLicense(String key) async {
    if (_validateKey(key)) {
      final existing = await getLicense();
      final license = existing ?? LicenseModel();

      license.licenseKey = key;
      license.isActivated = true;
      license.isTrial = false;
      license.activationDate = DateTime.now();
      license.updatedAt = DateTime.now();

      if (license.id == null) {
        final id = await _box.add(license);
        license.id = id;
        await license.save();
      } else {
        await license.save();
      }
      return true;
    }
    return false;
  }

  static bool _validateKey(String key) {
    // Simple validation for demo: key must be 16 chars and start with 'INV-'
    if (key.length != 16) return false;
    if (!key.startsWith('INV-')) return false;

    // In a real app, you'd use a more secure algorithm
    return true;
  }

  static String generateTrialKey() {
    final now = DateTime.now().toIso8601String();
    final bytes = utf8.encode(now);
    final digest = sha256.convert(bytes);
    return 'INV-${digest.toString().substring(0, 12).toUpperCase()}';
  }
}
