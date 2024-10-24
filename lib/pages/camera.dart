import 'dart:async';
import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:http/http.dart' as http;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '/add_pages/add_camera.dart';
import '/add_pages/camera_details.dart';
import '/time_stamp.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:path/path.dart' as Path;
import 'package:firebase_storage/firebase_storage.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'local_notifications.dart';
import 'dart:convert';

List<CameraDescription>? cameras;

Future<void> main() async {


  WidgetsFlutterBinding.ensureInitialized();
  cameras = await availableCameras();
  await Firebase.initializeApp();
  WidgetsFlutterBinding.ensureInitialized();
  await LocalNotifications.init();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: CameraPage(),
    );
  }
}

class CameraPage extends StatefulWidget {
  const CameraPage({super.key});

  @override
  State<CameraPage> createState() => _CameraPageState();
}

class _CameraPageState extends State<CameraPage> {
  final currentUser = FirebaseAuth.instance.currentUser;
  CameraController? _controller;
  Future<void>? _initializeControllerFuture;
  bool isCameraReady = false;
  Timer? _timer;
  int _selectedInterval = 1;
  List<int> intervals = [1, 2, 5, 10, 15, 30];

  @override
  void initState() {
    super.initState();
    initCamera();
  }

  Future<void> initCamera() async {

    if (cameras == null || cameras!.isEmpty) {
      cameras = await availableCameras();
    }

    if (cameras!.isNotEmpty) {
      _controller = CameraController(
        cameras![0],
        ResolutionPreset.medium,
      );
      _initializeControllerFuture = _controller!.initialize().then((_) {
        if (mounted) {
          setState(() {
            isCameraReady = true;
          });
          startAutomaticCapture(_selectedInterval);
        }
      }).catchError((e) {
        print("Camera initialization failed: $e");
      });
    } else {
      print("No cameras available.");
    }
  }

  void startAutomaticCapture(int minutes) {
    _timer?.cancel();
    _timer = Timer.periodic(Duration(minutes: minutes), (timer) async {
      if (!isCameraReady) {
        timer.cancel();
        return;
      }
      try {
        final file = await _controller!.takePicture();
        await Future.delayed(Duration(seconds: 2));
        uploadFile(File(file.path));
      } catch (e) {

      }
    });
  }

  Future<void> uploadFile(File file) async {
    if (!file.existsSync()) {
      print("File does not exist: ${file.path}");
      return;
    } else if (file.lengthSync() == 0) {
      print("File is empty: ${file.path}");
      return;
    }

    var uri = Uri.parse('http://192.168.100.81:5000');
    var request = http.MultipartRequest('POST', uri)
      ..files.add(await http.MultipartFile.fromPath('file', file.path));

    try {
      var streamedResponse = await request.send().timeout(Duration(seconds: 10));
      var response = await http.Response.fromStream(streamedResponse);

      if (response.statusCode == 200) {
        print('File uploaded successfully.');

        print('Prediction: ...');
        print('Time: ${DateTime.now().toString()}');

        var jsonData = jsonDecode(response.body);
        String base64Image = jsonData['image'];
        String message = jsonData['message'];
        String? det = await processResponse(message);
        //showToast(message);

        if(det.toString() != 'null'){


          LocalNotifications.showSimpleNotification(
              title: "Vilolation Alert",
              body: "Violation Detected",
              payload: "Violation Detected");

          // Assuming you have this base64Image from earlier steps:
          Uint8List bytes = base64Decode(base64Image);
          uploadImageToFirebase(bytes, det.toString()).then((downloadUrl) {
            // Use the download URL for further processing or storage

          });




        }
        else{

        }

      } else {
        print('Failed to upload file. Status code: ${response.statusCode}. Response body: ${response.body}');
      }
    } catch (e) {
      print('Exception during file upload: $e');
    }
  }





