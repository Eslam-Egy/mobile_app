import 'package:material_ui/material_ui.dart';
import '../../../../core/theme/app_colors.dart';
import '../../domain/entities/field_test_entity.dart';
import '../manager/field_test_notifier.dart';
import '../widgets/rscp_trend_chart_widget.dart';
import '../widgets/field_test_history_widget.dart';

class FieldTestPage extends StatefulWidget {
  final FieldTestNotifier notifier;
  final String? initialImsi;
  final String? initialExtension;

  const FieldTestPage({
    super.key,
    required this.notifier,
    this.initialImsi,
    this.initialExtension,
  });

  @override
  State<FieldTestPage> createState() => _FieldTestPageState();
}

class _FieldTestPageState extends State<FieldTestPage> {
  final _formKey = GlobalKey<FormState>();

  late final TextEditingController _locationController;
  late final TextEditingController _imsiController;
  late final TextEditingController _extController;
  late final TextEditingController _notesController;

  bool _plmnDetected = true;
  String _attachStatus = 'Attached';
  double _rscpDbm = -75.0;

  double? _measuredLatencyMs;
  double? _measuredThroughputKbps;

  @override
  void initState() {
    super.initState();
    _locationController = TextEditingController(text: 'Lab Desk - 1.5m from Antenna');
    _imsiController = TextEditingController(text: widget.initialImsi ?? '001010000000001');
    _extController = TextEditingController(text: widget.initialExtension ?? '1001');
    _notesController = TextEditingController();
    widget.notifier.loadHistory();
  }

