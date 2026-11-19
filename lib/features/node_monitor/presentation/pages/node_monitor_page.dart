import 'package:flutter/material.dart';
import '../../../../core/widgets/connection_banner_widget.dart';
import '../manager/node_monitor_notifier.dart';
import '../widgets/sdr_status_card.dart';
import '../widgets/openbts_status_card.dart';
import '../widgets/asterisk_status_card.dart';
import '../widgets/system_resources_card.dart';
import '../widgets/terminal_log_card.dart';

class NodeMonitorPage extends StatefulWidget {
  final NodeMonitorNotifier notifier;
  final String serverUrl;
  final VoidCallback onOpenSettings;

  const NodeMonitorPage({
    super.key,
    required this.notifier,
    required this.serverUrl,
    required this.onOpenSettings,
  });

  @override
  State<NodeMonitorPage> createState() => _NodeMonitorPageState();
}

class _NodeMonitorPageState extends State<NodeMonitorPage> {
  @override
  void initState() {
    super.initState();
    widget.notifier.fetchStatus();
    widget.notifier.startPolling();
  }

  @override
  void dispose() {
    widget.notifier.stopPolling();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return ListenableBuilder(
      listenable: widget.notifier,
      builder: (context, _) {
        final isConnected = widget.notifier.isConnected;
        final isLoading = widget.notifier.isLoading;
        final status = widget.notifier.status;
        final latencyMs = widget.notifier.latencyMs;
        final errorMessage = widget.notifier.errorMessage;

        return Scaffold(
          body: RefreshIndicator(
            onRefresh: () => widget.notifier.fetchStatus(),
            child: Column(
              children: [
                ConnectionBannerWidget(
                  isConnected: isConnected,
                  isLoading: isLoading,
                  serverUrl: widget.serverUrl,
                  latencyMs: latencyMs,
                  onRetry: () => widget.notifier.fetchStatus(),
                  onOpenSettings: widget.onOpenSettings,
                ),
                Expanded(
                  child: ListView(
                    padding: const EdgeInsets.all(16),
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                '3G / UMTS Node B Telemetry',
                                style: theme.textTheme.titleMedium?.copyWith(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Text(
                                'Band I (2100 MHz) • PLMN: 001/01',
                                style: theme.textTheme.bodySmall?.copyWith(
                                  color: theme.colorScheme.primary,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                          IconButton(
                            icon: const Icon(Icons.refresh),
                            tooltip: 'Refresh Status',
                            onPressed: () => widget.notifier.fetchStatus(),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),

                      if (!isConnected) ...[
                        Card(
                          color: Colors.amber.withValues(alpha: 0.12),
                          child: Padding(
                            padding: const EdgeInsets.all(14),
                            child: Row(
                              children: [
                                const Icon(Icons.cloud_off, color: Colors.amber, size: 30),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      const Text(
                                        'Waiting for Laptop Control Plane',
                                        style: TextStyle(fontWeight: FontWeight.bold),
                                      ),
                                      const SizedBox(height: 4),
                                      Text(
                                        errorMessage ?? 'Check that FastAPI server is running on Ubuntu laptop.',
                                        style: const TextStyle(fontSize: 12),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(height: 12),
                      ],

                      SdrStatusCard(sdr: status?.sdr),
                      const SizedBox(height: 12),

                      OpenBtsStatusCard(openbts: status?.openbts),
                      const SizedBox(height: 12),

                      AsteriskStatusCard(asterisk: status?.asterisk),
                      const SizedBox(height: 12),

                      SystemResourcesCard(system: status?.system),
                      const SizedBox(height: 16),

                      TerminalLogCard(
                        logs: status?.recentLogs ?? [
                          'Connecting to Ubuntu 24.04 laptop...',
                          if (errorMessage != null) 'Error: $errorMessage',
                        ],
                        onRefresh: () => widget.notifier.fetchStatus(),
                      ),
                      const SizedBox(height: 24),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
