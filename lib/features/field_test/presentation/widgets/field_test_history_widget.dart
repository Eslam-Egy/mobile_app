import 'package:material_ui/material_ui.dart';
import '../../../../core/utils/formatters.dart';
import '../../../../core/utils/rscp_evaluator.dart';
import '../../domain/entities/field_test_entity.dart';

class FieldTestHistoryWidget extends StatelessWidget {
  final List<FieldTestEntity> records;
  final bool isLoading;
  final VoidCallback onExportCsv;

  const FieldTestHistoryWidget({
    super.key,
    required this.records,
    required this.isLoading,
    required this.onExportCsv,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              'Recorded Lab Test Points',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
            TextButton.icon(
              onPressed: onExportCsv,
              icon: const Icon(Icons.file_download, size: 18),
              label: const Text('Export CSV Report'),
            ),
          ],
        ),
        const SizedBox(height: 8),

        if (isLoading)
          const Center(child: Padding(padding: EdgeInsets.all(16), child: CircularProgressIndicator()))
        else if (records.isEmpty)
          Card(
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Center(
                child: Text(
                  'No field tests recorded yet.\nRun test observations above to generate empirical data.',
                  textAlign: TextAlign.center,
                  style: TextStyle(color: theme.textTheme.bodySmall?.color),
                ),
              ),
            ),
          )
        else
          ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: records.length,
            separatorBuilder: (_, _) => const SizedBox(height: 8),
            itemBuilder: (context, index) {
              final r = records[index];
              final isAttached = r.attachStatus == 'Attached';
              final color = isAttached ? Colors.green : (r.attachStatus == 'Searching' ? Colors.amber : Colors.red);

              return Card(
                elevation: 1,
                child: ListTile(
                  leading: CircleAvatar(
                    backgroundColor: color.withValues(alpha: 0.15),
                    child: Icon(
                      isAttached ? Icons.check : (r.attachStatus == 'Searching' ? Icons.sync : Icons.close),
                      color: color,
                      size: 20,
                    ),
                  ),
                  title: Text(
                    r.testLabel,
                    style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                  ),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 2),
                      Text(
                        'RSCP: ${r.rscpDbm.toStringAsFixed(1)} dBm (${RscpEvaluator.getQualityLabel(r.rscpDbm)}) • Status: ${r.attachStatus}',
                        style: TextStyle(color: theme.textTheme.bodySmall?.color, fontSize: 12),
                      ),
                      if (r.imsi != null || r.extension != null)
                        Text(
                          'IMSI: ${r.imsi ?? "N/A"} • Ext: ${r.extension ?? "N/A"}',
                          style: TextStyle(color: theme.colorScheme.primary, fontSize: 11),
                        ),
                      if (r.notes != null && r.notes!.isNotEmpty)
                        Text(
                          'Notes: ${r.notes}',
                          style: const TextStyle(fontSize: 11, fontStyle: FontStyle.italic),
                        ),
                    ],
                  ),
                  trailing: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      if (r.latencyMs != null)
                        Text(
                          '${r.latencyMs!.toStringAsFixed(1)} ms',
                          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 11),
                        ),
                      Text(
                        Formatters.formatTime(r.timestamp),
                        style: const TextStyle(fontSize: 10, color: Colors.grey),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
      ],
    );
  }
}
