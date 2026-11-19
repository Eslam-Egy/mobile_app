import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../constants/api_constants.dart';
import '../constants/storage_constants.dart';
import '../network/dio_client.dart';

// Node Monitor
import '../../features/node_monitor/data/datasources/node_monitor_remote_datasource.dart';
import '../../features/node_monitor/data/repositories/node_monitor_repository_impl.dart';
import '../../features/node_monitor/domain/repositories/node_monitor_repository.dart';
import '../../features/node_monitor/domain/usecases/get_node_status_usecase.dart';
import '../../features/node_monitor/presentation/manager/node_monitor_notifier.dart';

// Field Test
import '../../features/field_test/data/datasources/field_test_local_datasource.dart';
import '../../features/field_test/data/datasources/field_test_remote_datasource.dart';
import '../../features/field_test/data/repositories/field_test_repository_impl.dart';
import '../../features/field_test/domain/repositories/field_test_repository.dart';
import '../../features/field_test/domain/usecases/field_test_usecases.dart';
import '../../features/field_test/presentation/manager/field_test_notifier.dart';

// SIM Manager
import '../../features/sim_manager/data/datasources/sim_local_datasource.dart';
import '../../features/sim_manager/data/repositories/sim_manager_repository_impl.dart';
import '../../features/sim_manager/domain/repositories/sim_manager_repository.dart';
import '../../features/sim_manager/domain/usecases/sim_manager_usecases.dart';
import '../../features/sim_manager/presentation/manager/sim_manager_notifier.dart';

// Settings
import '../../features/settings/data/datasources/settings_local_datasource.dart';
import '../../features/settings/data/repositories/settings_repository_impl.dart';
import '../../features/settings/domain/repositories/settings_repository.dart';
import '../../features/settings/domain/usecases/settings_usecases.dart';
import '../../features/settings/presentation/manager/settings_notifier.dart';

final sl = GetIt.instance;

Future<void> initDependencies() async {
  // 1. External
  final sharedPreferences = await SharedPreferences.getInstance();
  sl.registerLazySingleton<SharedPreferences>(() => sharedPreferences);

  // Initial host config for DioClient
  final initialHost = sharedPreferences.getString(StorageConstants.keyServerHost) ?? ApiConstants.defaultHost;
  final initialPort = sharedPreferences.getInt(StorageConstants.keyServerPort) ?? ApiConstants.defaultPort;
  final initialBaseUrl = 'http://$initialHost:$initialPort';

  sl.registerLazySingleton<DioClient>(() => DioClient(baseUrl: initialBaseUrl));

  // 2. Settings Feature
  sl.registerLazySingleton<SettingsLocalDataSource>(
    () => SettingsLocalDataSourceImpl(sharedPreferences: sl()),
  );
  sl.registerLazySingleton<SettingsRepository>(
    () => SettingsRepositoryImpl(localDataSource: sl(), dioClient: sl()),
  );
  sl.registerLazySingleton(() => GetServerConfigUseCase(sl()));
  sl.registerLazySingleton(() => SaveServerConfigUseCase(sl()));
  sl.registerLazySingleton(() => PingServerUseCase(sl()));
  sl.registerLazySingleton(
    () => SettingsNotifier(
      getServerConfigUseCase: sl(),
      saveServerConfigUseCase: sl(),
      pingServerUseCase: sl(),
    ),
  );

  // 3. Node Monitor Feature
  sl.registerLazySingleton<NodeMonitorRemoteDataSource>(
    () => NodeMonitorRemoteDataSourceImpl(dioClient: sl()),
  );
  sl.registerLazySingleton<NodeMonitorRepository>(
    () => NodeMonitorRepositoryImpl(remoteDataSource: sl()),
  );
  sl.registerLazySingleton(() => GetNodeStatusUseCase(sl()));
  sl.registerFactory(
    () => NodeMonitorNotifier(getNodeStatusUseCase: sl()),
  );

  // 4. Field Test Feature
  sl.registerLazySingleton<FieldTestRemoteDataSource>(
    () => FieldTestRemoteDataSourceImpl(dioClient: sl()),
  );
  sl.registerLazySingleton<FieldTestLocalDataSource>(
    () => FieldTestLocalDataSourceImpl(sharedPreferences: sl()),
  );
  sl.registerLazySingleton<FieldTestRepository>(
    () => FieldTestRepositoryImpl(remoteDataSource: sl(), localDataSource: sl()),
  );
  sl.registerLazySingleton(() => SaveFieldTestUseCase(sl()));
  sl.registerLazySingleton(() => GetFieldTestHistoryUseCase(sl()));
  sl.registerLazySingleton(() => RunLabBenchmarkUseCase(sl()));
  sl.registerFactory(
    () => FieldTestNotifier(
      saveFieldTestUseCase: sl(),
      getFieldTestHistoryUseCase: sl(),
      runLabBenchmarkUseCase: sl(),
      repository: sl(),
    ),
  );

  // 5. SIM Manager Feature
  sl.registerLazySingleton<SimLocalDataSource>(
    () => SimLocalDataSourceImpl(sharedPreferences: sl()),
  );
  sl.registerLazySingleton<SimManagerRepository>(
    () => SimManagerRepositoryImpl(localDataSource: sl()),
  );
  sl.registerLazySingleton(() => GetSimCardsUseCase(sl()));
  sl.registerLazySingleton(() => AddSimCardUseCase(sl()));
  sl.registerLazySingleton(() => DeleteSimCardUseCase(sl()));
  sl.registerFactory(
    () => SimManagerNotifier(
      getSimCardsUseCase: sl(),
      addSimCardUseCase: sl(),
      deleteSimCardUseCase: sl(),
    ),
  );
}
