import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UserDefaultsUtil {
  static SharedPreferencesWithCache? preferences;

  static Future<void> initialize() async {
    preferences = await SharedPreferencesWithCache.create(
      cacheOptions: const SharedPreferencesWithCacheOptions(),
    );
  }

  /// Builds a widget wrapped with two [FutureBuilder] widgets.
  ///
  /// The [buildWidgetWithPreference] function takes in a [preferenceName] of type [String],
  /// a [preferenceValue] of type [Future<dynamic>], and a [builder] function of type
  /// [Widget Function(BuildContext, AsyncSnapshot<dynamic>)]. It returns a [Widget].
  ///
  /// The [preferenceName] parameter represents the name of the preference to be set.
  /// The [preferenceValue] parameter represents the future that resolves to the preference value.
  /// The [builder] parameter represents the function that builds the widget based on the
  /// [BuildContext] and [AsyncSnapshot] of the preference value.
  ///
  /// Example usage:
  ///
  /// ```dart
  /// Widget myWidget = buildWidgetWithPreference(
  ///   "myPreference",
  ///   getPreferenceValue(),
  ///   (context, snapshot) {
  ///     if (snapshot.hasData) {
  ///       return Text(snapshot.data.toString());
  ///     } else if (snapshot.hasError) {
  ///       return Text("Error: ${snapshot.error}");
  ///     } else {
  ///       return CircularProgressIndicator();
  ///     }
  ///   },
  /// );
  /// ```
  ///
  /// The above example demonstrates how to use the [buildWidgetWithPreference] function
  /// to build a widget wrapped with two [FutureBuilder] widgets. The [preferenceName] is set
  /// to "myPreference", the [preferenceValue] is obtained from the [getPreferenceValue] function,
  /// and the [builder] function is used to build the widget based on the snapshot of the preference value.
  /// If the snapshot has data, a [Text] widget displaying the data is returned. If the snapshot has an error,
  /// a [Text] widget displaying the error is returned. Otherwise, a [CircularProgressIndicator] is displayed.
  ///
  /// Note: The actual implementation of the [getPreferenceValue] function is not shown in this example.
  /// It should be replaced with the appropriate code to obtain the preference value.
  /// ```
  static Widget buildWidgetWithPreference(
    String preferenceName,
    Future<dynamic> preferenceValue,
    Widget Function(BuildContext, AsyncSnapshot<dynamic>) builder,
  ) {
    return FutureBuilder(
      future: preferenceValue,
      builder: (_, data) {
        return FutureBuilder(
          future: UserDefaultsUtil.preferences!
              .setString(preferenceName, data.data.toString()),
          builder: (_, __) {
            return builder(_, data);
          },
        );
      },
    );
  }

  // Convenience getters/setters for simple feature toggles
  static Future<bool> getBool(String key, {bool defaultValue = true}) async {
    if (preferences == null) await initialize();
    return preferences!.getBool(key) ?? defaultValue;
  }

  static Future<void> setBool(String key, bool value) async {
    if (preferences == null) await initialize();
    await preferences!.setBool(key, value);
  }
}
