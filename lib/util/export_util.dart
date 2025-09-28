import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/services.dart';
import 'package:flutter/material.dart';
import 'package:walley/util/snack_util.dart';

class ExportUtil {
  static Future<void> exportCsv(BuildContext context) async {
    final userDocRef = FirebaseFirestore.instance
        .collection('users')
        .doc(FirebaseAuth.instance.currentUser!.email);
    final snap = await userDocRef.get();
    final data = snap.data() ?? {};
    final history = (data['spendingHistory'] as Map<String, dynamic>?) ?? {};
    final entries = history.entries.toList()..sort((a, b) => a.key.compareTo(b.key));
    final buf = StringBuffer();
    buf.writeln('timestamp,type,amount,category,notes');
    for (final e in entries) {
      final ts = e.key;
      final v = (e.value as Map<String, dynamic>);
      final type = v['type'] ?? '';
      final amount = v['amount'] ?? '';
      final category = _csvEscape(v['category']?.toString() ?? '');
      final notes = _csvEscape(v['notes']?.toString() ?? '');
      buf.writeln('$ts,$type,$amount,$category,$notes');
    }
    await Clipboard.setData(ClipboardData(text: buf.toString()));
    if (context.mounted) {
      SnackUtil.showSuccess(context, 'Exported ${entries.length} entries to clipboard as CSV');
    }
  }

  static String _csvEscape(String v) {
    if (v.contains(',') || v.contains('"') || v.contains('\n')) {
      return '"${v.replaceAll('"', '""')}"';
    }
    return v;
  }
}
