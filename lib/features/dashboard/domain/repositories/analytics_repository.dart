abstract class AnalyticsRepository {
  /// Connects to the real-time analytics stream.
  void connect();

  /// Disconnects from the real-time analytics stream.
  void disconnect();

  /// A stream of live analytics metrics.
  Stream<Map<String, dynamic>> get liveMetrics;
}
