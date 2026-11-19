import 'package:material_ui/material_ui.dart';
import 'core/di/injection_container.dart' as di;
import 'core/routes/app_router.dart';
import 'core/theme/app_theme.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await di.initDependencies();

  runApp(const UmtsLabApp());
}

class UmtsLabApp extends StatelessWidget {
  const UmtsLabApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: '3G/UMTS Lab Companion',
      debugShowCheckedModeBanner: false,
      themeMode: ThemeMode.system,
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      routerConfig: AppRouter.router,
    );
  }
}
