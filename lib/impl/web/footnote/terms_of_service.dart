import 'package:flutter/material.dart';

class TermsOfService extends StatelessWidget {
  const TermsOfService({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Terms of Service')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: const [
          Text(
            'Walley Terms',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.w700),
          ),
          SizedBox(height: 8),
          Text(
              'By using Walley, you agree to store your financial entries in your personal account. You are responsible for maintaining your account security.',),
          SizedBox(height: 16),
          Text('We may update these terms periodically.'),
        ],
      ),
    );
  }
}