  @override
  void dispose() {
    _locationController.dispose();
    _imsiController.dispose();
    _extController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  Future<void> _runBenchmark() async {
    final benchmark = await widget.notifier.runBenchmark(sizeKb: 512);
    if (!mounted) return;

    if (benchmark != null) {
      setState(() {
        _measuredLatencyMs = benchmark.latencyMs;
        _measuredThroughputKbps = benchmark.throughputKbps;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Lab Plane benchmark: ${benchmark.latencyMs.toStringAsFixed(1)} ms RTT | ${(benchmark.throughputKbps / 1000.0).toStringAsFixed(2)} Mbps',
          ),
          backgroundColor: Colors.teal,
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Could not reach laptop. Ensure Wi-Fi connection and host settings.'),
          backgroundColor: Colors.redAccent,
        ),
      );
    }
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;

    final record = FieldTestEntity(
      timestamp: DateTime.now(),
      testLabel: _locationController.text.trim(),
      imsi: _imsiController.text.trim().isEmpty ? null : _imsiController.text.trim(),
      extension: _extController.text.trim().isEmpty ? null : _extController.text.trim(),
      plmnDetected: _plmnDetected,
      rscpDbm: _rscpDbm,
      attachStatus: _attachStatus,
      latencyMs: _measuredLatencyMs,
      throughputKbps: _measuredThroughputKbps,
      notes: _notesController.text.trim().isEmpty ? null : _notesController.text.trim(),
    );

    final id = await widget.notifier.submitFieldTest(record);
    if (!mounted) return;

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(id > 0
            ? 'Field test #$id synced to Ubuntu laptop backend!'
            : 'Field test saved locally (offline mode).'),
        backgroundColor: id > 0 ? Colors.green : Colors.orange,
      ),
    );

    _notesController.clear();
  }

  void _exportCsv() {
    final url = widget.notifier.getExportCsvUrl();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Download CSV report directly at:\n$url'),
        backgroundColor: Colors.blueGrey,
        duration: const Duration(seconds: 5),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return ListenableBuilder(
      listenable: widget.notifier,
      builder: (context, _) {
        final isSubmitting = widget.notifier.isSubmitting;
        final isBenchmarking = widget.notifier.isBenchmarking;
        final isLoadingHistory = widget.notifier.isLoadingHistory;
        final history = widget.notifier.history;

        return Scaffold(
          body: RefreshIndicator(
            onRefresh: () => widget.notifier.loadHistory(),
            child: ListView(
              padding: const EdgeInsets.all(16),
              children: [
                // Header Notice
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  decoration: BoxDecoration(
                    color: theme.colorScheme.primary.withValues(alpha: 0.08),
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: theme.colorScheme.primary.withValues(alpha: 0.2)),
                  ),
                  child: Row(
                    children: [
                      Icon(Icons.satellite_alt, color: theme.colorScheme.primary, size: 20),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Text(
                          '3G WCDMA Radio Observations + Wi-Fi Control Plane Telemetry',
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                            color: theme.colorScheme.primary,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),

                // Logging Form Card
                Card(
                  elevation: 1.5,
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Form(
                      key: _formKey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Log Field Test Observation',
                            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                          ),
                          const Divider(height: 24),

                          TextFormField(
                            controller: _locationController,
                            decoration: const InputDecoration(
                              labelText: 'Test Location / Distance from Antenna',
                              hintText: 'e.g. 1m Line-of-Sight, or Lab Entrance',
                              prefixIcon: Icon(Icons.pin_drop),
                              border: OutlineInputBorder(),
                            ),
                            validator: (val) => val == null || val.trim().isEmpty ? 'Please enter location' : null,
                          ),
                          const SizedBox(height: 14),

                          Row(
                            children: [
                              Expanded(
                                flex: 2,
                                child: TextFormField(
                                  controller: _imsiController,
                                  keyboardType: TextInputType.number,
                                  decoration: const InputDecoration(
                                    labelText: 'Test IMSI',
                                    hintText: '001010000000001',
                                    prefixIcon: Icon(Icons.sim_card),
                                    border: OutlineInputBorder(),
                                  ),
                                ),
                              ),
                              const SizedBox(width: 10),
                              Expanded(
                                flex: 1,
                                child: TextFormField(
                                  controller: _extController,
                                  keyboardType: TextInputType.number,
                                  decoration: const InputDecoration(
                                    labelText: 'Ext',
                                    hintText: '1001',
                                    border: OutlineInputBorder(),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 14),

                          SwitchListTile(
                            title: const Text('Network 001/01 Visible?'),
                            subtitle: const Text('Detected in Android Manual Network Search'),
                            value: _plmnDetected,
                            onChanged: (val) => setState(() => _plmnDetected = val),
                            contentPadding: EdgeInsets.zero,
                          ),
                          const SizedBox(height: 10),

                          const Text('Radio Attach Result:', style: TextStyle(fontWeight: FontWeight.w600, fontSize: 13)),
                          const SizedBox(height: 8),
                          SegmentedButton<String>(
                            segments: const [
                              ButtonSegment(
                                value: 'Attached',
                                label: Text('Attached'),
                                icon: Icon(Icons.check_circle, color: Colors.green),
                              ),
                              ButtonSegment(
                                value: 'Searching',
                                label: Text('Searching'),
                                icon: Icon(Icons.sync, color: Colors.amber),
                              ),
                              ButtonSegment(
                                value: 'Rejected',
                                label: Text('Rejected'),
                                icon: Icon(Icons.cancel, color: Colors.red),
                              ),
                            ],
                            selected: {_attachStatus},
                            onSelectionChanged: (val) => setState(() => _attachStatus = val.first),
                          ),
                          const SizedBox(height: 18),

                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text(
                                'Signal Strength (RSCP / RSSI):',
                                style: TextStyle(fontWeight: FontWeight.w600, fontSize: 13),
                              ),
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                                decoration: BoxDecoration(
                                  color: AppColors.getRscpColor(_rscpDbm).withValues(alpha: 0.15),
                                  borderRadius: BorderRadius.circular(6),
                                ),
                                child: Text(
                                  '${_rscpDbm.toStringAsFixed(1)} dBm',
                                  style: TextStyle(
                                    color: AppColors.getRscpColor(_rscpDbm),
                                    fontWeight: FontWeight.bold,
                                    fontSize: 13,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          Slider(
                            value: _rscpDbm,
                            min: -115.0,
                            max: -40.0,
                            divisions: 75,
                            label: '${_rscpDbm.toStringAsFixed(0)} dBm',
                            activeColor: AppColors.getRscpColor(_rscpDbm),
                            onChanged: (val) => setState(() => _rscpDbm = val),
                          ),
                          const SizedBox(height: 8),

                          Container(
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: theme.colorScheme.surfaceContainerHighest.withValues(alpha: 0.4),
                              borderRadius: BorderRadius.circular(10),
                              border: Border.all(color: theme.dividerColor),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    const Icon(Icons.speed, size: 18, color: Colors.teal),
                                    const SizedBox(width: 8),
                                    const Text(
                                      'Lab Control Plane Benchmark (Wi-Fi):',
                                      style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12),
                                    ),
                                    const Spacer(),
                                    OutlinedButton.icon(
                                      onPressed: isBenchmarking ? null : _runBenchmark,
                                      icon: isBenchmarking
                                          ? const SizedBox(
                                              width: 14,
                                              height: 14,
                                              child: CircularProgressIndicator(strokeWidth: 2),
                                            )
                                          : const Icon(Icons.play_arrow, size: 16),
                                      label: const Text('Run Test', style: TextStyle(fontSize: 12)),
                                      style: OutlinedButton.styleFrom(
                                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                                        visualDensity: VisualDensity.compact,
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 8),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                                  children: [
                                    Text(
                                      'RTT Latency: ${_measuredLatencyMs != null ? "${_measuredLatencyMs!.toStringAsFixed(1)} ms" : "Not Tested"}',
                                      style: const TextStyle(fontSize: 12, fontFamily: 'monospace'),
                                    ),
                                    Text(
                                      'Throughput: ${_measuredThroughputKbps != null ? "${_measuredThroughputKbps!.toStringAsFixed(0)} kbps" : "Not Tested"}',
                                      style: const TextStyle(fontSize: 12, fontFamily: 'monospace'),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 14),

                          TextFormField(
                            controller: _notesController,
                            maxLines: 2,
                            decoration: const InputDecoration(
                              labelText: 'Observations / Call & SMS Notes',
                              hintText: 'e.g. Call to extension 1002 connected, MOS ~4.0, zero packet drops',
                              border: OutlineInputBorder(),
                            ),
                          ),
                          const SizedBox(height: 18),

                          SizedBox(
                            width: double.infinity,
                            child: FilledButton.icon(
                              onPressed: isSubmitting ? null : _submit,
                              icon: isSubmitting
                                  ? const SizedBox(
                                      width: 16,
                                      height: 16,
                                      child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2),
                                    )
                                  : const Icon(Icons.cloud_upload),
                              label: const Text('Save & Sync to Laptop'),
                              style: FilledButton.styleFrom(padding: const EdgeInsets.symmetric(vertical: 14)),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 24),

                RscpTrendChartWidget(records: history),
                const SizedBox(height: 24),

                FieldTestHistoryWidget(
                  records: history,
                  isLoading: isLoadingHistory,
                  onExportCsv: _exportCsv,
                ),
                const SizedBox(height: 32),
              ],
            ),
          ),
        );
      },
    );
  }
}
