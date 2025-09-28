import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

/// A utility class for retrieving user documents from Firestore.
class UserUtil {
  static Stream<DocumentSnapshot<Map<String, dynamic>>> usersStream() =>
      FirebaseFirestore.instance
          .collection("users")
          .doc(FirebaseAuth.instance.currentUser!.email)
          .snapshots();

  static Future<Map<String, dynamic>> getUserDocuments() async {
    return await FirebaseFirestore.instance
        .collection('users')
        .doc(FirebaseAuth.instance.currentUser!.email)
        .get()
        .then((DocumentSnapshot snapshot) {
      return snapshot.data() as Map<String, dynamic>;
    });
  }

  static Future<Map<String, dynamic>> getUserDocumentsFromCache() async {
    return await FirebaseFirestore.instance
        .collection('users')
        .doc(FirebaseAuth.instance.currentUser!.email)
        .get(const GetOptions(source: Source.cache))
        .then((DocumentSnapshot snapshot) {
      return snapshot.data() as Map<String, dynamic>;
    });
  }

  static Future<dynamic> getFieldFromCache(String fieldName) async {
    return await getUserDocumentsFromCache()
        .then((Map<String, dynamic> data) => data['name']);
  }

  /// Reads a field in the user documents from Firestore and creates the field if it doesn't exist.
  ///
  /// [field] is the name of the field to read/create.
  ///
  /// Returns a [Future] that completes with the value of the field.
  static Future<dynamic> readOrCreateField(
    String field,
    dynamic defaultValue,
  ) async {
    final userDocRef = FirebaseFirestore.instance
        .collection('users')
        .doc(FirebaseAuth.instance.currentUser!.email);

    final userDocSnapshot = await userDocRef.get();
    final userData = userDocSnapshot.data();

    if (userData != null && userData.containsKey(field)) {
      return userData[field];
    } else {
      await userDocRef.set({field: defaultValue}, SetOptions(merge: true));
      return defaultValue;
    }
  }

  static Future<dynamic> readField(
    String field,
  ) async {
    final userDocRef = FirebaseFirestore.instance
        .collection('users')
        .doc(FirebaseAuth.instance.currentUser!.email);

    final userDocSnapshot = await userDocRef.get();
    final userData = userDocSnapshot.data();

    return userData == null ? null : userData[field];
  }

  static Future<dynamic> readOrCreateFieldFromStream(
    String field,
    dynamic defaultValue,
  ) async {
    final userDocRef = FirebaseFirestore.instance
        .collection('users')
        .doc(FirebaseAuth.instance.currentUser!.email);
    final latestData = await usersStream().first;
    if (latestData.data() != null && latestData.data()!.containsKey(field)) {
      return latestData[field];
    } else {
      userDocRef.set({field: defaultValue}, SetOptions(merge: true));
      return defaultValue;
    }
  }

  static Future<dynamic> readFromStream(
    String field,
  ) async {
    final latestData = await usersStream().first;

    return latestData[field];
  }

  static Future<Map<String, dynamic>> modifyJsonDocument(
    String jsonPath,
    Map<String, dynamic> Function(Map<String, dynamic> currentData) modifier,
  ) async {
    final userDocRef = FirebaseFirestore.instance
        .collection('users')
        .doc(FirebaseAuth.instance.currentUser!.email);

    final userDocSnapshot = await userDocRef.get();
    final userData = userDocSnapshot.data();

    if (userData != null && userData.containsKey(jsonPath)) {
      final currentData = userData[jsonPath] as Map<String, dynamic>;
      final modifiedData = modifier(currentData);
      await userDocRef.set({jsonPath: modifiedData}, SetOptions(merge: true));
      return modifiedData;
    } else {
      final emptyData = modifier({});
      await userDocRef.set({jsonPath: emptyData}, SetOptions(merge: true));
      return emptyData;
    }
  }

  static Future<void> modifyBalance(int amount) async {
    final userDocRef = FirebaseFirestore.instance
        .collection('users')
        .doc(FirebaseAuth.instance.currentUser!.email);

    final userDocSnapshot = await userDocRef.get();
    final userData = userDocSnapshot.data();

    if (userData != null && userData.containsKey('balance')) {
      final currentBalance = userData['balance'] as int;
      final modifiedBalance = currentBalance + amount;
      await userDocRef
          .set({'balance': modifiedBalance}, SetOptions(merge: true));
    } else {
      await userDocRef.set({'balance': amount}, SetOptions(merge: true));
    }
  }

