import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import '../data/global_expense.dart';
import '../models/expense.dart';

class StatisticsScreen extends StatefulWidget {
  const StatisticsScreen({super.key});

  @override
  State<StatisticsScreen> createState() => _StatisticsScreenState();
}

class _StatisticsScreenState extends State<StatisticsScreen> {
  DateTimeRange? selectedRange;

  Map<String, double> _calculateCategoryTotals(List<Expense> expenses) {
    final Map<String, double> totals = {};
    for (var e in expenses) {
      if (selectedRange != null) {
        final expenseDate = DateTime(e.date.year, e.date.month, e.date.day);
        final startDate = DateTime(selectedRange!.start.year,
            selectedRange!.start.month, selectedRange!.start.day);
        final endDate = DateTime(
            selectedRange!.end.year, selectedRange!.end.month, selectedRange!.end.day);

        if (expenseDate.isBefore(startDate) || expenseDate.isAfter(endDate)) {
          continue;
        }
      }

      totals[e.category] = (totals[e.category] ?? 0) + e.amount;
    }
    return totals;
  }

  Future<void> _pickDateRange(BuildContext context) async {
    final now = DateTime.now();

    // Gunakan tampilan fullscreen agar lebih cocok untuk mobile
    final picked = await showDateRangePicker(
      context: context,
      firstDate: DateTime(2020),
      lastDate: now,
      initialDateRange: selectedRange ??
          DateTimeRange(
            start: DateTime(now.year, now.month, 1),
            end: now,
          ),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(
              primary: Colors.teal,
              onPrimary: Colors.white,
              surface: Colors.white,
              onSurface: Colors.black87,
            ),
          ),
          child: Center(
            child: Container(
              margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 24),
              child: child,
            ),
          ),
        );
      },
    );

    if (picked != null) {
      setState(() {
        selectedRange = picked;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final data = _calculateCategoryTotals(globalExpenses);

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Statistik Pengeluaran',
          style: TextStyle(color: Colors.white),
          
        ),
        backgroundColor: Colors.teal,
        iconTheme: const IconThemeData(color: Colors.white),
        actions: [
          TextButton.icon(
            onPressed: () => _pickDateRange(context),
            icon: const Icon(
              Icons.date_range,
              color: Colors.white,
            ),
            label: const Text(
              'Pilih Tanggal',
              style: TextStyle(color: Colors.white,),),
            style: TextButton.styleFrom(
              foregroundColor: Colors.white,
            ),
          ),
          const SizedBox(width: 8),
        ],
      ),
      // floatingActionButton: FloatingActionButton.extended(
      //   backgroundColor: Colors.teal,
      //   icon: const Icon(Icons.date_range, color: Colors.white),
      //   label: const Text(
      //     'Pilih Tanggal',
      //     style: TextStyle(color: Colors.white),
      //   ),
      //   onPressed: () => _pickDateRange(context),
      // ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: data.isEmpty
            ? const Center(
                child: Text(
                  'Belum ada data pengeluaran untuk ditampilkan.',
                  style: TextStyle(fontSize: 16, color: Colors.grey),
                ),
              )
            : Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (selectedRange != null)
                    Padding(
                      padding: const EdgeInsets.only(bottom: 12),
                      child: Text(
                        'Periode: ${selectedRange!.start.day}/${selectedRange!.start.month}/${selectedRange!.start.year} '
                        '- ${selectedRange!.end.day}/${selectedRange!.end.month}/${selectedRange!.end.year}',
                        style: const TextStyle(
                          fontSize: 14,
                          color: Colors.teal,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  const Text(
                    'Total Pengeluaran per Kategori',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.teal,
                    ),
                  ),
                  const SizedBox(height: 20),
                  Expanded(
                    child: BarChart(
                      BarChartData(
                        borderData: FlBorderData(show: false),
                        gridData: const FlGridData(show: false),
                        alignment: BarChartAlignment.spaceAround,
                        barTouchData: BarTouchData(
                          enabled: true,
                          touchTooltipData: BarTouchTooltipData(
                            tooltipBgColor: Colors.teal.shade100,
                            getTooltipItem: (group, groupIndex, rod, rodIndex) {
                              final category = data.keys.elementAt(groupIndex);
                              final value = rod.toY.toStringAsFixed(0);
                              return BarTooltipItem(
                                '$category\nRp$value',
                                const TextStyle(
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold,
                                ),
                              );
                            },
                          ),
                        ),
                        titlesData: FlTitlesData(
                          topTitles: const AxisTitles(
                              sideTitles: SideTitles(showTitles: false)),
                          rightTitles: const AxisTitles(
                              sideTitles: SideTitles(showTitles: false)),
                          leftTitles: AxisTitles(
                            sideTitles: SideTitles(
                              showTitles: true,
                              reservedSize: 60,
                              interval: (data.values.isNotEmpty)
                                  ? (data.values.reduce((a, b) => a > b ? a : b) /
                                          5)
                                      .ceilToDouble()
                                  : 1000,
                              getTitlesWidget: (value, _) => Text(
                                'Rp${value.toStringAsFixed(0)}',
                                style: const TextStyle(fontSize: 10),
                              ),
                            ),
                          ),
                          bottomTitles: AxisTitles(
                            sideTitles: SideTitles(
                              showTitles: true,
                              getTitlesWidget: (value, _) {
                                final keys = data.keys.toList();
                                if (value.toInt() >= 0 &&
                                    value.toInt() < keys.length) {
                                  return Padding(
                                    padding: const EdgeInsets.only(top: 8.0),
                                    child: Text(
                                      keys[value.toInt()],
                                      style: const TextStyle(fontSize: 12),
                                    ),
                                  );
                                }
                                return const SizedBox.shrink();
                              },
                            ),
                          ),
                        ),
                        barGroups: List.generate(data.length, (index) {
                          final key = data.keys.elementAt(index);
                          final value = data[key]!;
                          return BarChartGroupData(
                            x: index,
                            barRods: [
                              BarChartRodData(
                                toY: value,
                                color: Colors.teal,
                                width: 22,
                                borderRadius: BorderRadius.circular(6),
                              ),
                            ],
                          );
                        }),
                        maxY: (data.values.isNotEmpty)
                            ? data.values.reduce((a, b) => a > b ? a : b) * 1.2
                            : 1000,
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.teal.shade50,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      'Total Keseluruhan: Rp ${data.values.fold<double>(0, (a, b) => a + b).toStringAsFixed(0)}',
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
      ),
    );
  }
}
