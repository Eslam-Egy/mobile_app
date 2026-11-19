import 'package:material_ui/material_ui.dart';
import '../../domain/entities/test_sim_entity.dart';

class SimCardItemWidget extends StatelessWidget {
  final TestSimEntity sim;
  final VoidCallback onShowQr;
  final VoidCallback onDelete;
  final VoidCallback onStartFieldTest;

  const SimCardItemWidget({
    super.key,
    required this.sim,
    required this.onShowQr,
    required this.onDelete,
    required this.onStartFieldTest,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Card(
      elevation: 1.5,
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                CircleAvatar(
                  backgroundColor: Colors.teal.withValues(alpha: 0.15),
                  child: const Icon(Icons.sim_card, color: Colors.teal),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        sim.cardName,
                        style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                      ),
                      Text(
                        sim.cardType,
                        style: TextStyle(color: theme.textTheme.bodySmall?.color, fontSize: 12),
                      ),
                    ],
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.qr_code_2, size: 28, color: Colors.teal),
                  tooltip: 'Show QR Code',
                  onPressed: onShowQr,
                ),
                IconButton(
                  icon: const Icon(Icons.delete_outline, size: 20, color: Colors.grey),
                  tooltip: 'Delete SIM',
                  onPressed: onDelete,
                ),
              ],
            ),
            const Divider(height: 16),
            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('IMSI', style: TextStyle(fontSize: 10, color: Colors.grey)),
                      Text(
                        sim.imsi,
                        style: const TextStyle(
                          fontFamily: 'monospace',
                          fontWeight: FontWeight.bold,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('PBX Extension', style: TextStyle(fontSize: 10, color: Colors.grey)),
                      Text(
                        sim.extension,
                        style: const TextStyle(
                          fontFamily: 'monospace',
                          fontWeight: FontWeight.bold,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ),
                FilledButton.tonalIcon(
                  onPressed: onStartFieldTest,
                  icon: const Icon(Icons.play_arrow, size: 16),
                  label: const Text('Test', style: TextStyle(fontSize: 11)),
                  style: FilledButton.styleFrom(
                    visualDensity: VisualDensity.compact,
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                  ),
                ),
              ],
            ),
            if (sim.notes.isNotEmpty) ...[
              const SizedBox(height: 8),
              Text(
                sim.notes,
                style: const TextStyle(fontSize: 11, fontStyle: FontStyle.italic, color: Colors.grey),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
