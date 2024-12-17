import 'dart:convert';
import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show SystemUiOverlayStyle;
import 'package:csv/csv.dart';

class BulkUpload extends StatefulWidget {
  const BulkUpload({Key? key}) : super(key: key);

  @override
  State<BulkUpload> createState() => _BulkUploadState();
}

class _BulkUploadState extends State<BulkUpload> {
  List<List<dynamic>> _data = [];
  String? filePath;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        systemOverlayStyle: const SystemUiOverlayStyle(
          statusBarColor: Colors.white,
          statusBarIconBrightness: Brightness.dark,
          statusBarBrightness: Brightness.light,
        ),
        title: const Text(
          "Bulk Upload",
          style: TextStyle(color: Colors.white, fontSize: 20.0),
        ),
      ),
      body: Column(
        children: [
          ElevatedButton(
            child: const Text("Upload File"),
            onPressed: _pickFile,
          ),
          _data.isNotEmpty
              ? Expanded(
                  child: ListView.builder(
                    itemCount: _data.length,
                    itemBuilder: (_, index) {
                      return Card(
                        margin: const EdgeInsets.all(3),
                        color: index == 0 ? Colors.amber : Colors.white,
                        child: ListTile(
                          leading: Text(
                            _data[index][0].toString(),
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: index == 0 ? 18 : 15,
                              fontWeight: index == 0
                                  ? FontWeight.bold
                                  : FontWeight.normal,
                              color: index == 0 ? Colors.red : Colors.black,
                            ),
                          ),
                          title: Text(
                            _data[index][3].toString(),
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: index == 0 ? 18 : 15,
                              fontWeight: index == 0
                                  ? FontWeight.bold
                                  : FontWeight.normal,
                              color: index == 0 ? Colors.red : Colors.black,
                            ),
                          ),
                          trailing: Text(
                            _data[index][4].toString(),
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: index == 0 ? 18 : 15,
                              fontWeight: index == 0
                                  ? FontWeight.bold
                                  : FontWeight.normal,
                              color: index == 0 ? Colors.red : Colors.black,
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                )
              : const Text("No Data Uploaded"),
          ElevatedButton(
            onPressed: () async {
              if (_data.isEmpty) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text("No data to iterate.")),
                );
                return;
              }
              for (var element in _data.skip(1)) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(element.toString()),
                  ),
                );
              }
            },
            child: const Text("Iterate Data"),
          ),
          ElevatedButton(
            onPressed: () async {
              if (_data.isEmpty) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text("No data to convert Json.")),
                );
                return;
              }
              convertCsvToJson(_data);
            },
            child: const Text("Convert Json"),
          ),

        ],
      ),
    );
  }

  void _pickFile() async {
    final result = await FilePicker.platform.pickFiles(allowMultiple: false);

    if (result == null) return;

    try {
      if (kIsWeb) {
        // For web, use bytes
        final bytes = result.files.first.bytes;
        if (bytes == null) {
          throw Exception("No file data available.");
        }
        final csvData = utf8.decode(bytes);
        final fields = const CsvToListConverter().convert(csvData);

        setState(() {
          _data = fields;
        });
      } else {
        // For non-web platforms, use path
        filePath = result.files.first.path;
        final input = File(filePath!).openRead();
        final fields = await input
            .transform(utf8.decoder)
            .transform(const CsvToListConverter())
            .toList();

        setState(() {
          _data = fields;
        });
      }
    } catch (e) {
      print("Error parsing file: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error reading file: $e")),
      );
    }
  }

  // Separate function to convert CSV to JSON
  void convertCsvToJson(List<List<dynamic>> csvData) {
    List<SaleData> saleDataList = [];

    // Skipping the header row (index 0) and converting CSV rows into SaleData
    for (var row in csvData.skip(1)) {
      saleDataList.add(SaleData.fromCsv(row));
    }

    // Convert SaleData list to JSON format
    List<String> jsonData =
        saleDataList.map((data) => jsonEncode(data.toJson())).toList();

    // Output JSON data (you can return or do other processing here)
    for (var json in jsonData) {
      print(json); // You can replace this with any other functionality you need
    }
  }
}

// Sale Data Model Class
class SaleData {
  final String orderId;
  final String productName;
  final int quantityOrdered;
  final double priceEach;
  final String orderDate;
  final String purchaseAddress;
  final String paymentMethod;
  final String productId;
  final String customerId;
  final String customerName;

  SaleData({
    required this.orderId,
    required this.productName,
    required this.quantityOrdered,
    required this.priceEach,
    required this.orderDate,
    required this.purchaseAddress,
    required this.paymentMethod,
    required this.productId,
    required this.customerId,
    required this.customerName,
  });

  // Factory constructor to create SaleData from CSV row
  factory SaleData.fromCsv(List<dynamic> csvRow) {
    // Make sure row has the expected number of columns
    if (csvRow.length < 10) {
      throw Exception('Invalid CSV row: ${csvRow.join(', ')}');
    }
    return SaleData(
      orderId: csvRow[0].toString(),
      productName: csvRow[1].toString(),
      quantityOrdered: int.tryParse(csvRow[2].toString()) ?? 0,
      priceEach: double.tryParse(csvRow[3].toString()) ?? 0.0,
      orderDate: csvRow[4].toString(),
      purchaseAddress: csvRow[5].toString(),
      paymentMethod: csvRow[6].toString(),
      productId: csvRow[7].toString(),
      customerId: csvRow[8].toString(),
      customerName: csvRow[9].toString(),
    );
  }

  // Convert SaleData to JSON format
  Map<String, dynamic> toJson() {
    return {
      'orderId': orderId,
      'productName': productName,
      'quantityOrdered': quantityOrdered,
      'priceEach': priceEach,
      'orderDate': orderDate,
      'purchaseAddress': purchaseAddress,
      'paymentMethod': paymentMethod,
      'productId': productId,
      'customerId': customerId,
      'customerName': customerName,
    };
  }
}
