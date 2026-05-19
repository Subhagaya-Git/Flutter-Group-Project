import 'package:flutter/material.dart';
import 'services/settings_service.dart';
import 'main.dart';

class AppSettingsPage extends StatefulWidget {
  final SettingsService settingsService;

  const AppSettingsPage({required this.settingsService, super.key});

  @override
  State<AppSettingsPage> createState() => _AppSettingsPageState();
}

class _AppSettingsPageState extends State<AppSettingsPage> {
  late bool _notificationsEnabled;
  late bool _soundEnabled;
  late bool _vibrationEnabled;
  late bool _analyticsEnabled;
  late String _themeMode;
  late String _languageCode;
  late String _currencyCode;
  bool _isLoaded = false;

  @override
  void initState() {
    super.initState();
    _loadSettings();
  }

  Future<void> _loadSettings() async {
    await widget.settingsService.init();
    if (!mounted) return;

    setState(() {
      _notificationsEnabled = widget.settingsService.isNotificationsEnabled();
      _soundEnabled = widget.settingsService.isSoundEnabled();
      _vibrationEnabled = widget.settingsService.isVibrationEnabled();
      _analyticsEnabled = widget.settingsService.isAnalyticsEnabled();
      _themeMode = widget.settingsService.getThemeMode();
      _languageCode = widget.settingsService.getLanguageCode();
      _currencyCode = widget.settingsService.getCurrencyCode();
      _isLoaded = true;
    });
  }