  Future<String?> uploadImageToFirebase(Uint8List imageData, String det) async {
    // Create a reference to the location you want to upload to in Firebase Storage
    Reference ref = FirebaseStorage.instance.ref().child('uploads/${det}.jpg');

    // Upload the image
    try {
      await ref.putData(imageData);
      // Get the URL of the uploaded image
      String downloadUrl = await ref.getDownloadURL();
      print('Upload successful. URL: $downloadUrl');
      return downloadUrl;  // Return the URL
    } catch (e) {
      print('Error occurred while uploading to Firebase: $e');
      return null;
    }
  }

















  void showToast(String msg) {
    Fluttertoast.showToast(
        msg: msg,
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.black,
        textColor: Colors.white,
        fontSize: 16.0
    );
  }
  String? extractDetail(String keyword, String response) {
    var regex = RegExp(r'\d+ ' + RegExp.escape(keyword));
    var match = regex.firstMatch(response);
    return match?.group(0)?.split(' ')[0];
  }
  Future<String?> processResponse(String responseBody) async {
    if (responseBody.contains('(no detections)')) {
      return null;
    } else {
      var violations = '';
      if (responseBody.contains('maskoff')) {
        var no_maskVal = extractDetail('maskoff', responseBody);
        var maskval = '$no_maskVal maskoff';
        violations += maskval + ' ';
      }

      if (responseBody.contains('no_glove')) {
        var no_gloveVal = extractDetail('no_glove', responseBody);
        var gloveval = '$no_gloveVal no_glove';
        violations += gloveval + ' ';
      }

      if (responseBody.contains('no_hairnet')) {
        var no_hairnetVal = extractDetail('no_hairnet', responseBody);
        var hairnetval = '$no_hairnetVal no_hairnet';
        violations += hairnetval + ' ';
      }

      try {
        DocumentReference docRef = await FirebaseFirestore.instance
            .collection('users')
            .doc(currentUser!.email)
            .collection('violations')
            .add({
          'timestamp': Timestamp.now(),
          'violation': violations,
        });

        String documentId = docRef.id;
        print('Document ID: $documentId');
        //showToast('Document ID: $documentId');
        return documentId; // Properly return the document ID after the document has been added
      } catch (e) {
        print('Error adding document: $e');
        return null; // Return null if an error occurs
      }
    }
  }

  @override
  void dispose() {
    _controller?.dispose();
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 80,
        elevation: 0,
        backgroundColor: Theme.of(context).colorScheme.background,
        shape: Border(
          bottom: BorderSide(
            color: Theme.of(context).colorScheme.primary,
            width: 3,
          ),
        ),
        actions: [
          Expanded(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [

                Container(
                  margin: EdgeInsets.symmetric(horizontal: 10),
                  padding: EdgeInsets.symmetric(horizontal: 10),
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.onPrimary,
                    border: Border.all(
                      color: Theme.of(context).colorScheme.secondary,
                    ),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: DropdownButtonHideUnderline(
                    child: DropdownButton<int>(
                      value: _selectedInterval,
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.secondary,
                        fontWeight: FontWeight.bold,
                      ),
                      items: intervals.map<DropdownMenuItem<int>>((int value) {
                        return DropdownMenuItem<int>(
                          value: value,
                          child: Text('$value min'),
                        );
                      }).toList(),
                      onChanged: (int? newValue) {
                        if (newValue != null) {
                          setState(() {
                            _selectedInterval = newValue;
                            startAutomaticCapture(_selectedInterval);
                          });
                        }
                      },
                    ),
                  ),
                ),

                GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => AddCamera()),
                    );
                  },
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                    decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.onPrimary,
                      border: Border.all(
                        color: Theme.of(context).colorScheme.secondary,
                      ),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Row(
                      children: [
                        Icon(
                          Icons.add,
                          size: 25,
                          color: Theme.of(context).colorScheme.secondary,
                        ),
                        SizedBox(width: 5),
                        Text(
                          'Add',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            color: Theme.of(context).colorScheme.secondary,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),

      body: SingleChildScrollView(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (isCameraReady && _controller != null)
                Container(
                  width: MediaQuery.of(context).size.width,
                  child: CameraPreview(_controller!),
                )
              else
                CircularProgressIndicator(),
            ],
          ),
        ),
      ),
    );
  }
}