/// Application-wide configuration constants
class AppConfig {
  // App Info
  static const String appName = 'Top Store';
  static const String appVersion = '1.0.0';

  // License
  static const bool enableTrialMode = true;
  static const int trialDays = 30;

  // Default Admin Credentials
  static const String defaultAdminUsername = 'admin';
  static const String defaultAdminPassword = 'admin123';

  // Pagination
  static const int defaultPageSize = 50;

  // Stock Alerts
  static const int lowStockThresholdDefault = 10;

  // Date Format
  static const String defaultDateFormat = 'dd/MM/yyyy';
  static const String defaultDateTimeFormat = 'dd/MM/yyyy HH:mm';

  // Currency
  static const String defaultCurrency = '\$';

  // Tax
  static const double defaultTaxPercentage = 0.0;

  // Database
  static const String databaseName = 'inventory_db';

  // Backup
  static const String backupFilePrefix = 'inventory_backup';
  static const String backupFileExtension = '.json';
}
