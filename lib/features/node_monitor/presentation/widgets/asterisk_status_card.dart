import 'package:material_ui/material_ui.dart';
import '../../domain/entities/node_status_entity.dart';

class AsteriskStatusCard extends StatelessWidget {
  final ServiceStatusEntity? asterisk;

  const AsteriskStatusCard({super.key, this.asterisk});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isRunning = asterisk?.running ?? false;
    final color = isRunning ? Colors.green : Colors.redAccent;

    return Card(
      elevation: 1,
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Row(
          children: [
            CircleAvatar(
              backgroundColor: color.withValues(alpha: 0.15),
              child: Icon(Icons.phone_in_talk, color: color, size: 22),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Asterisk 20.6.0 PBX',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    isRunning
                        ? 'Process PID: ${asterisk?.pid ?? 'Active'} • SIP / CS Core'
                        : 'Asterisk PBX not running on host',
                    style: TextStyle(color: theme.textTheme.bodySmall?.color, fontSize: 12),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Role: Circuit-Switched Voice & SMS Routing for 3G UEs',
                    style: TextStyle(color: theme.colorScheme.primary, fontSize: 11),
                  ),
                ],
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
              decoration: BoxDecoration(
                color: color.withValues(alpha: 0.12),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: color.withValues(alpha: 0.5)),
              ),
              child: Text(
                isRunning ? 'RUNNING' : 'STOPPED',
                style: TextStyle(color: color, fontSize: 11, fontWeight: FontWeight.bold),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
