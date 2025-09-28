import 'package:flutter/material.dart';

class LoginPopup {
	static Future<void> show(
		BuildContext context,
		String title,
		String subtitle,
		bool isLogin,
	) async {
		await showDialog(
			context: context,
			builder: (_) => AlertDialog(
				title: Text(title),
				content: Text(subtitle),
				actions: [
					TextButton(
						onPressed: () => Navigator.of(context).pop(),
						child: const Text('Close'),
					),
				],
			),
		);
	}
}
