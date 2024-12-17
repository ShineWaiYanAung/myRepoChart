import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
class PieChartExample extends StatelessWidget {
  const PieChartExample({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PieChart(
        PieChartData(
          sectionsSpace: 0,
          centerSpaceRadius: 70,
          sections: getSections()
        )
      )
    );
  }
}
class PieData{
  static List<Data> data =[
    Data(name: 'Blue', percent: 40, color: const Color(0xff0293ee)),
    Data(name: 'Orange', percent: 30, color: const Color(0xfff8b250)),
    Data(name: 'Black', percent: 15, color: Colors.black),
    Data(name: 'Green', percent: 15, color: const Color(0xff13d38e))
  ];
}
class Data {
  final String name;

  final double percent;

  final Color color;

  Data({required this.name,required this.percent,required this.color});
}
List<PieChartSectionData> getSections()=> PieData.data.asMap().map<int,PieChartSectionData>((index,data){
  final value = PieChartSectionData(
    color: data.color,
    value: data.percent,
    title: "${data.percent}%",
    titleStyle: TextStyle(fontWeight: FontWeight.bold,color: Colors.white),
  );

  return MapEntry(index, value);
}).values.toList();

