import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';

class BarChartSample extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Monthly Quantity Data")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: BarChart(
          BarChartData(
            alignment: BarChartAlignment.spaceAround,
            maxY: 100,
            barGroups:  [
              makeGroupData(0, 50),
              makeGroupData(1, 80),
              makeGroupData(2, 30),
              makeGroupData(3, 60),
              makeGroupData(4, 20),
              makeGroupData(5, 90),
              makeGroupData(6, 40),
              makeGroupData(7, 70),
              makeGroupData(8, 10),
              makeGroupData(9, 50),
              makeGroupData(10, 75),
              makeGroupData(11, 65),
            ],
            titlesData: FlTitlesData(
              leftTitles: AxisTitles(
                sideTitles: SideTitles(
                  showTitles: true,
                  interval: 20,
                  reservedSize: 40,
                  getTitlesWidget: (value, meta) {
                    return Text(
                      '${value.toInt()}',
                      style: TextStyle(fontSize: 12),
                    );
                  },
                ),
              ),
              rightTitles: AxisTitles(
                sideTitles: SideTitles(showTitles: false), // Hide right Y-axis
              ),
              topTitles: AxisTitles(
                sideTitles: SideTitles(showTitles: false), // Hide top titles
              ),
              bottomTitles: AxisTitles(
                sideTitles: SideTitles(
                  showTitles: true,
                  getTitlesWidget: (value, meta) {
                    switch (value.toInt()) {
                      case 0:
                        return Text('Jan');
                      case 1:
                        return Text('Feb');
                      case 2:
                        return Text('Mar');
                      case 3:
                        return Text('Apr');
                      case 4:
                        return Text('May');
                      case 5:
                        return Text('Jun');
                      case 6:
                        return Text('Jul');
                      case 7:
                        return Text('Aug');
                      case 8:
                        return Text('Sep');
                      case 9:
                        return Text('Oct');
                      case 10:
                        return Text('Nov');
                      case 11:
                        return Text('Dec');
                      default:
                        return Text('');
                    }
                  },
                  reservedSize: 40,
                ),
              ),
            ),
            // Show border with custom color
            borderData: FlBorderData(
              show: true,
              border: Border.all(
                color: Colors.blueGrey, // Set the border color
                width: 2, // Set the border width
              ),
            ),
            gridData: FlGridData(
              show: true,
              horizontalInterval: 20,
              drawHorizontalLine: true, // Enable horizontal lines
              drawVerticalLine: false, // Disable vertical lines
              getDrawingHorizontalLine: (value) {
                return FlLine(
                  color: Colors.green.withOpacity(0.5), // Set horizontal line color
                  strokeWidth: 1,
                );
              },
            ),
          ),
        ),
      ),
    );
  }

  BarChartGroupData makeGroupData(int x, double y) {
    return BarChartGroupData(
      x: x,
      barRods: [
        BarChartRodData(
          toY: y,
          color: Colors.blueAccent,
          width: 10,
          borderRadius: BorderRadius.circular(4), // Rounded bars
        ),
      ],
    );
  }
}
