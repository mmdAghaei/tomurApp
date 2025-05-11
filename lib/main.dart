import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      home: home(),
    );
  }
}

class home extends StatefulWidget {
  const home({super.key});

  @override
  State<home> createState() => _homeState();
}

class _homeState extends State<home> {
  @override
  String ip = "";
  TextEditingController ipController = TextEditingController();
  File? _selectedImage;
  Uint8List? _responseBytes;
  bool _isLoading = false;
  Future<void> _pickImage() async {
    final ImagePicker picker = ImagePicker();
    final XFile? image = await picker.pickImage(source: ImageSource.gallery);

    if (image != null) {
      setState(() {
        _selectedImage = File(image.path);
      });
    }
  }

  Future<void> _uploadImage() async {
    if (_selectedImage == null) return;
    setState(() => _isLoading = true);

    final uri = Uri.parse('http://$ip/app/python/');
    final request = http.MultipartRequest('POST', uri)
      ..files.add(
        await http.MultipartFile.fromPath('image', _selectedImage!.path),
      );

    try {
      final streamed = await request.send();
      if (streamed.statusCode == 200) {
        final bytes = await streamed.stream.toBytes();
        setState(() {
          _responseBytes = bytes;
        });
      } else {
        // خطای سرور
        print('Server error: ${streamed.statusCode}');
      }
    } catch (e) {
      print('Upload failed: $e');
    } finally {
      setState(() => _isLoading = false);
    }
  }

  void initState() {
    super.initState();
    Future.delayed(Duration.zero, () {
      showDialog(
        context: context,
        builder:
            (context) => ClipRRect(
              borderRadius: BorderRadius.circular(20),
              child: Dialog(
                insetAnimationDuration: Duration(seconds: 1),
                insetAnimationCurve: Curves.easeIn,
                backgroundColor: Colors.white,
                child: Container(
                  alignment: Alignment.center,
                  height: 300,
                  padding: EdgeInsets.all(20),
                  width: MediaQuery.of(context).size.width - 100,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      TextField(
                        controller: ipController,
                        decoration: InputDecoration(
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(15),
                          ),
                          labelText: 'Enter IP Address',
                          hintStyle: TextStyle(color: Colors.grey),
                          labelStyle: TextStyle(color: Colors.grey),
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                              color: Colors.amberAccent,
                              width: 2.0,
                            ),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                              color: Colors.grey,
                              width: 2.0,
                            ),
                          ),
                          errorBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                              color: Colors.red,
                              width: 2.0,
                            ),
                          ),
                          focusedErrorBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                              color: Colors.red,
                              width: 2.0,
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: 20),
                      SizedBox(
                        width: 200,
                        height: 35,
                        child: ElevatedButton(
                          onPressed: () {
                            setState(() {
                              ip = ipController.text;
                            });
                            Navigator.pop(context);
                          },
                          child: Text("Set"),
                          style: ButtonStyle(
                            foregroundColor: WidgetStatePropertyAll(
                              Colors.black,
                            ),
                            backgroundColor: WidgetStatePropertyAll(
                              Colors.amberAccent,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black87,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            InkWell(
              onDoubleTap: () {
                showDialog(
                  context: context,
                  builder:
                      (context) => ClipRRect(
                        borderRadius: BorderRadius.circular(20),
                        child: Dialog(
                          insetAnimationDuration: Duration(seconds: 1),
                          insetAnimationCurve: Curves.easeIn,
                          backgroundColor: Colors.white,
                          child: Container(
                            alignment: Alignment.center,
                            height: 300,
                            padding: EdgeInsets.all(20),
                            width: MediaQuery.of(context).size.width - 100,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                TextField(
                                  controller: ipController,
                                  decoration: InputDecoration(
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(15),
                                    ),
                                    labelText: 'Enter IP Address',
                                    hintStyle: TextStyle(color: Colors.grey),
                                    labelStyle: TextStyle(color: Colors.grey),
                                    focusedBorder: OutlineInputBorder(
                                      borderSide: BorderSide(
                                        color: Colors.amberAccent,
                                        width: 2.0,
                                      ),
                                    ),
                                    enabledBorder: OutlineInputBorder(
                                      borderSide: BorderSide(
                                        color: Colors.grey,
                                        width: 2.0,
                                      ),
                                    ),
                                    errorBorder: OutlineInputBorder(
                                      borderSide: BorderSide(
                                        color: Colors.red,
                                        width: 2.0,
                                      ),
                                    ),
                                    focusedErrorBorder: OutlineInputBorder(
                                      borderSide: BorderSide(
                                        color: Colors.red,
                                        width: 2.0,
                                      ),
                                    ),
                                  ),
                                ),
                                SizedBox(height: 20),
                                SizedBox(
                                  width: 200,
                                  height: 35,
                                  child: ElevatedButton(
                                    onPressed: () {
                                      setState(() {
                                        ip = ipController.text;
                                      });
                                      Navigator.pop(context);
                                    },
                                    child: Text("Set"),
                                    style: ButtonStyle(
                                      foregroundColor: WidgetStatePropertyAll(
                                        Colors.black,
                                      ),
                                      backgroundColor: WidgetStatePropertyAll(
                                        Colors.amberAccent,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                );
              },
              child: Text(
                "$ip",
                style: TextStyle(color: Colors.white, fontSize: 20),
              ),
            ),
            SizedBox(height: 20),

            Container(
              width: 300,
              height: 300,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(15),
                color: Colors.grey,
                // image:
                //     _selectedImage != null
                //         ? DecorationImage(
                //           image: FileImage(_selectedImage!),
                //           fit: BoxFit.cover,
                //         )
                //         : null,
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(15),
                child:
                    _isLoading
                        ? Center(child: CircularProgressIndicator())
                        : _responseBytes != null
                        ? Image.memory(_responseBytes!, fit: BoxFit.cover)
                        : _selectedImage != null
                        ? Image.file(_selectedImage!, fit: BoxFit.cover)
                        : SizedBox(),
              ),
            ),
            SizedBox(height: 20),
            SizedBox(
              width: 200,
              height: 35,
              child: ElevatedButton(
                onPressed: _selectedImage == null ? _pickImage : _uploadImage,
                child: Text(_selectedImage != null ? "Send" : "Browese"),
                style: ButtonStyle(
                  foregroundColor: WidgetStatePropertyAll(Colors.black),
                  backgroundColor: WidgetStatePropertyAll(Colors.amberAccent),
                ),
              ),
            ),
            SizedBox(height: 10),
            _selectedImage != null
                ? SizedBox(
                  width: 200,
                  height: 35,
                  child: ElevatedButton(
                    onPressed: () {
                      setState(() {
                        _selectedImage = null;
                      });
                    },
                    child: Text("Delete"),
                    style: ButtonStyle(
                      foregroundColor: WidgetStatePropertyAll(Colors.black),
                      backgroundColor: WidgetStatePropertyAll(Colors.redAccent),
                    ),
                  ),
                )
                : SizedBox(),
          ],
        ),
      ),
    );
  }
}
