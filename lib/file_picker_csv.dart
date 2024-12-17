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

}
