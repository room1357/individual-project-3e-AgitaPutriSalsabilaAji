import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import '../data/global_expense.dart';
import '../models/expense.dart';

class StatisticsScreen extends StatelessWidget {
  const StatisticsScreen({super.key});

  // Hitung total pengeluaran per kategori
  Map<String, double> _calculateCategoryTotals(List<Expense> expenses) {
    final Map<String, double> totals = {};
    for (var e in expenses) {
      totals[e.category] = (totals[e.category] ?? 0) + e.amount;
    }
    return totals;
  }

  @override
  Widget build(BuildContext context) {
    final data = _calculateCategoryTotals(globalExpenses);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Statistik Pengeluaran'),
        backgroundColor: Colors.teal,
      ),
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
                  const Text(
                    'Total Pengeluaran per Kategori',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.teal,
                    ),
                  ),
                  const SizedBox(height: 20),

                  // ===== GRAFIK BATANG =====
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
                                    fontWeight: FontWeight.bold),
                              );
                            },
                          ),
                        ),
                        titlesData: FlTitlesData(
                          topTitles:
                              const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                          rightTitles:
                              const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                          leftTitles: AxisTitles(
                            sideTitles: SideTitles(
                              showTitles: true,
                              reservedSize: 60,
                              interval: (data.values.isNotEmpty)
                                  ? (data.values.reduce((a, b) => a > b ? a : b) / 5)
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

                  // ===== TOTAL KESELURUHAN =====
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
