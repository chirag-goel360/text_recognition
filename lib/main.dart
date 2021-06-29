import 'dart:io';
import 'package:flutter/material.dart';
import 'package:google_ml_kit/google_ml_kit.dart';
import 'package:image_picker/image_picker.dart';

void main() {
  runApp(
    HomePage(),
  );
}

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Text Recognition',
      home: TextRecognize(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class TextRecognize extends StatefulWidget {
  @override
  _TextRecognizeState createState() => _TextRecognizeState();
}

class _TextRecognizeState extends State<TextRecognize> {
  File _file;
  String result = '';
  ImagePicker imagePicker;
  TextDetector textDetector;

  @override
  void initState() {
    super.initState();
    imagePicker = ImagePicker();
    textDetector = GoogleMlKit.vision.textDetector();
  }

  doTextRecognition() async {
    final inputImage = InputImage.fromFile(
      _file,
    );
    final RecognisedText recognisedText = await textDetector.processImage(
      inputImage,
    );
    String text = recognisedText.text;
    setState(() {
      result = text;
    });
  }

  _cameraImage() async {
    PickedFile image = await imagePicker.getImage(
      source: ImageSource.camera,
    );
    _file = File(
      image.path,
    );
    setState(() {
      if (_file != null) {
        doTextRecognition();
      }
    });
  }

  _galleryImage() async {
    PickedFile image = await imagePicker.getImage(
      source: ImageSource.gallery,
    );
    _file = File(
      image.path,
    );
    setState(() {
      if (_file != null) {
        doTextRecognition();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage(
              'images/background.jpg',
            ),
            fit: BoxFit.cover,
          ),
        ),
        child: Column(
          children: [
            Container(
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage(
                    'images/notebook.png',
                  ),
                  fit: BoxFit.cover,
                ),
              ),
              height: height / 2.5,
              width: width / 1.5,
              margin: EdgeInsets.only(
                top: 60,
              ),
              child: Padding(
                padding: EdgeInsets.only(
                  left: 25,
                  top: 5,
                  right: 10,
                  bottom: 20,
                ),
                child: SingleChildScrollView(
                  child: SelectableText(
                    '$result',
                    textAlign: TextAlign.justify,
                    style: TextStyle(
                      fontSize: 10,
                    ),
                  ),
                ),
              ),
            ),
            Container(
              margin: EdgeInsets.only(
                top: 20,
              ),
              child: Stack(
                children: [
                  Stack(
                    children: [
                      Center(
                        child: Image.asset(
                          'images/clipboard.png',
                          height: height / 2.5,
                          width: width / 1.5,
                        ),
                      ),
                    ],
                  ),
                  Center(
                    child: TextButton(
                      onPressed: _galleryImage,
                      onLongPress: _cameraImage,
                      child: Container(
                        child: _file != null
                            ? Padding(
                                padding: EdgeInsets.only(
                                  top: 40,
                                ),
                                child: Image.file(
                                  _file,
                                  height: height / 2.5 - 100,
                                  width: width / 1.5 - 100,
                                  fit: BoxFit.fill,
                                ),
                              )
                            : Container(
                                width: 140,
                                height: 150,
                                child: Icon(
                                  Icons.find_in_page,
                                  color: Colors.grey[800],
                                ),
                              ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