  static Future<Map<String, dynamic>?> fetchLatestTransaction() async {
    final userDocRef = FirebaseFirestore.instance
        .collection('users')
        .doc(FirebaseAuth.instance.currentUser!.email);

    final userDocSnapshot = await userDocRef.get();
    final userData = userDocSnapshot.data();

    if (userData != null && userData.containsKey('spendingHistory')) {
      final transactions = userData['spendingHistory'] as Map<String, dynamic>;
      final sortedKeys = transactions.keys.toList()..sort();
      final latestKey = sortedKeys.isNotEmpty ? sortedKeys.last : null;
      return latestKey != null
          ? <String, dynamic>{
              "time": latestKey.toString(),
              "data": transactions[latestKey],
            }
          : null;
    } else {
      return null;
    }
  }

  static Future<int> fetchTotalSpent([DateTime? date]) async {
    final userDocRef = FirebaseFirestore.instance
        .collection('users')
        .doc(FirebaseAuth.instance.currentUser!.email);

    final userDocSnapshot = await userDocRef.get();
    final userData = userDocSnapshot.data();

    if (userData != null && userData.containsKey('spendingHistory')) {
      final transactions = userData['spendingHistory'] as Map<String, dynamic>;
      transactions.removeWhere(
        (key, value) {
          final transactionDate = DateTime.tryParse(key);
          if (transactionDate == null) {
            debugPrint("FormatException: Invalid date format!\nKey: $key");
            return true;
          }
          final comparingDate = date ?? DateTime.now();
          return transactionDate.day != comparingDate.day ||
              transactionDate.month != comparingDate.month ||
              transactionDate.year != comparingDate.year ||
              (int.tryParse(value['amount'].toString()) ?? 0) > 0;
        },
      ); // filter out transactions in other days
      if (transactions.isEmpty) {
        return 0;
      }

      int total = transactions.entries.fold(0,
          (int sum, MapEntry<String, dynamic> entry) {
        int balanceChange =
            (int.tryParse(entry.value['amount'].toString()) ?? 0);
        return sum + balanceChange.abs();
      });
      return total; // return the calculated total
    } else {
      return 0;
    }
  }

  static Future<double> calculateAverageMonthlySpending() async {
    final userDocRef = FirebaseFirestore.instance
        .collection('users')
        .doc(FirebaseAuth.instance.currentUser!.email);

    final userDocSnapshot = await userDocRef.get();
    final userData = userDocSnapshot.data();

    if (userData != null && userData.containsKey('spendingHistory')) {
      final transactions = userData['spendingHistory'] as Map<String, dynamic>;
      final currentDate = DateTime.now();
      final currentMonth = currentDate.month;
      final currentYear = currentDate.year;

      double totalSpending = 0;
      int transactionCount = 0;

      transactions.forEach((key, value) {
        final transactionDate = DateTime.tryParse(key);
        if (transactionDate != null &&
            transactionDate.month == currentMonth &&
            transactionDate.year == currentYear) {
          final amount = value['amount'] as int;
          totalSpending += amount.abs();
          transactionCount++;
        }
      });

      if (transactionCount > 0) {
        return totalSpending / transactionCount;
      } else {
        return 0;
      }
    } else {
      return 0;
    }
  }

  static Future<int> getLessonProgress() async {
    final value = await readOrCreateField('lessonProgress', 1);
    return (value is int) ? value : 1;
  }

  static Stream<int> lessonProgressStream() {
    return usersStream().map((doc) {
      final data = doc.data();
      if (data == null) return 1;
      final v = data['lessonProgress'];
      return (v is int && v > 0) ? v : 1;
    });
  }

  static Future<int> incrementLessonProgress() async {
    final userDocRef = FirebaseFirestore.instance
        .collection('users')
        .doc(FirebaseAuth.instance.currentUser!.email);
    return FirebaseFirestore.instance.runTransaction((txn) async {
      final snap = await txn.get(userDocRef);
      final current = (snap.data()?['lessonProgress'] ?? 1) as int;
      final next = current + 1;
      txn.set(userDocRef, {'lessonProgress': next}, SetOptions(merge: true));
      return next;
    });
  }

