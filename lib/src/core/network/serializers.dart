// ignore_for_file: no_leading_underscores_for_local_identifiers

import 'dart:collection';
import 'dart:convert';
import 'dart:ui';

import 'package:wiredash/src/_wiredash_internal.dart';

extension AllMetaDataRequestJson on AllMetaData {
  Map<String, Object?> toRequestJson() {
    final Map<String, Object> values = SplayTreeMap.from({});

    // Values are sorted alphabetically for easy comparison with the backend
    final _appBrightness = appBrightness;
    if (_appBrightness != null) {
      values.addAll({'appBrightness': _appBrightness.toRequestJsonValue()});
    }

    final _appLocale = appLocale;
    if (_appLocale != null) {
      values.addAll({'appLocale': _appLocale});
    }

    final _appName = appName;
    if (_appName != null) {
      values.addAll({'appName': _appName});
    }

    final _buildCommit = buildCommit;
    if (_buildCommit != null) {
      values.addAll({'buildCommit': _buildCommit});
    }

    final _buildNumber = buildNumber;
    if (_buildNumber != null) {
      values.addAll({'buildNumber': _buildNumber});
    }

    final _buildVersion = buildVersion;
    if (_buildVersion != null) {
      values.addAll({'buildVersion': _buildVersion});
    }

    final _bundleId = bundleId;
    if (_bundleId != null) {
      values.addAll({'bundleId': _bundleId});
    }

    values.addAll({
      'compilationMode': nonNull(compilationMode.toRequestJsonValue()),
    });

    final customMetaData = custom?.map((key, value) {
      if (value == null) {
        return MapEntry(key, null);
      }
      try {
        // try encoding. We don't care about the actual encoded content because
        // it will be later by the http library encoded
        jsonEncode(value);
        // encoding worked, it's valid data
        return MapEntry(key, value);
      } catch (e, stack) {
        reportWiredashError(
          e,
          stack,
          'Could not serialize customMetaData property '
          '$key=$value',
        );
        return MapEntry(key, null);
      }
    });
    if (customMetaData != null) {
      customMetaData.removeWhere((key, value) => value == null);
      if (customMetaData.isNotEmpty) {
        values.addAll({'custom': customMetaData});
      }
    }

    final _deviceModel = deviceModel;
    if (_deviceModel != null) {
      values.addAll({'deviceModel': _deviceModel});
    }

    final _environment = environment;
    if (_environment != null) {
      values.addAll({'environment': _environment});
    }

    assert(installId.length >= 16);
    // for backwards compatability we convert the old uuid to a nanoId
    final _installNanoId = uuidToNanoId(installId, maxLength: 32);
    values.addAll({'installId': nonNull(_installNanoId)});

    values.addAll({
      'platformBrightness': nonNull(platformBrightness).toRequestJsonValue(),
    });

    final _platformDartVersion = platformDartVersion;
    if (_platformDartVersion != null) {
      values.addAll({'platformDartVersion': _platformDartVersion});
    }

    values.addAll({
      'platformGestureInsets':
          nonNull(platformGestureInsets).toRequestJsonArray(),
    });

    values.addAll({'platformLocale': nonNull(platformLocale)});

    final _platformOS = platformOS;
    if (_platformOS != null) {
      values.addAll({'platformOS': _platformOS});
    }

    final _platformOSVersion = platformOSVersion;
    if (_platformOSVersion != null) {
      values.addAll({'platformOSVersion': _platformOSVersion});
    }

    values.addAll({
      'platformSupportedLocales': nonNull(platformSupportedLocales),
    });

    values.addAll({'sdkVersion': nonNull(sdkVersion)});

    final _userEmail = userEmail;
    if (_userEmail != null && _userEmail.isNotEmpty) {
      values.addAll({'userEmail': _userEmail});
    }

    final String? _userId = userId;
    if (_userId != null) {
      values.addAll({'userId': _userId});
    }

    values.addAll({
      'windowInsets': nonNull(windowInsets).toRequestJsonArray(),
    });

    values.addAll({
      'windowPadding': nonNull(windowPadding).toRequestJsonArray(),
    });

    values.addAll({
      'windowPixelRatio': nonNull(windowPixelRatio),
    });

    values.addAll({
      'windowSize': nonNull(windowSize).toRequestJsonArray(),
    });

    values.addAll({
      'windowTextScaleFactor': nonNull(windowTextScaleFactor),
    });

    return values.map((k, v) => MapEntry(k, v));
  }
}

// Remove when we drop support for Flutter v3.8.0-14.0.pre.
// ignore: deprecated_member_use
extension SerizalizeWindowPadding on WindowPadding {
  List<double> toRequestJsonArray() {
    return [left, top, right, bottom];
  }
}

extension SerializeSize on Size {
  List<double> toRequestJsonArray() {
    return [width, height];
  }
}

extension SerializeBrightness on Brightness {
  String toRequestJsonValue() {
    if (this == Brightness.dark) return 'dark';
    if (this == Brightness.light) return 'light';
    throw 'Unknown brightness value $this';
  }
}

extension SerializeCompilationMode on CompilationMode {
  String toRequestJsonValue() {
    switch (this) {
      case CompilationMode.release:
        return 'release';
      case CompilationMode.profile:
        return 'profile';
      case CompilationMode.debug:
        return 'debug';
    }
  }
}

/// Explicitly defines a values a non null, making it a compile time error
/// when [value] becomes nullable
///
/// This prevents accidental null values here that may happen due to refactoring
T nonNull<T extends Object>(T value) {
  return value;
}
