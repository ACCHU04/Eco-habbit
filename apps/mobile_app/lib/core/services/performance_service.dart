import 'package:firebase_performance/firebase_performance.dart';
import 'package:mobile_app/core/config/app_config.dart';

class PerformanceService {
  final FirebasePerformance _performance;

  PerformanceService({FirebasePerformance? performance})
      : _performance = performance ?? FirebasePerformance.instance;

  Future<Trace> startTrace(String name) async {
    final trace = _performance.newTrace(name);
    await trace.start();
    trace.putAttribute('app_version', AppConfig.appVersion);
    return trace;
  }

  Future<void> stopTrace(Trace trace) async {
    await trace.stop();
  }

  HttpMetric newHttpMetric(String url, HttpMethod method) {
    return _performance.newHttpMetric(url, method);
  }
}
