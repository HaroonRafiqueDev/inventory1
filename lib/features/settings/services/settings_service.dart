import 'package:inventory_system/core/config/app_config.dart';
import 'package:inventory_system/core/database/hive_service.dart';
import 'package:inventory_system/core/database/models/settings_model.dart';
import 'package:hive/hive.dart';

class SettingsService {
  static late SettingsModel _settings;

  static SettingsModel get settings => _settings;

  static Box<SettingsModel> get _box =>
      HiveService.getBox<SettingsModel>('settings');

  static Future<void> init() async {
    final existing = _box.values.firstOrNull;
    if (existing == null) {
      _settings = SettingsModel()
        ..businessName = AppConfig.appName
        ..currency = AppConfig.defaultCurrency
        ..dateFormat = AppConfig.defaultDateFormat
        ..taxPercentage = AppConfig.defaultTaxPercentage
        ..isDarkMode = false
        ..businessLogoPath = null
        ..invoiceFooterText = null
        ..businessAddress = null
        ..businessPhone = null
        ..updatedAt = DateTime.now();

      final id = await _box.add(_settings);
      _settings.id = id;
      await _settings.save();
    } else {
      _settings = existing;
    }
  }

  static Future<void> updateSettings(SettingsModel newSettings) async {
    _settings = newSettings;
    _settings.updatedAt = DateTime.now();
    await _settings.save();
  }
}
