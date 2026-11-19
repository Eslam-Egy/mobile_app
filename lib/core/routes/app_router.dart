import 'package:go_router/go_router.dart';
import '../di/injection_container.dart';
import '../../features/shell/presentation/pages/main_shell_page.dart';
import '../../features/settings/presentation/manager/settings_notifier.dart';
import '../../features/settings/presentation/pages/settings_page.dart';

class AppRouter {
  static final GoRouter router = GoRouter(
    initialLocation: '/',
    routes: [
      GoRoute(
        path: '/',
        name: 'shell',
        builder: (context, state) => const MainShellPage(),
      ),
      GoRoute(
        path: '/settings',
        name: 'settings',
        builder: (context, state) => SettingsPage(notifier: sl<SettingsNotifier>()),
      ),
    ],
  );
}