  void _updateThemeMode(String newThemeMode) async {
    setState(() {
      _themeMode = newThemeMode;
    });
    await widget.settingsService.setThemeMode(newThemeMode);

    final themeMode = _stringToThemeMode(newThemeMode);
    MyApp.of(context)?.updateThemeMode(themeMode);

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Theme changed to ${newThemeMode.capitalize()}'),
          duration: const Duration(seconds: 2),
          backgroundColor: Colors.black87,
        ),
      );
    }
  }

  ThemeMode _stringToThemeMode(String mode) {
    switch (mode) {
      case 'light':
        return ThemeMode.light;
      case 'dark':
        return ThemeMode.dark;
      default:
        return ThemeMode.system;
    }
  }

  void _updateNotifications(bool value) async {
    setState(() {
      _notificationsEnabled = value;
    });
    await widget.settingsService.setNotificationsEnabled(value);
    _showSettingUpdatedSnackBar('Notifications ${value ? 'enabled' : 'disabled'}');
  }

  void _updateSound(bool value) async {
    setState(() {
      _soundEnabled = value;
    });
    await widget.settingsService.setSoundEnabled(value);
    _showSettingUpdatedSnackBar('Sound ${value ? 'enabled' : 'disabled'}');
  }

  void _updateVibration(bool value) async {
    setState(() {
      _vibrationEnabled = value;
    });
    await widget.settingsService.setVibrationEnabled(value);
    _showSettingUpdatedSnackBar('Vibration ${value ? 'enabled' : 'disabled'}');
  }

  void _updateAnalytics(bool value) async {
    setState(() {
      _analyticsEnabled = value;
    });
    await widget.settingsService.setAnalyticsEnabled(value);
    _showSettingUpdatedSnackBar('Analytics ${value ? 'enabled' : 'disabled'}');
  }

  void _updateLanguage(String newLanguage) async {
    setState(() {
      _languageCode = newLanguage;
    });
    await widget.settingsService.setLanguageCode(newLanguage);
    _showSettingUpdatedSnackBar('Language updated');
  }

  void _updateCurrency(String newCurrency) async {
    setState(() {
      _currencyCode = newCurrency;
    });
    await widget.settingsService.setCurrencyCode(newCurrency);
    
    if (mounted) {
      MyApp.of(context)?.updateCurrencyCode(newCurrency);
    }
    
    _showSettingUpdatedSnackBar('Currency changed to $newCurrency');
  }

  void _showSettingUpdatedSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        duration: const Duration(seconds: 2),
        backgroundColor: Colors.black87,
      ),
    );
  }

  void _showResetConfirmationDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Reset Settings'),
          content: const Text(
            'Are you sure you want to reset all settings to their default values? This action cannot be undone.',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () async {
                await widget.settingsService.resetToDefaults();
                _loadSettings();
                Navigator.pop(context);
                _showSettingUpdatedSnackBar('Settings reset to defaults');
              },
              child: const Text(
                'Reset',
                style: TextStyle(color: Colors.red),
              ),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    if (!_isLoaded) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text('Settings'),
        centerTitle: true,
      ),
      body: ListView(
        children: [
          // Display Settings Section
          _buildSectionHeader('Display Settings'),
          _buildSettingsCard(
            child: Column(
              children: [
                ListTile(
                  leading: Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: Theme.of(context).brightness == Brightness.dark
                          ? Colors.white.withOpacity(0.2)
                          : Colors.black.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Icon(
                      Icons.brightness_4,
                      color: Theme.of(context).brightness == Brightness.dark
                          ? Colors.white
                          : Colors.black,
                    ),
                  ),
                  title: const Text('Theme'),
                  subtitle: const Text('Choose app theme'),
                  trailing: DropdownButton<String>(
                    value: _themeMode,
                    items: const [
                      DropdownMenuItem(value: 'light', child: Text('Light')),
                      DropdownMenuItem(value: 'dark', child: Text('Dark')),
                      DropdownMenuItem(value: 'system', child: Text('System')),
                    ],
                    onChanged: (value) {
                      if (value != null) {
                        _updateThemeMode(value);
                      }
                    },
                    underline: const SizedBox(),
                  ),
                ),
                const Divider(height: 1),
                ListTile(
                  leading: Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: Theme.of(context).brightness == Brightness.dark
                          ? Colors.white.withOpacity(0.2)
                          : Colors.black.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Icon(
                      Icons.language,
                      color: Theme.of(context).brightness == Brightness.dark
                          ? Colors.white
                          : Colors.black,
                    ),
                  ),
                  title: const Text('Language'),
                  subtitle: const Text('Select app language'),
                  trailing: DropdownButton<String>(
                    value: _languageCode,
                    items: const [
                      DropdownMenuItem(value: 'en', child: Text('English')),
                      DropdownMenuItem(value: 'es', child: Text('Español')),
                      DropdownMenuItem(value: 'fr', child: Text('Français')),
                    ],
                    onChanged: (value) {
                      if (value != null) {
                        _updateLanguage(value);
                      }
                    },
                    underline: const SizedBox(),
                  ),
                ),
                const Divider(height: 1),
                ListTile(
                  leading: Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: Theme.of(context).brightness == Brightness.dark
                          ? Colors.white.withOpacity(0.2)
                          : Colors.black.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Icon(
                      Icons.attach_money,
                      color: Theme.of(context).brightness == Brightness.dark
                          ? Colors.white
                          : Colors.black,
                    ),
                  ),
                  title: const Text('Currency'),
                  subtitle: const Text('Display prices in'),
                  trailing: DropdownButton<String>(
                    value: _currencyCode,
                    items: const [
                      DropdownMenuItem(value: 'USD', child: Text('USD (\$)')),
                      DropdownMenuItem(value: 'LKR', child: Text('LKR (Rs)')),
                      DropdownMenuItem(value: 'EUR', child: Text('EUR (€)')),
                      DropdownMenuItem(value: 'GBP', child: Text('GBP (£)')),
                    ],
                    onChanged: (value) {
                      if (value != null) {
                        _updateCurrency(value);
                      }
                    },
                    underline: const SizedBox(),
                  ),
                ),
              ],
            ),
          ),

          // Notification Settings Section
          _buildSectionHeader('Notifications & Sound'),
          _buildSettingsCard(
            child: Column(
              children: [
                SwitchListTile(
                  secondary: Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: Theme.of(context).brightness == Brightness.dark
                          ? Colors.white.withOpacity(0.2)
                          : Colors.black.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Icon(
                      Icons.notifications,
                      color: Theme.of(context).brightness == Brightness.dark
                          ? Colors.white
                          : Colors.black,
                    ),
                  ),
                  title: const Text('Notifications'),
                  subtitle: const Text('Enable push notifications'),
                  value: _notificationsEnabled,
                  onChanged: _updateNotifications,
                  activeThumbColor: Colors.black,
                ),
                const Divider(height: 1),
                SwitchListTile(
                  secondary: Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: Theme.of(context).brightness == Brightness.dark
                          ? Colors.white.withOpacity(0.2)
                          : Colors.black.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Icon(
                      Icons.volume_up,
                      color: Theme.of(context).brightness == Brightness.dark
                          ? Colors.white
                          : Colors.black,
                    ),
                  ),
                  title: const Text('Sound'),
                  subtitle: const Text('Notification sounds'),
                  value: _soundEnabled,
                  onChanged: _updateSound,
                  activeThumbColor: Colors.black,
                ),
                const Divider(height: 1),
                SwitchListTile(
                  secondary: Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: Theme.of(context).brightness == Brightness.dark
                          ? Colors.white.withOpacity(0.2)
                          : Colors.black.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Icon(
                      Icons.vibration,
                      color: Theme.of(context).brightness == Brightness.dark
                          ? Colors.white
                          : Colors.black,
                    ),
                  ),
                  title: const Text('Vibration'),
                  subtitle: const Text('Haptic feedback'),
                  value: _vibrationEnabled,
                  onChanged: _updateVibration,
                  activeThumbColor: Colors.black,
                ),
              ],
            ),
          ),

          // Data & Privacy Section
          _buildSectionHeader('Data & Privacy'),
          _buildSettingsCard(
            child: Column(
              children: [
                SwitchListTile(
                  secondary: Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: Theme.of(context).brightness == Brightness.dark
                          ? Colors.white.withOpacity(0.2)
                          : Colors.black.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Icon(
                      Icons.analytics,
                      color: Theme.of(context).brightness == Brightness.dark
                          ? Colors.white
                          : Colors.black,
                    ),
                  ),
                  title: const Text('Analytics'),
                  subtitle: const Text('Share usage data to improve app'),
                  value: _analyticsEnabled,
                  onChanged: _updateAnalytics,
                  activeThumbColor: Colors.black,
                ),
              ],
            ),
          ),

          // About Application Section
          _buildSectionHeader('About Application'),
          _buildSettingsCard(
            child: Column(
              children: [
                ListTile(
                  leading: Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: Theme.of(context).brightness == Brightness.dark
                          ? Colors.white.withOpacity(0.2)
                          : Colors.black.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Icon(
                      Icons.apple,
                      color: Theme.of(context).brightness == Brightness.dark
                          ? Colors.white
                          : Colors.black,
                    ),
                  ),
                  title: const Text('App Name'),
                  subtitle: const Text('AppleMart'),
                ),
                const Divider(height: 1),
                ListTile(
                  leading: Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: Theme.of(context).brightness == Brightness.dark
                          ? Colors.white.withOpacity(0.2)
                          : Colors.black.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Icon(
                      Icons.numbers,
                      color: Theme.of(context).brightness == Brightness.dark
                          ? Colors.white
                          : Colors.black,
                    ),
                  ),
                  title: const Text('Version'),
                  subtitle: const Text('1.0.0'),
                ),
                const Divider(height: 1),
                ListTile(
                  leading: Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: Theme.of(context).brightness == Brightness.dark
                          ? Colors.white.withOpacity(0.2)
                          : Colors.black.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Icon(
                      Icons.code,
                      color: Theme.of(context).brightness == Brightness.dark
                          ? Colors.white
                          : Colors.black,
                    ),
                  ),
                  title: const Text('Build Number'),
                  subtitle: const Text('1'),
                ),
                const Divider(height: 1),
                ListTile(
                  leading: Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: Theme.of(context).brightness == Brightness.dark
                          ? Colors.white.withOpacity(0.2)
                          : Colors.black.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Icon(
                      Icons.group,
                      color: Theme.of(context).brightness == Brightness.dark
                          ? Colors.white
                          : Colors.black,
                    ),
                  ),
                  title: const Text('Developer Team'),
                  subtitle: const Text('Apple Mart Team'),
                ),
                const Divider(height: 1),
                ListTile(
                  leading: Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: Theme.of(context).brightness == Brightness.dark
                          ? Colors.white.withOpacity(0.2)
                          : Colors.black.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Icon(
                      Icons.description,
                      color: Theme.of(context).brightness == Brightness.dark
                          ? Colors.white
                          : Colors.black,
                    ),
                  ),
                  title: const Text('Description'),
                  subtitle: const Text('Premium Apple Products Marketplace'),
                ),
              ],
            ),
          ),

          // Legal Section
          _buildSectionHeader('Legal'),
          _buildSettingsCard(
            child: Column(
              children: [
                ListTile(
                  leading: Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: Theme.of(context).brightness == Brightness.dark
                          ? Colors.white.withOpacity(0.2)
                          : Colors.black.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Icon(
                      Icons.privacy_tip,
                      color: Theme.of(context).brightness == Brightness.dark
                          ? Colors.white
                          : Colors.black,
                    ),
                  ),
                  title: const Text('Privacy Policy'),
                  trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                  onTap: () {
                    _showPrivacyPolicy(context);
                  },
                ),
                const Divider(height: 1),
                ListTile(
                  leading: Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: Theme.of(context).brightness == Brightness.dark
                          ? Colors.white.withOpacity(0.2)
                          : Colors.black.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Icon(
                      Icons.assignment,
                      color: Theme.of(context).brightness == Brightness.dark
                          ? Colors.white
                          : Colors.black,
                    ),
                  ),
                  title: const Text('Terms & Conditions'),
                  trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                  onTap: () {
                    _showTermsAndConditions(context);
                  },
                ),
              ],
            ),
          ),

          // Settings Management Section
          _buildSectionHeader('Settings Management'),
          _buildSettingsCard(
            child: ListTile(
              leading: Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.red.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Icon(
                  Icons.refresh,
                  color: Colors.red,
                ),
              ),
              title: const Text(
                'Reset to Defaults',
                style: TextStyle(color: Colors.red),
              ),
              subtitle: const Text('Restore all settings to default values'),
              onTap: _showResetConfirmationDialog,
            ),
          ),

          const SizedBox(height: 30),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16.0, 20.0, 16.0, 12.0),
      child: Text(
        title,
        style: Theme.of(context).textTheme.headlineLarge,
      ),
    );
  }

  Widget _buildSettingsCard({required Widget child}) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: Card(
        elevation: 2,
        child: child,
      ),
    );
  }

  void _showPrivacyPolicy(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              color: Theme.of(context).scaffoldBackgroundColor,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Colors.black,
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(20),
                      topRight: Radius.circular(20),
                    ),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Privacy Policy',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      GestureDetector(
                        onTap: () => Navigator.pop(context),
                        child: Container(
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: Colors.white.withOpacity(0.2),
                          ),
                          padding: const EdgeInsets.all(4),
                          child: const Icon(
                            Icons.close,
                            color: Colors.white,
                            size: 20,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Flexible(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.all(20),
                    child: Text(
                      '''Privacy Policy for AppleMart

1. Data Collection
We collect personal information including name, email, phone number, and purchase history to provide better services and personalized recommendations.

2. Information Usage
Your information is used to:
• Process orders and payments
• Send order notifications
• Improve user experience
• Send promotional offers (with your consent)
• Prevent fraud and ensure security

3. Data Protection
We implement industry-standard security measures including encryption and secure servers to protect your personal data.

4. Third-Party Sharing
We do not share your personal information with third parties without your explicit consent, except when required by law.

5. Cookies
We use cookies to enhance your browsing experience and analyze site traffic.

6. User Rights
You have the right to:
• Access your personal data
• Request corrections
• Delete your account
• Opt-out of marketing communications

7. Policy Updates
We may update this policy periodically. Continued use of AppleMart constitutes acceptance of changes.

8. Contact Us
For privacy concerns, contact: privacy@applemart.com''',
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            height: 1.6,
                            letterSpacing: 0.3,
                          ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: SizedBox(
                    width: double.infinity,
                    height: 48,
                    child: Material(
                      elevation: 4,
                      shadowColor: Colors.black.withOpacity(0.3),
                      borderRadius: BorderRadius.circular(24),
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(24),
                          color: Colors.black,
                        ),
                        child: InkWell(
                          onTap: () => Navigator.pop(context),
                          borderRadius: BorderRadius.circular(24),
                          child: const Center(
                            child: Text(
                              'I Understand',
                              style: TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void _showTermsAndConditions(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              color: Theme.of(context).scaffoldBackgroundColor,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Colors.black,
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(20),
                      topRight: Radius.circular(20),
                    ),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Terms & Conditions',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      GestureDetector(
                        onTap: () => Navigator.pop(context),
                        child: Container(
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: Colors.white.withOpacity(0.2),
                          ),
                          padding: const EdgeInsets.all(4),
                          child: const Icon(
                            Icons.close,
                            color: Colors.white,
                            size: 20,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Flexible(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.all(20),
                    child: Text(
                      '''Terms & Conditions for AppleMart

1. Acceptance of Terms
By using AppleMart, you agree to these terms and conditions. If you do not agree, please do not use our service.

2. User Accounts
• You are responsible for maintaining account confidentiality
• You agree to provide accurate information
• You are liable for all activities under your account
• Account sharing is strictly prohibited

3. Product Information
• All product descriptions and prices are subject to change
• We reserve the right to limit quantities
• Product images are for reference purposes
• Actual products may vary slightly

4. Pricing and Payments
• Prices are in the specified currency
• We accept all major payment methods
• Payment must be completed before order processing
• Taxes and shipping fees are calculated at checkout

5. Order Processing
• Orders are subject to acceptance and verification
• We reserve the right to cancel orders for any reason
• Estimated delivery times are not guarantees
• Tracking information will be provided via email

6. Returns and Refunds
• Products must be returned within 30 days of purchase
• Items must be in original condition with packaging
• Refunds are processed within 7-10 business days
• Shipping costs are non-refundable

7. User Conduct
You agree not to:
• Use offensive, abusive, or defamatory language
• Attempt unauthorized access to accounts
• Post spam or malicious content
• Violate any laws or regulations

8. Intellectual Property
All content on AppleMart including logos, trademarks, and product information is protected by copyright laws.

9. Limitation of Liability
AppleMart is not liable for indirect, incidental, or consequential damages arising from product use.

10. Dispute Resolution
Disputes will be resolved through binding arbitration in accordance with applicable laws.

11. Termination
We reserve the right to terminate accounts that violate these terms.

12. Changes to Terms
We may update these terms periodically. Continued use constitutes acceptance.

13. Contact Information
For questions: support@applemart.com''',
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            height: 1.6,
                            letterSpacing: 0.3,
                          ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: SizedBox(
                    width: double.infinity,
                    height: 48,
                    child: Material(
                      elevation: 4,
                      shadowColor: Colors.black.withOpacity(0.3),
                      borderRadius: BorderRadius.circular(24),
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(24),
                          color: Colors.black,
                        ),
                        child: InkWell(
                          onTap: () => Navigator.pop(context),
                          borderRadius: BorderRadius.circular(24),
                          child: const Center(
                            child: Text(
                              'I Agree',
                              style: TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

extension StringExtension on String {
  String capitalize() {
    return "${this[0].toUpperCase()}${substring(1)}";
  }
}
