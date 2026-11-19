import 'package:material_ui/material_ui.dart';
import '../manager/settings_notifier.dart';
import '../widgets/plane_separation_notice_widget.dart';

class SettingsPage extends StatefulWidget {
  final SettingsNotifier notifier;

  const SettingsPage({super.key, required this.notifier});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  late final TextEditingController _hostController;
  late final TextEditingController _portController;
  late bool _autoPoll;

  @override
  void initState() {
    super.initState();
    final config = widget.notifier.config;
    _hostController = TextEditingController(text: config.host);
    _portController = TextEditingController(text: config.port.toString());
    _autoPoll = config.autoPoll;
  }

  @override
  void dispose() {
    _hostController.dispose();
    _portController.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    final host = _hostController.text.trim();
    final port = int.tryParse(_portController.text.trim()) ?? 8000;

    await widget.notifier.saveConfig(
      host: host,
      port: port,
      autoPoll: _autoPoll,
    );

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Lab Control Plane configuration saved!'),
          backgroundColor: Colors.teal,
        ),
      );
      Navigator.of(context).pop();
    }
  }

  void _test() {
    final host = _hostController.text.trim();
    final port = int.tryParse(_portController.text.trim()) ?? 8000;
    widget.notifier.testConnection(host, port);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return ListenableBuilder(
      listenable: widget.notifier,
      builder: (context, _) {
        final isTesting = widget.notifier.isTesting;
        final testMessage = widget.notifier.testMessage;
        final testSuccess = widget.notifier.testSuccess;

        return Scaffold(
          appBar: AppBar(
            title: const Text('Lab Plane Settings'),
          ),
          body: ListView(
            padding: const EdgeInsets.all(16),
            children: [
              const PlaneSeparationNoticeWidget(),
              const SizedBox(height: 20),

              Text(
                'Ubuntu Host Connection',
                style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 12),

              TextField(
                controller: _hostController,
                decoration: const InputDecoration(
                  labelText: 'Laptop Wi-Fi IP Address',
                  hintText: 'e.g. 192.168.1.10',
                  prefixIcon: Icon(Icons.laptop_chromebook),
                  border: OutlineInputBorder(),
                  helperText: 'Find on Ubuntu with: hostname -I',
                ),
              ),
              const SizedBox(height: 16),

              TextField(
                controller: _portController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  labelText: 'FastAPI Service Port',
                  hintText: '8000',
                  prefixIcon: Icon(Icons.numbers),
                  border: OutlineInputBorder(),
                  helperText: 'Default: 8000 (Allow via: sudo ufw allow 8000/tcp)',
                ),
              ),
              const SizedBox(height: 16),

              SwitchListTile(
                title: const Text('Auto-Poll Node Status'),
                subtitle: const Text('Refresh Node B / Asterisk / USRP status every 5 seconds'),
                value: _autoPoll,
                onChanged: (val) => setState(() => _autoPoll = val),
                contentPadding: EdgeInsets.zero,
              ),
              const SizedBox(height: 16),

              OutlinedButton.icon(
                onPressed: isTesting ? null : _test,
                icon: isTesting
                    ? const SizedBox(
                        width: 16,
                        height: 16,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                    : const Icon(Icons.network_check),
                label: const Text('Test Connection (Ping Host Laptop)'),
                style: OutlinedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 12),
                ),
              ),

              if (testMessage != null) ...[
                const SizedBox(height: 12),
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: testSuccess == true
                        ? Colors.green.withValues(alpha: 0.12)
                        : Colors.red.withValues(alpha: 0.12),
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(
                      color: testSuccess == true ? Colors.green : Colors.red,
                      width: 1,
                    ),
                  ),
                  child: Text(
                    testMessage,
                    style: TextStyle(
                      fontSize: 12,
                      fontFamily: 'monospace',
                      color: testSuccess == true ? Colors.green[800] : Colors.red[800],
                    ),
                  ),
                ),
              ],

              const SizedBox(height: 32),

              FilledButton.icon(
                onPressed: _save,
                icon: const Icon(Icons.save),
                label: const Text('Save & Apply Settings'),
                style: FilledButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 14),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
