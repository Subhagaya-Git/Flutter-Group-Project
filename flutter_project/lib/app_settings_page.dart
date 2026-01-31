import 'package:flutter/material.dart';

class AppSettingsPage extends StatefulWidget {
  const AppSettingsPage({super.key});

  @override
  State<AppSettingsPage> createState() => _AppSettingsPageState();
}

class _AppSettingsPageState extends State<AppSettingsPage> {
  bool _notificationsEnabled = true;
  bool _darkModeEnabled = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Settings',
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
            fontSize: 22,
          ),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.black),
        centerTitle: true,
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.grey.shade100, Colors.grey.shade200],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: ListView(
          children: [
            // App Settings Section
            Padding(
              padding: const EdgeInsets.fromLTRB(16.0, 20.0, 16.0, 12.0),
              child: Text(
                'App Settings',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                  letterSpacing: 0.5,
                ),
              ),
            ),
            _buildSettingsCard(
              child: SwitchListTile(
                title: const Text(
                  'Notifications',
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    color: Colors.black,
                  ),
                ),
                subtitle: const Text(
                  'Enable push notifications',
                  style: TextStyle(color: Colors.black54),
                ),
                value: _notificationsEnabled,
                onChanged: (bool value) {
                  setState(() {
                    _notificationsEnabled = value;
                  });
                },
                activeColor: Colors.black,
              ),
            ),
            _buildSettingsCard(
              child: SwitchListTile(
                title: const Text(
                  'Dark Mode',
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    color: Colors.black,
                  ),
                ),
                subtitle: const Text(
                  'Enable dark theme',
                  style: TextStyle(color: Colors.black54),
                ),
                value: _darkModeEnabled,
                onChanged: (bool value) {
                  setState(() {
                    _darkModeEnabled = value;
                  });
                },
                activeColor: Colors.black,
              ),
            ),
            const SizedBox(height: 16),

            // About Application Section
            Padding(
              padding: const EdgeInsets.fromLTRB(16.0, 20.0, 16.0, 12.0),
              child: Text(
                'About Application',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                  letterSpacing: 0.5,
                ),
              ),
            ),
            _buildSettingsCard(
              child: ListTile(
                leading: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.black.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Icon(
                    Icons.apple,
                    color: Colors.black,
                    size: 24,
                  ),
                ),
                title: const Text(
                  'App Name',
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    color: Colors.black,
                  ),
                ),
                subtitle: const Text(
                  'AppleMart',
                  style: TextStyle(color: Colors.black54),
                ),
              ),
            ),
            _buildSettingsCard(
              child: ListTile(
                leading: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.black.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Icon(
                    Icons.numbers,
                    color: Colors.black,
                    size: 24,
                  ),
                ),
                title: const Text(
                  'Version',
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    color: Colors.black,
                  ),
                ),
                subtitle: const Text(
                  '1.0.0',
                  style: TextStyle(color: Colors.black54),
                ),
              ),
            ),
            _buildSettingsCard(
              child: ListTile(
                leading: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.black.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Icon(
                    Icons.code,
                    color: Colors.black,
                    size: 24,
                  ),
                ),
                title: const Text(
                  'Build Number',
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    color: Colors.black,
                  ),
                ),
                subtitle: const Text(
                  '1',
                  style: TextStyle(color: Colors.black54),
                ),
              ),
            ),
            _buildSettingsCard(
              child: ListTile(
                leading: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.black.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Icon(
                    Icons.group,
                    color: Colors.black,
                    size: 24,
                  ),
                ),
                title: const Text(
                  'Developer Team',
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    color: Colors.black,
                  ),
                ),
                subtitle: const Text(
                  'Apple Mart Team',
                  style: TextStyle(color: Colors.black54),
                ),
              ),
            ),
            _buildSettingsCard(
              child: ListTile(
                leading: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.black.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Icon(
                    Icons.description,
                    color: Colors.black,
                    size: 24,
                  ),
                ),
                title: const Text(
                  'Description',
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    color: Colors.black,
                  ),
                ),
                subtitle: const Text(
                  'Premium Apple Products Marketplace',
                  style: TextStyle(color: Colors.black54),
                ),
              ),
            ),
            const SizedBox(height: 16),

            // Legal Section
            Padding(
              padding: const EdgeInsets.fromLTRB(16.0, 20.0, 16.0, 12.0),
              child: Text(
                'Legal',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                  letterSpacing: 0.5,
                ),
              ),
            ),
            _buildSettingsCard(
              child: ListTile(
                leading: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.black.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Icon(
                    Icons.privacy_tip,
                    color: Colors.black,
                    size: 24,
                  ),
                ),
                title: const Text(
                  'Privacy Policy',
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    color: Colors.black,
                  ),
                ),
                trailing: const Icon(
                  Icons.arrow_forward_ios,
                  size: 16,
                  color: Colors.black54,
                ),
                onTap: () {
                  _showPrivacyPolicy(context);
                },
              ),
            ),
            _buildSettingsCard(
              child: ListTile(
                leading: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.black.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Icon(
                    Icons.assignment,
                    color: Colors.black,
                    size: 24,
                  ),
                ),
                title: const Text(
                  'Terms & Conditions',
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    color: Colors.black,
                  ),
                ),
                trailing: const Icon(
                  Icons.arrow_forward_ios,
                  size: 16,
                  color: Colors.black54,
                ),
                onTap: () {
                  _showTermsAndConditions(context);
                },
              ),
            ),
            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }

  Widget _buildSettingsCard({required Widget child}) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: Card(
        elevation: 2,
        shadowColor: Colors.black.withOpacity(0.1),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
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
              gradient: LinearGradient(
                colors: [Colors.grey.shade100, Colors.grey.shade200],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Header
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: const BoxDecoration(
                    color: Colors.black,
                    borderRadius: BorderRadius.only(
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
                          letterSpacing: 0.5,
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
                // Content
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
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.black87,
                        height: 1.6,
                        letterSpacing: 0.3,
                      ),
                    ),
                  ),
                ),
                // Footer Button
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
                                letterSpacing: 0.5,
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
              gradient: LinearGradient(
                colors: [Colors.grey.shade100, Colors.grey.shade200],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Header
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: const BoxDecoration(
                    color: Colors.black,
                    borderRadius: BorderRadius.only(
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
                          letterSpacing: 0.5,
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
                // Content
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
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.black87,
                        height: 1.6,
                        letterSpacing: 0.3,
                      ),
                    ),
                  ),
                ),
                // Footer Button
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
                                letterSpacing: 0.5,
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
