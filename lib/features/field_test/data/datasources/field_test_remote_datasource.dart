import 'package:dio/dio.dart';
import '../../../../core/constants/api_constants.dart';
import '../../../../core/errors/exceptions.dart';
import '../../../../core/network/dio_client.dart';
import '../../domain/entities/field_test_entity.dart';
import '../models/field_test_model.dart';

abstract class FieldTestRemoteDataSource {
  Future<int> postTelemetry(FieldTestModel test);
  Future<List<FieldTestModel>> fetchTelemetryHistory({int limit = 50});
  Future<BenchmarkResultEntity> runLabBenchmark({int sizeKb = 512});
  String getExportCsvUrl();
}

class FieldTestRemoteDataSourceImpl implements FieldTestRemoteDataSource {
  final DioClient dioClient;

  FieldTestRemoteDataSourceImpl({required this.dioClient});

  @override
  Future<int> postTelemetry(FieldTestModel test) async {
    final response = await dioClient.post(
      ApiConstants.telemetryEndpoint,
      data: test.toJson(),
    );

    if (response.statusCode == 200 && response.data != null) {
      final map = response.data as Map<String, dynamic>;
      return map['record_id'] as int? ?? 0;
    } else {
      throw ServerException(message: 'Failed to record field test', statusCode: response.statusCode);
    }
  }

  @override
  Future<List<FieldTestModel>> fetchTelemetryHistory({int limit = 50}) async {
    final response = await dioClient.get(
      ApiConstants.telemetryEndpoint,
      queryParameters: {'limit': limit},
    );

    if (response.statusCode == 200 && response.data != null) {
      final map = response.data as Map<String, dynamic>;
      final list = map['records'] as List<dynamic>? ?? [];
      return list.map((item) => FieldTestModel.fromJson(item as Map<String, dynamic>)).toList();
    } else {
      throw ServerException(message: 'Failed to fetch telemetry history', statusCode: response.statusCode);
    }
  }

  @override
  Future<BenchmarkResultEntity> runLabBenchmark({int sizeKb = 512}) async {
    // 1. Measure Latency (Ping)
    final pingStopwatch = Stopwatch()..start();
    final pingRes = await dioClient.get(ApiConstants.pingEndpoint);
    pingStopwatch.stop();

    if (pingRes.statusCode != 200) {
      throw ServerException(message: 'Ping benchmark failed', statusCode: pingRes.statusCode);
    }
    final double latencyMs = pingStopwatch.elapsedMicroseconds / 1000.0;

    // 2. Measure Throughput (Speedtest Stream)
    final speedStopwatch = Stopwatch()..start();
    final speedRes = await dioClient.get(
      ApiConstants.speedtestEndpoint,
      queryParameters: {'size_kb': sizeKb},
      options: Options(responseType: ResponseType.bytes),
    );
    speedStopwatch.stop();

    if (speedRes.statusCode != 200 || speedRes.data == null) {
      throw ServerException(message: 'Throughput benchmark failed', statusCode: speedRes.statusCode);
    }

    final bytesList = speedRes.data as List<int>;
    final double seconds = speedStopwatch.elapsedMicroseconds / 1000000.0;
    final double throughputKbps = seconds > 0 ? (bytesList.length * 8.0) / (seconds * 1000.0) : 0.0;

    return BenchmarkResultEntity(
      latencyMs: latencyMs,
      throughputKbps: throughputKbps,
    );
  }

  @override
  String getExportCsvUrl() => '${dioClient.baseUrl}${ApiConstants.telemetryExportEndpoint}';
}
