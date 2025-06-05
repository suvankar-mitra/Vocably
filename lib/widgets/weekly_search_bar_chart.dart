import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:vocably/themes/app_colors.dart';

class WeeklySearchBarChart extends StatelessWidget {
  final List<int> searches;
  const WeeklySearchBarChart({super.key, required this.searches});

  @override
  Widget build(BuildContext context) {
    return BarChart(
      BarChartData(
        alignment: BarChartAlignment.spaceAround,
        gridData: FlGridData(show: true),
        maxY: (searches.reduce((a, b) => a > b ? a : b) + 2).toDouble(),
        barTouchData: BarTouchData(enabled: false),
        titlesData: FlTitlesData(
          bottomTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              getTitlesWidget: (value, _) {
                const days = ['S', 'M', 'T', 'W', 'T', 'F', 'S'];
                return Text(
                  days[value.toInt()],
                  style: GoogleFonts.poppins(color: Colors.grey[700], fontWeight: FontWeight.w600, fontSize: 12),
                );
              },
            ),
          ),
          leftTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
          topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
          rightTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              getTitlesWidget: (value, meta) {
                return Text(
                  '  ${value.toInt().toString()}',
                  style: GoogleFonts.poppins(color: Colors.grey[700], fontWeight: FontWeight.w600, fontSize: 12),
                );
              },
            ),
          ),
        ),
        borderData: FlBorderData(show: false),
        barGroups: List.generate(searches.length, (index) {
          return BarChartGroupData(
            x: index,
            barRods: [
              BarChartRodData(
                toY: searches[index].toDouble(),
                color: AppColors.appTitleColor,
                borderRadius: BorderRadius.circular(4),
                width: 10,
              ),
            ],
          );
        }),
      ),
    );
  }
}
