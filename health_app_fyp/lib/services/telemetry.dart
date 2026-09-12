import 'package:datadog_flutter_plugin/datadog_flutter_plugin.dart';

const bool telemetryEnabled = bool.fromEnvironment(
  'ENABLE_TELEMETRY',
  defaultValue: false,
);

enum TelemetryEvent {
  authLoginSucceeded('auth.login_succeeded'),
  authLoginFailed('auth.login_failed'),
  bodyMetricsSaved('body.metrics_saved'),
  calorieTargetExceeded('calories.target_exceeded'),
  foodEntrySaved('food.entry_saved'),
  foodLookupNotFound('food.lookup_not_found'),
  moodEntrySaved('mood.entry_saved');

  const TelemetryEvent(this.eventName);

  final String eventName;
}

class AppTelemetry {
  const AppTelemetry._();

  static void info(TelemetryEvent event) => _log(event, isError: false);

  static void error(TelemetryEvent event) => _log(event, isError: true);

  static void _log(TelemetryEvent event, {required bool isError}) {
    if (!telemetryEnabled) return;

    try {
      final logger = DatadogSdk.instance.createLogger(
        LoggingConfiguration(loggerName: 'qualife'),
      );
      if (isError) {
        logger.error(event.eventName);
      } else {
        logger.info(event.eventName);
      }
    } catch (_) {
      // Telemetry must never affect the app's primary behavior.
    }
  }
}
