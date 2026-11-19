import 'package:material_ui/material_ui.dart';
import '../../domain/entities/node_status_entity.dart';

class SdrStatusCard extends StatelessWidget {
  final SdrHardwareEntity? sdr;

  const SdrStatusCard({super.key, this.sdr});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isActive = sdr?.isActiveInUse ?? false;
    final isStandby = sdr?.isStandby ?? false;

    Color badgeColor = Colors.grey;
    String badgeText = 'Unknown / Probing';
    IconData icon = Icons.radio;

    if (sdr != null) {
      if (isActive) {
        badgeColor = Colors.green;
        badgeText = 'Active (In-Use by OpenBTS-UMTS)';
        icon = Icons.sensors;
      } else if (isStandby) {
        badgeColor = Colors.teal;
        badgeText = 'Detected (Standby / Idle)';
        icon = Icons.radio;
      } else {
        badgeColor = Colors.redAccent;
        badgeText = sdr!.status;
        icon = Icons.radio_button_off;
      }
    }

    return Card(
      elevation: 1,
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                CircleAvatar(
                  backgroundColor: badgeColor.withValues(alpha: 0.15),
                  child: Icon(icon, color: badgeColor, size: 22),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'NI USRP-2901 SDR Transceiver',
                        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                      ),
                      Text(
                        'Interface: High-Speed USB 3.0 Bus',
                        style: TextStyle(color: theme.textTheme.bodySmall?.color, fontSize: 12),
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: badgeColor.withValues(alpha: 0.12),
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: badgeColor.withValues(alpha: 0.4)),
                  ),
                  child: Text(
                    badgeText,
                    style: TextStyle(
                      color: badgeColor,
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: theme.colorScheme.surfaceContainerHighest.withValues(alpha: 0.5),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                sdr != null
                    ? '${sdr!.details}\n🛡️ Safe Probe: Bypassed during active RF to protect USB 3.0 handle'
                    : 'Awaiting hardware probe report from host laptop...',
                style: const TextStyle(fontSize: 11, fontFamily: 'monospace'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
