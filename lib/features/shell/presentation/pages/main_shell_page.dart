import 'package:material_ui/material_ui.dart';
import '../../../../core/di/injection_container.dart';
import '../../../node_monitor/presentation/manager/node_monitor_notifier.dart';
import '../../../node_monitor/presentation/pages/node_monitor_page.dart';
import '../../../field_test/presentation/manager/field_test_notifier.dart';
import '../../../field_test/presentation/pages/field_test_page.dart';
import '../../../sim_manager/presentation/manager/sim_manager_notifier.dart';
import '../../../sim_manager/presentation/pages/sim_manager_page.dart';
import '../../../settings/presentation/manager/settings_notifier.dart';
import '../../../settings/presentation/pages/settings_page.dart';

class MainShellPage extends StatefulWidget {
  const MainShellPage({super.key});

  @override
  State<MainShellPage> createState() => _MainShellPageState();
}

class _MainShellPageState extends State<MainShellPage> {
  int _currentIndex = 0;
  String? _selectedImsi;
  String? _selectedExtension;

  late final NodeMonitorNotifier _nodeMonitorNotifier;
  late final FieldTestNotifier _fieldTestNotifier;
  late final SimManagerNotifier _simManagerNotifier;
  late final SettingsNotifier _settingsNotifier;

  @override
  void initState() {
    super.initState();
    _nodeMonitorNotifier = sl<NodeMonitorNotifier>();
    _fieldTestNotifier = sl<FieldTestNotifier>();
    _simManagerNotifier = sl<SimManagerNotifier>();
    _settingsNotifier = sl<SettingsNotifier>();
  }

  void _onStartFieldTestFromSim(String imsi, String extension) {
    setState(() {
      _selectedImsi = imsi;
      _selectedExtension = extension;
      _currentIndex = 1;
    });
  }

  void _openSettings() {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => SettingsPage(notifier: _settingsNotifier),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    final tabs = [
      NodeMonitorPage(
        notifier: _nodeMonitorNotifier,
        serverUrl: _settingsNotifier.config.baseUrl,
        onOpenSettings: _openSettings,
      ),
      FieldTestPage(
        key: ValueKey('${_selectedImsi}_$_selectedExtension'),
        notifier: _fieldTestNotifier,
        initialImsi: _selectedImsi,
        initialExtension: _selectedExtension,
      ),
      SimManagerPage(
        notifier: _simManagerNotifier,
        onStartFieldTest: _onStartFieldTestFromSim,
      ),
    ];

    return Scaffold(
      appBar: AppBar(
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              '3G / UMTS Lab Companion',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 17),
            ),
            Text(
              'Private Node B (NI USRP-2901 + OpenBTS-UMTS)',
              style: TextStyle(
                fontSize: 11,
                color: theme.colorScheme.onSurface.withValues(alpha: 0.7),
                fontWeight: FontWeight.w400,
              ),
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.settings_outlined),
            tooltip: 'Lab Plane Settings',
            onPressed: _openSettings,
          ),
        ],
      ),
      body: IndexedStack(
        index: _currentIndex,
        children: tabs,
      ),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _currentIndex,
        onDestinationSelected: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.cell_tower_outlined),
            selectedIcon: Icon(Icons.cell_tower),
            label: 'Tower Monitor',
          ),
          NavigationDestination(
            icon: Icon(Icons.network_check_outlined),
            selectedIcon: Icon(Icons.network_check),
            label: 'Field Test',
          ),
          NavigationDestination(
            icon: Icon(Icons.sim_card_outlined),
            selectedIcon: Icon(Icons.sim_card),
            label: 'SIM Manager',
          ),
        ],
      ),
    );
  }
}
