import 'package:clock/clock.dart';
import 'package:wiredash/src/core/services/local_storage.dart';

/// Telemetry data from the app that ships with Wiredash
abstract class AppTelemetry {
  /// Event from the [Wiredash] widget when it gets started for the first time in the current Zone
  Future<void> onAppStart();

  /// Returns the time the app was first started
  ///
  /// This should be close the the app install time or the
  /// first the app shipped with Wiredash
  ///
  /// Falls back to the current time if no first app start time is available
  Future<DateTime?> firstAppStart();

  /// Returns the number of app starts
  Future<int> appStartCount();
}

/// A persistent storage for the app telemetry data
class PersistentAppTelemetry extends AppTelemetry {
  PersistentAppTelemetry(this.localStorageProvider);

  static const _deviceRegistrationDateKey = 'io.wiredash.device_registered_date';
  static const _appStartsKey = 'io.wiredash.app_starts';

  final Future<LocalStorage> Function() localStorageProvider;

  @override
  Future<void> onAppStart() async {
    await _saveFirstAppStart();
    await _saveAppStartCount();
  }

  @override
  Future<DateTime?> firstAppStart() async {
    final localStorage = await localStorageProvider();
    if (localStorage.containsKey(_deviceRegistrationDateKey)) {
      final recovered = localStorage.getString(_deviceRegistrationDateKey);
      if (recovered != null) {
        return DateTime.parse(recovered);
      }
    }
    return null;
  }

  Future<void> _saveFirstAppStart() async {
    final localStorage = await localStorageProvider();
    if (localStorage.containsKey(_deviceRegistrationDateKey)) {
      return;
    }
    final now = clock.now().toUtc();
    await localStorage.setString(_deviceRegistrationDateKey, now.toIso8601String());
  }

  @override
  Future<int> appStartCount() async {
    final localStorage = await localStorageProvider();
    final appStarts = localStorage.getInt(_appStartsKey) ?? 0;
    return appStarts;
  }

  Future<void> _saveAppStartCount() async {
    final appStarts = await appStartCount();
    final localStorage = await localStorageProvider();
    await localStorage.setInt(_appStartsKey, appStarts + 1);
  }
}
