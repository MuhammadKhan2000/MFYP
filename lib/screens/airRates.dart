import 'dart:convert';
import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';

class AirRates extends StatefulWidget {
  const AirRates({super.key});

  @override
  State<AirRates> createState() => _AirRatesState();
}

class _AirRatesState extends State<AirRates> {
  TextEditingController txtAirLineName = TextEditingController();
  File? selectedFile;
  bool isUploading = false;
  String uploadStatus = '';

  Future<void> pickFile() async {
    final result = await FilePicker.platform.pickFiles();
    if (result != null && result.files.isNotEmpty) {
      setState(() {
        selectedFile = File(result.files.single.path!);
      });
    }
  }

  Future<void> uploadFileToServer(File file) async {
    setState(() {
      isUploading = true;
      uploadStatus = 'Uploading...';
    });

    try {
      final uri = Uri.parse(
          'http://192.168.236.189:5000/api/airRates/convert-pdf');
      final request = http.MultipartRequest('POST', uri);
      request.fields['airline'] = txtAirLineName.text.trim();
      request.files.add(await http.MultipartFile.fromPath(
        'file',
        file.path,
        filename: basename(file.path),
      ));

      final response = await request.send();

      if (response.statusCode == 200) {
        final responseBody = await response.stream.bytesToString();
        final responseData = jsonDecode(responseBody);

        String fileName = responseData['name'];
        String filePath = responseData['path'];
        await downloadFile(filePath);
        setState(() {
          uploadStatus = 'Uploaded: $fileName\nPath: $filePath';
          txtAirLineName.clear();
          selectedFile = null;
        });
      } else {
        setState(() =>
            uploadStatus = 'Upload failed! Status: ${response.statusCode}');
      }
    } catch (e) {
      setState(() => uploadStatus = 'Error: $e');
    } finally {
      setState(() => isUploading = false);
    }
  }

  Future<void> SaveFile(String fileContent, String fileName) async {
    try {
      final bytes = base64Decode(fileContent);
      final directory = await getApplicationDocumentsDirectory();
      final filePath = '${directory.path}/$fileName';
      final file = File(filePath);
      await file.writeAsBytes(bytes);
      Fluttertoast.showToast(msg: "File saved to $filePath");
    } catch (e) {
      Fluttertoast.showToast(msg: "Error downloading file: $e");
    }
  }

  Future<void> downloadFile(String path) async {
    try {
      final uri =
          Uri.parse('http://192.168.236.189:5000/api/download?file=$path');

      try {
        final response = await http.get(uri);

        if (response.statusCode == 200) {
          final fileContent = jsonDecode(response.body);
          await SaveFile(fileContent, path);
        } else {
          Fluttertoast.showToast(
              msg: "Process failed! Code: ${response.statusCode}");
        }
      } catch (e) {
        Fluttertoast.showToast(msg: "Error calling process API: $e");
      }
    } catch (e) {
      setState(() => uploadStatus = 'Error: $e');
    } finally {
      setState(() => isUploading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    w(x) => MediaQuery.of(context).size.width * (x / 490);
    h(y) => MediaQuery.of(context).size.height * (y / 890);
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Air Rates Conversion",
          style: GoogleFonts.poppins(
              fontSize: h(22),
              fontWeight: FontWeight.w600,
              color: Colors.white),
        ),
        centerTitle: true,
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: const Icon(Icons.arrow_back_outlined, color: Colors.white),
        ),
        backgroundColor: Colors.green,
      ),
      body: Padding(
        padding: EdgeInsets.all(w(10)),
        child: SingleChildScrollView(
          child: Column(
            children: [
              TextField(
                controller: txtAirLineName,
                decoration: const InputDecoration(
                  labelText: 'Airline Name*',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.airplanemode_on_outlined),
                ),
              ),
              Card(
                elevation: 8,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16)),
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.cloud_upload_outlined,
                          size: 50, color: Colors.grey.shade400),
                      const SizedBox(height: 16),
                      Text(
                        'Select file',
                        style: Theme.of(context)
                            .textTheme
                            .titleMedium
                            ?.copyWith(
                                fontWeight: FontWeight.bold,
                                color: Colors.grey.shade400),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        selectedFile != null
                            ? selectedFile!.path.split('/').last
                            : 'No file selected',
                        style: TextStyle(
                          fontStyle: FontStyle.italic,
                          color:
                              selectedFile != null ? Colors.black : Colors.grey,
                        ),
                      ),
                      const SizedBox(height: 20),
                      Container(
                        width: double.infinity,
                        child: ElevatedButton.icon(
                          onPressed: isUploading ? null : pickFile,
                          icon: const Icon(
                            Icons.upload_file,
                            color: Colors.white,
                          ),
                          label: Text("Choose File"),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.green,
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(
                                horizontal: 24, vertical: 12),
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12)),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              if (selectedFile != null &&
                  selectedFile?.path != null &&
                  txtAirLineName.text.isNotEmpty)
                Container(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: isUploading
                        ? null
                        : () => uploadFileToServer(selectedFile!),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green,
                      padding: const EdgeInsets.symmetric(
                          horizontal: 24, vertical: 12),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12)),
                    ),
                    child: isUploading
                        ? SizedBox(
                            width: 24,
                            height: 24,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              valueColor:
                                  AlwaysStoppedAnimation<Color>(Colors.green),
                            ),
                          )
                        : Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            mainAxisSize: MainAxisSize.min,
                            children: const [
                              Icon(Icons.upload, color: Colors.white),
                              SizedBox(width: 8),
                              Text("Upload"),
                            ],
                          ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
