import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:pie_chart/pie_chart.dart';
import 'package:untitled/Graph/pie_chart.dart';
import 'package:untitled/inner_circlel.dart';
import 'package:device_preview/device_preview.dart';
import 'Graph/bar_chart.dart';
import 'file_picker_csv.dart';

void main() {
  runApp(
    DevicePreview(
      enabled: !kReleaseMode,
      builder: (context) => MyApp(), // Wrap your app
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Investment Coin Tracker',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: ChartWidget(),
    );
  }
}

class ChartWidget extends StatefulWidget {
  const ChartWidget({super.key});

  @override
  State<ChartWidget> createState() => _ChartWidgetState();
}

class _ChartWidgetState extends State<ChartWidget> {
  @override
  Widget build(BuildContext context) {
    List<MyListTilte> myListTitle = [
      MyListTilte(
          name: "PieChart",
          function: () {
            Navigator.of(context).push(MaterialPageRoute(
              builder: (context) => MyHomePage(),
            ));
          }),
      MyListTilte(
          name: "Inner Circle",
          function: () {
            Navigator.of(context).push(MaterialPageRoute(
              builder: (context) => CustomInnerConcaveContainer(),
            ));
          }),
      MyListTilte(
          name: "CSV File Picker",
          function: () {
            Navigator.of(context).push(MaterialPageRoute(
              builder: (context) => BulkUpload(),
            ));
          }),
      MyListTilte(
          name: "PieChart",
          function: () {
            Navigator.of(context).push(MaterialPageRoute(
              builder: (context) => PieChartExample(),
            ));
          }),
      MyListTilte(
          name: "BarChart",
          function: () {
            Navigator.of(context).push(MaterialPageRoute(
              builder: (context) => BarChartSample (),
            ));
          }),
    ];
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.orange,
        title: Text("My Chart Widgets"),
      ),
      body: Center(
        child: ListView.builder(
          itemCount: myListTitle.length,
          itemBuilder: (context, index) {
            MyListTilte eachListTitle = myListTitle[index];
            int number = index + 1;
            return InkWell(
              onTap: eachListTitle.function,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Card(
                  child: ListTile(
                    leading: CircleAvatar(
                      child: Text(
                        number.toString(),
                      ),
                    ),
                    title: Text(eachListTitle.name),
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final double ton = 10;
  final double star = 5000;

  @override
  Widget build(BuildContext context) {
    // Convert Stars to TON using the given conversion rate
    final double starInTon = star * 0.0030369;

    // Calculate total value in TON
    final double totalValue = ton + starInTon;

    // Calculate percentages
    final double tonPercentage = (ton / totalValue) * 100;
    final double starPercentage = (starInTon / totalValue) * 100;

    // Create the data map for PieChart
    Map<String, double> percentage = {
      "TON": tonPercentage,
      "Star": starPercentage,
    };

    return Scaffold(
      appBar: AppBar(
        title: const Text('Investment Coin Tracker'),
      ),
      body: Center(
        child: PieChart(
          dataMap: percentage,
          chartRadius: 300,
          colorList: [Color(0xff099aed), Color(0xfffed008)],
          chartValuesOptions: const ChartValuesOptions(
            chartValueStyle: TextStyle(color: Colors.black),
            showChartValues: true,
            showChartValuesInPercentage: true,
          ),
          animationDuration: const Duration(milliseconds: 1500),
          legendOptions: LegendOptions(
            legendPosition: LegendPosition.bottom,
            legendTextStyle: TextStyle(
              fontSize: 18, // Change the font size here
              fontWeight: FontWeight.bold, // Make the text bold
              color: Colors.black,
            ),
          ),
        ),
      ),
    );
  }
}

class MyListTilte {
  final String name;
  final VoidCallback function;
  MyListTilte({required this.name, required this.function});
}
