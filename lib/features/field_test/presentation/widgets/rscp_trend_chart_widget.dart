import 'package:material_ui/material_ui.dart';
import 'package:fl_chart/fl_chart.dart';
import '../../domain/entities/field_test_entity.dart';

class RscpTrendChartWidget extends StatelessWidget {
  final List<FieldTestEntity> records;

  const RscpTrendChartWidget({super.key, required this.records});

  @override
  Widget build(BuildContext context) {
    if (records.isEmpty) return const SizedBox.shrink();

    final theme = Theme.of(context);
    final chronological = records.reversed.toList();
    final List<FlSpot> rscpSpots = [];

    for (int i = 0; i < chronological.length; i++) {
      rscpSpots.add(FlSpot(i.toDouble(), chronological[i].rscpDbm));
    }

    return Card(
      elevation: 1.5,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Empirical RF Signal Trend (RSCP)',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                ),
                Text(
                  '${records.length} points',
                  style: TextStyle(fontSize: 12, color: theme.colorScheme.secondary),
                ),
              ],
            ),
            const SizedBox(height: 6),
            const Text(
              'RSCP (dBm) plotted across test points (lower is weaker)',
              style: TextStyle(fontSize: 11, color: Colors.grey),
            ),
            const SizedBox(height: 16),
            SizedBox(
              height: 180,
              child: LineChart(
                LineChartData(
                  minY: -120,
                  maxY: -30,
                  gridData: const FlGridData(show: true, drawVerticalLine: false),
                  titlesData: FlTitlesData(
                    rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                    topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                    bottomTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        interval: 1,
                        getTitlesWidget: (val, meta) => Text(
                          'P${val.toInt() + 1}',
                          style: const TextStyle(fontSize: 9),
                        ),
                      ),
                    ),
                    leftTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        interval: 20,
                        reservedSize: 36,
                        getTitlesWidget: (val, meta) => Text(
                          '${val.toInt()}',
                          style: const TextStyle(fontSize: 9),
                        ),
                      ),
                    ),
                  ),
                  borderData: FlBorderData(
                    show: true,
                    border: Border.all(color: Colors.grey.withValues(alpha: 0.2)),
                  ),
                  lineBarsData: [
                    LineChartBarData(
                      spots: rscpSpots,
                      isCurved: true,
                      color: Colors.teal,
                      barWidth: 3,
                      isStrokeCapRound: true,
                      dotData: const FlDotData(show: true),
                      belowBarData: BarAreaData(
                        show: true,
                        color: Colors.teal.withValues(alpha: 0.15),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
