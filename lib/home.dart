import 'package:flutter/material.dart';
import 'barcode_scanner.dart';
import 'face_detector.dart';
import 'label_detector.dart';
import 'text_recognition.dart';

class HomePage extends StatelessWidget {
  final appName;

  const HomePage({Key key, this.appName}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(appName),
        centerTitle: true,
      ),
      body: HomeBody(),
    );
  }
}

class HomeBody extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var _primaryColor = Theme.of(context).primaryColor;

    return Container(
      padding: EdgeInsets.only(left: 36.0, right: 36.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          RaisedButton(
            onPressed: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => TextRecognition()));
            },
            child: Text(
              "TEXT RECOGNITION",
              style: TextStyle(color: Colors.white),
            ),
            color: _primaryColor,
          ),
          RaisedButton(
            onPressed: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => BarcodeScanner()));
            },
            child: Text(
              "BARCODE SCANNER",
              style: TextStyle(color: Colors.white),
            ),
            color: _primaryColor,
          ),
          RaisedButton(
            onPressed: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => FaceDetector()));
            },
            child: Text(
              "FACE DETECTOR",
              style: TextStyle(color: Colors.white),
            ),
            color: _primaryColor,
          ),
          RaisedButton(
            onPressed: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => LabelDetector()));
            },
            child: Text(
              "LABEL DETECTOR",
              style: TextStyle(color: Colors.white),
            ),
            color: _primaryColor,
          ),
        
        ],
      ),
    );
  }
}
