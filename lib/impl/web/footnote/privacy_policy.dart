import 'package:flutter/material.dart';

class PrivacyPolicy extends StatelessWidget {
  const PrivacyPolicy({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Privacy Policy')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: const [
          Text(
            'We respect your privacy',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.w700),
          ),
          SizedBox(height: 8),
          Text(
            'Walley stores your profile and finance data securely in Firebase. Your spending entries are only visible to you. We do not sell your data.',
          ),
          SizedBox(height: 16),
          Text(
            'Data we collect',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
          ),
          SizedBox(height: 6),
          Text('Account info (email, name), spending entries, preferences.'),
          SizedBox(height: 16),
          Text(
            'Contact',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
          ),
          SizedBox(height: 6),
          Text('support@walley.com'),
        ],
      ),
    );
  }
}
