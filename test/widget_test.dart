import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:dio/dio.dart';
import 'package:mobile_app/core/di/injection_container.dart' as di;
import 'package:mobile_app/core/network/dio_client.dart';
import 'package:mobile_app/features/node_monitor/presentation/manager/node_monitor_notifier.dart';
import 'package:mobile_app/main.dart';

void main() {
  testWidgets('Clean Architecture App smoke test loads MainShellPage', (WidgetTester tester) async {
    SharedPreferences.setMockInitialValues({});
    await di.initDependencies();

    // Stub Dio adapter for test environment so no live HTTP timers linger
    di.sl<DioClient>().dio.httpClientAdapter = _MockHttpClientAdapter();

    await tester.pumpWidget(const UmtsLabApp());
    await tester.pumpAndSettle();

    expect(find.text('3G / UMTS Lab Companion'), findsOneWidget);
    expect(find.text('Tower Monitor'), findsOneWidget);
    expect(find.text('Field Test'), findsOneWidget);
    expect(find.text('SIM Manager'), findsOneWidget);

    di.sl<NodeMonitorNotifier>().stopPolling();
    await tester.pumpAndSettle();
  });
}

class _MockHttpClientAdapter implements HttpClientAdapter {
  @override
  Future<ResponseBody> fetch(
    RequestOptions options,
    Stream<List<int>>? requestStream,
    Future<void>? cancelFuture,
  ) async {
    return ResponseBody.fromString(
      '{"status": "mock"}',
      200,
      headers: {
        Headers.contentTypeHeader: [Headers.jsonContentType],
      },
    );
  }

  @override
  void close({bool force = false}) {}
}
