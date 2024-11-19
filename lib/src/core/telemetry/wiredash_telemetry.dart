import 'package:clock/clock.dart';
import 'package:wiredash/src/core/services/local_storage.dart';

abstract class WiredashTelemetry {
  /// Event when promoter score survey was shown to the user
  Future<void> onOpenedPromoterScoreSurvey();

  /// The last time the user has been surveyed with an promoter score survey
  Future<DateTime?> lastPromoterScoreSurvey();
}

/// A persistent storage for the telemetry data from Wiredash
class PersistentWiredashTelemetry extends WiredashTelemetry {
  PersistentWiredashTelemetry(this.localStorageProvider);

  static const _lastPromoterScoreSurveyKey = 'io.wiredash.last_ps_survey';

  final Future<LocalStorage> Function() localStorageProvider;

  @override
  Future<void> onOpenedPromoterScoreSurvey() async {
    final localStorage = await localStorageProvider();
    final now = clock.now().toUtc();
    await localStorage.setString(_lastPromoterScoreSurveyKey, now.toIso8601String());
  }

  @override
  Future<DateTime?> lastPromoterScoreSurvey() async {
    final localStorage = await localStorageProvider();
    if (localStorage.containsKey(_lastPromoterScoreSurveyKey)) {
      final recovered = localStorage.getString(_lastPromoterScoreSurveyKey);
      if (recovered != null) {
        return DateTime.parse(recovered);
      }
    }
    return null;
  }
}
