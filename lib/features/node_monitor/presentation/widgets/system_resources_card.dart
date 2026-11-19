import 'package:material_ui/material_ui.dart';
import '../../domain/entities/node_status_entity.dart';

class SystemResourcesCard extends StatelessWidget {
  final SystemTelemetryEntity? system;

  const SystemResourcesCard({super.key, this.system});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cpu = system?.cpuUsagePct ?? 0.0;
    final ram = system?.ramUsagePct ?? 0.0;
    final ramUsed = system?.ramUsedMb ?? 0.0;
    final ramTotal = system?.ramTotalMb ?? 0.0;

    return Card(
      elevation: 1,
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Icon(Icons.memory, size: 20),
                const SizedBox(width: 8),
                const Text(
                  'Host Laptop Telemetry (Ubuntu 24.04 x86_64)',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                ),
                const Spacer(),
                Text(
                  '${system?.cpuCount ?? 1} Cores',
                  style: TextStyle(fontSize: 11, color: theme.colorScheme.secondary),
                ),
              ],
            ),
            const SizedBox(height: 12),

            Row(
              children: [
                const SizedBox(
                  width: 70,
                  child: Text('CPU Load:', style: TextStyle(fontSize: 12)),
                ),
                Expanded(
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(4),
                    child: LinearProgressIndicator(
                      value: cpu / 100.0,
                      minHeight: 8,
                      backgroundColor: Colors.grey.withValues(alpha: 0.2),
                      valueColor: AlwaysStoppedAnimation<Color>(
                        cpu > 80 ? Colors.red : (cpu > 50 ? Colors.amber : Colors.blue),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                SizedBox(
                  width: 45,
                  child: Text(
                    '${cpu.toStringAsFixed(1)}%',
                    textAlign: TextAlign.end,
                    style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),

            Row(
              children: [
                const SizedBox(
                  width: 70,
                  child: Text('RAM Usage:', style: TextStyle(fontSize: 12)),
                ),
                Expanded(
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(4),
                    child: LinearProgressIndicator(
                      value: ram / 100.0,
                      minHeight: 8,
                      backgroundColor: Colors.grey.withValues(alpha: 0.2),
                      valueColor: AlwaysStoppedAnimation<Color>(
                        ram > 85 ? Colors.red : Colors.teal,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                SizedBox(
                  width: 45,
                  child: Text(
                    '${ram.toStringAsFixed(1)}%',
                    textAlign: TextAlign.end,
                    style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 4),
            Align(
              alignment: Alignment.centerRight,
              child: Text(
                'Memory: ${(ramUsed / 1024.0).toStringAsFixed(2)} GB / ${(ramTotal / 1024.0).toStringAsFixed(2)} GB',
                style: TextStyle(fontSize: 10, color: theme.textTheme.bodySmall?.color),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
