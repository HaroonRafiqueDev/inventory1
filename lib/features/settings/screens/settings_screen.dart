import 'package:flutter/material.dart';
import 'package:inventory_system/core/config/app_config.dart';
import 'package:inventory_system/features/settings/services/settings_service.dart';
import 'package:inventory_system/shared/utils/sample_data_service.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _businessNameController;
  late TextEditingController _currencyController;
  late TextEditingController _taxController;
  late TextEditingController _addressController;
  late TextEditingController _phoneController;
  bool _isDarkMode = false;

  @override
  void initState() {
    super.initState();
    final settings = SettingsService.settings;
    _businessNameController =
        TextEditingController(text: settings.businessName);
    _currencyController = TextEditingController(text: settings.currency);
    _taxController =
        TextEditingController(text: settings.taxPercentage.toString());
    _addressController = TextEditingController(text: settings.businessAddress);
    _phoneController = TextEditingController(text: settings.businessPhone);
    _isDarkMode = settings.isDarkMode;
  }

  @override
  void dispose() {
    _businessNameController.dispose();
    _currencyController.dispose();
    _taxController.dispose();
    _addressController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Center(
          child: Container(
            constraints: const BoxConstraints(maxWidth: 800),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('Business Profile',
                    style:
                        TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                const SizedBox(height: 24),
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(32),
                    child: Form(
                      key: _formKey,
                      child: Column(
                        children: [
                          TextFormField(
                            controller: _businessNameController,
                            decoration: const InputDecoration(
                                labelText: 'Business Name'),
                            validator: (value) => value == null || value.isEmpty
                                ? 'Required'
                                : null,
                          ),
                          const SizedBox(height: 16),
                          Row(
                            children: [
                              Expanded(
                                child: TextFormField(
                                  controller: _currencyController,
                                  decoration: const InputDecoration(
                                      labelText: 'Currency Symbol'),
                                ),
                              ),
                              const SizedBox(width: 16),
                              Expanded(
                                child: TextFormField(
                                  controller: _taxController,
                                  decoration: const InputDecoration(
                                      labelText: 'Default Tax (%)'),
                                  keyboardType: TextInputType.number,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 16),
                          TextFormField(
                            controller: _phoneController,
                            decoration: const InputDecoration(
                                labelText: 'Business Phone'),
                          ),
                          const SizedBox(height: 16),
                          TextFormField(
                            controller: _addressController,
                            decoration: const InputDecoration(
                                labelText: 'Business Address'),
                            maxLines: 2,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 32),
                const Text('Application Settings',
                    style:
                        TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                const SizedBox(height: 24),
                Card(
                  child: Column(
                    children: [
                      SwitchListTile(
                        title: const Text('Dark Mode'),
                        subtitle:
                            const Text('Switch between light and dark themes'),
                        value: _isDarkMode,
                        onChanged: (value) =>
                            setState(() => _isDarkMode = value),
                      ),
                      const Divider(height: 1),
                      ListTile(
                        title: const Text('App Version'),
                        trailing: Text(AppConfig.appVersion),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 32),
                const Text('Data Management',
                    style:
                        TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                const SizedBox(height: 24),
                Card(
                  child: Column(
                    children: [
                      ListTile(
                        title: const Text('Seed Sample Data'),
                        subtitle: const Text(
                            'Populate the database with dummy products, categories, and suppliers'),
                        trailing: const Icon(Icons.data_exploration),
                        onTap: _seedSampleData,
                      ),
                      const Divider(height: 1),
                      ListTile(
                        title: const Text('Clear All Data'),
                        subtitle: const Text(
                            'Permanently delete all records from the database'),
                        trailing:
                            const Icon(Icons.delete_forever, color: Colors.red),
                        onTap: _clearAllData,
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 32),
                SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: ElevatedButton(
                    onPressed: _saveSettings,
                    child: const Text('Save Settings',
                        style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.bold)),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _seedSampleData() async {
    await SampleDataService.seedData();
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text(
                'Sample data seeded successfully. Please refresh or restart to see changes.')),
      );
    }
  }

  void _clearAllData() async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Clear All Data?'),
        content: const Text(
            'This will permanently delete all products, sales, purchases, and settings. This action cannot be undone.'),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(context, false),
              child: const Text('Cancel')),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Delete Everything',
                style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );

    if (confirm == true) {
      await SampleDataService.clearAllData();
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('All data cleared successfully.')),
        );
      }
    }
  }

  void _saveSettings() async {
    if (_formKey.currentState!.validate()) {
      final settings = SettingsService.settings;
      settings.businessName = _businessNameController.text;
      settings.currency = _currencyController.text;
      settings.taxPercentage = double.tryParse(_taxController.text) ?? 0.0;
      settings.businessAddress = _addressController.text;
      settings.businessPhone = _phoneController.text;
      settings.isDarkMode = _isDarkMode;

      await SettingsService.updateSettings(settings);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Settings saved successfully')),
        );
      }
    }
  }
}
