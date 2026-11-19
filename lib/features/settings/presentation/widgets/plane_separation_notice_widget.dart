import 'package:material_ui/material_ui.dart';

class PlaneSeparationNoticeWidget extends StatelessWidget {
  const PlaneSeparationNoticeWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Card(
      color: theme.colorScheme.primaryContainer.withValues(alpha: 0.4),
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(Icons.info_outline, color: theme.colorScheme.primary, size: 24),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Lab Control & Telemetry Plane Separation',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: theme.colorScheme.onPrimaryContainer,
                      fontSize: 14,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    'This mobile application talks to the Laptop backend strictly over the Local Lab Wi-Fi router (Control & Telemetry Plane). It does NOT route over the 3G UMTS Packet-Switched (PS) data plane. UMTS RF signals are strictly WCDMA Circuit-Switched (CS) voice and SMS routed to Asterisk PBX on the laptop.',
                    style: TextStyle(
                      fontSize: 12,
                      color: theme.colorScheme.onPrimaryContainer.withValues(alpha: 0.9),
                      height: 1.35,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