  static Future<int> updateLessonProgressIfCurrent(int lessonNumber) async {
    final userDocRef = FirebaseFirestore.instance
        .collection('users')
        .doc(FirebaseAuth.instance.currentUser!.email);
    return FirebaseFirestore.instance.runTransaction((txn) async {
      final snap = await txn.get(userDocRef);
      final current = (snap.data()?['lessonProgress'] ?? 1) as int;
      if (current == lessonNumber) {
        final next = current + 1;
        txn.set(userDocRef, {'lessonProgress': next}, SetOptions(merge: true));
        return next;
      }
      return current; // no change if user opened a different lesson
    });
  }

  static Future<Map<String, dynamic>> aggregateSpending() async {
    final userDocRef = FirebaseFirestore.instance
        .collection('users')
        .doc(FirebaseAuth.instance.currentUser!.email);
    final snap = await userDocRef.get();
    final data = snap.data();
    final history = (data == null || !data.containsKey('spendingHistory'))
        ? <String, dynamic>{}
        : (data['spendingHistory'] as Map<String, dynamic>);

    final now = DateTime.now();
    double absNeg(String? v) {
      if (v == null) return 0;
      final n = int.tryParse(v) ?? 0;
      return n < 0 ? -n.toDouble() : 0; // only negative (spending)
    }

    // Daily (last 7 days)
    final Map<DateTime, double> daily = {};
    for (int i = 0; i < 7; i++) {
      final day =
          DateTime(now.year, now.month, now.day).subtract(Duration(days: i));
      daily[day] = 0;
    }

    // Weekly (last 8 weeks) keyed by Monday start
    final Map<DateTime, double> weekly = {};
    for (int i = 0; i < 8; i++) {
      final weekStart = DateTime(now.year, now.month, now.day)
          .subtract(Duration(days: now.weekday - 1))
          .subtract(Duration(days: 7 * i));
      weekly[DateTime(weekStart.year, weekStart.month, weekStart.day)] = 0;
    }

    // Monthly (last 12 months)
    final Map<DateTime, double> monthly = {};
    for (int i = 0; i < 12; i++) {
      final m = DateTime(now.year, now.month - i, 1);
      monthly[DateTime(m.year, m.month)] = 0;
    }

    history.forEach((k, v) {
      final dt = DateTime.tryParse(k);
      if (dt == null) return;
      final amount = absNeg(v['amount']?.toString());
      if (amount <= 0) return;

      final dayKey = DateTime(dt.year, dt.month, dt.day);
      if (daily.containsKey(dayKey)) daily[dayKey] = daily[dayKey]! + amount;

      final weekStart = DateTime(dt.year, dt.month, dt.day)
          .subtract(Duration(days: dt.weekday - 1));
      final weekKey = DateTime(weekStart.year, weekStart.month, weekStart.day);
      if (weekly.containsKey(weekKey)) {
        weekly[weekKey] = weekly[weekKey]! + amount;
      }

      final monthKey = DateTime(dt.year, dt.month);
      if (monthly.containsKey(monthKey)) {
        monthly[monthKey] = monthly[monthKey]! + amount;
      }
    });

    int nonZero(Iterable<double> vals) => vals.where((e) => e > 0).length;
    String interval;
    List<Map<String, Object>> buckets;

    if (nonZero(daily.values) >= 3) {
      interval = 'daily';
      final sorted = daily.keys.toList()..sort();
      buckets = sorted
          .map((d) => {
                'label': '${d.month}/${d.day}',
                'value': daily[d]!,
              },)
          .toList();
    } else if (nonZero(weekly.values) >= 3) {
      interval = 'weekly';
      final sorted = weekly.keys.toList()..sort();
      buckets = sorted
          .map((d) => {
                'label': 'W${_weekNumber(d)}',
                'value': weekly[d]!,
              },)
          .toList();
    } else {
      interval = 'monthly';
      final sorted = monthly.keys.toList()..sort();
      buckets = sorted
          .map((d) => {
                'label': '${d.month}/${d.year % 100}',
                'value': monthly[d]!,
              },)
          .toList();
    }

    final maxVal = buckets.fold<double>(
        0, (p, e) => (e['value'] as double) > p ? (e['value'] as double) : p,);
    return {
      'interval': interval,
      'buckets': buckets,
      'max': maxVal <= 0 ? 1.0 : maxVal,
    };
  }

  static int _weekNumber(DateTime date) {
    final firstDayOfYear = DateTime(date.year, 1, 1);
    final diff = date.difference(firstDayOfYear);
    return (diff.inDays / 7).floor() + 1;
  }
}
