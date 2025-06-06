import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:vocably/themes/app_colors.dart';

class WeeklySearchLineChart extends StatelessWidget {
  final List<int> searches;
  const WeeklySearchLineChart({super.key, required this.searches});

  @override
  Widget build(BuildContext context) {
    return LineChart(
      LineChartData(
        maxY: (searches.reduce((a, b) => a > b ? a : b) + 2).toDouble(),
        minY: 0,
        gridData: FlGridData(show: true),
        titlesData: FlTitlesData(
          bottomTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              getTitlesWidget: (value, _) {
                const days = ['MO', 'TU', 'WE', 'TH', 'FR', 'SA', 'SU', ];
                return Text(
                  days[value.toInt()],
                  style: GoogleFonts.poppins(color: Colors.grey[700], fontWeight: FontWeight.w600, fontSize: 10),
                );
              },
            ),
          ),
          rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
          topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
          leftTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              getTitlesWidget: (value, meta) {
                return Text(
                  '${value.toInt()}',
                  style: GoogleFonts.poppins(color: Colors.grey[700], fontWeight: FontWeight.w600, fontSize: 10),
                );
              },
            ),
          ),
        ),
        borderData: FlBorderData(show: false),
        lineTouchData: LineTouchData(
          touchTooltipData: LineTouchTooltipData(
            getTooltipColor: (touchedSpot) => _getColor(),
            getTooltipItems: (List<LineBarSpot> touchedSpots) {
              return touchedSpots.map((spot) {
                return LineTooltipItem(
                  'Search: ${spot.y.toInt()}',
                  TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.w600),
                );
              }).toList();
            },
          ),
        ),
        lineBarsData: [
          LineChartBarData(
            spots: List.generate(searches.length, (index) => FlSpot(index.toDouble(), searches[index].toDouble())),
            isCurved: true,
            color: AppColors.appTitleColor,
            barWidth: 3,
            dotData: FlDotData(
              show: true,
              getDotPainter:
                  (spot, percent, bar, index) => FlDotCirclePainter(
                    radius: 4,
                    color: AppColors.appTitleColor,
                    strokeWidth: 1.5,
                    strokeColor: Colors.white,
                  ),
            ),
            belowBarData: BarAreaData(show: false),
          ),
        ],
      ),
    );
  }
}

_getColor() {
  return AppColors.primaryAccentColor;
}
