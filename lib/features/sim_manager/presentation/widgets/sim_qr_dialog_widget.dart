import 'package:material_ui/material_ui.dart';
import 'package:qr_flutter/qr_flutter.dart';
import '../../data/models/test_sim_model.dart';
import '../../domain/entities/test_sim_entity.dart';

class SimQrDialogWidget extends StatelessWidget {
  final TestSimEntity sim;
  final VoidCallback onStartFieldTest;

  const SimQrDialogWidget({
    super.key,
    required this.sim,
    required this.onStartFieldTest,
  });

  @override
  Widget build(BuildContext context) {
    final model = TestSimModel.fromEntity(sim);
    final qrData = model.toQrString();

    return AlertDialog(
      title: Text(sim.cardName, textAlign: TextAlign.center),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.08),
                  blurRadius: 10,
                ),
              ],
            ),
            child: QrImageView(
              data: qrData,
              version: QrVersions.auto,
              size: 220.0,
              backgroundColor: Colors.white,
            ),
          ),
          const SizedBox(height: 16),
          Text(
            'IMSI: ${sim.imsi}',
            style: const TextStyle(fontWeight: FontWeight.bold, fontFamily: 'monospace', fontSize: 13),
          ),
          Text(
            'Extension: ${sim.extension} • ${sim.cardType}',
            style: const TextStyle(fontSize: 12, color: Colors.grey),
          ),
          const SizedBox(height: 8),
          const Text(
            'Scan this QR code from any lab phone to sync SIM parameters.',
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 11, color: Colors.teal),
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Close'),
        ),
        FilledButton.icon(
          onPressed: () {
            Navigator.of(context).pop();
            onStartFieldTest();
          },
          icon: const Icon(Icons.play_arrow, size: 18),
          label: const Text('Quick Field Test'),
        ),
      ],
    );
  }
}
