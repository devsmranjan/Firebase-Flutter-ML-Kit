import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:fab_menu/fab_menu.dart';
import 'package:firebase_ml_vision/firebase_ml_vision.dart';
import 'package:image_picker/image_picker.dart';
import 'data_list.dart';

class FaceDetector extends StatefulWidget {
  @override
  _FaceDetectorState createState() => _FaceDetectorState();
}

class _FaceDetectorState extends State<FaceDetector> {
  List<MenuData> menuDataList;
  File _imageFile;
  Size _imageSize;
  dynamic _scanResults;
  List<String> _dataList = <String>[];

  @override
  void initState() {
    super.initState();
    menuDataList = [
      new MenuData(Icons.photo_library, (context, menuData) {
        _getAndScanImageFromGallery();
      }, labelText: 'Open Gallery'),
      new MenuData(Icons.camera, (context, menuData) {
        _getAndScanImageFromCamera();
      }, labelText: 'Open Camera')
    ];
  }

  Future<void> _getAndScanImageFromGallery() async {
    setState(() {
      _imageFile = null;
      _imageSize = null;
    });

    final File imageFile =
        await ImagePicker.pickImage(source: ImageSource.gallery);

    if (imageFile != null) {
      _getImageSize(imageFile);
      _scanImage(imageFile);
    }

    setState(() {
      _imageFile = imageFile;
    });
  }

  Future<void> _getAndScanImageFromCamera() async {
    setState(() {
      _imageFile = null;
      _imageSize = null;
    });

    final File imageFile =
        await ImagePicker.pickImage(source: ImageSource.camera);

    if (imageFile != null) {
      _getImageSize(imageFile);
      _scanImage(imageFile);
    }

    setState(() {
      _imageFile = imageFile;
    });
  }

  Future<void> _getImageSize(File imageFile) async {
    final Image image = Image.file(imageFile);
    final Completer<Size> completer = Completer<Size>();

    image.image
        .resolve(const ImageConfiguration())
        .addListener((ImageInfo info, bool _) {
      completer.complete(Size(
        info.image.width.toDouble(),
        info.image.height.toDouble(),
      ));
    });

    final Size imageSize = await completer.future;
    print(imageSize);

    setState(() {
      _imageSize = imageSize;
    });
  }

  Future<void> _scanImage(File imageFile) async {
    setState(() {
      _scanResults = null;
    });

    final FirebaseVisionImage visionImage =
        FirebaseVisionImage.fromFile(imageFile);
    // final FaceDetector detector = FirebaseVision.instance.faceDetector();
    // dynamic results = await detector.processImage(visionImage);
    final detector = FirebaseVision.instance.faceDetector();
    dynamic results = await detector.processImage(visionImage);

    if (mounted) {
      setState(() {
        _scanResults = results;
      });

      print(_scanResults);

      _dataList.clear();
      for (Face face in results) {
        _dataList.add("Smile Probability: " + face.smilingProbability.toString());
      }
    }
  }

  CustomPaint _buildResults(Size imageSize, dynamic results) {
    CustomPainter painter = FaceDetectorPainter(_imageSize, results);

    return CustomPaint(
      painter: painter,
    );
  }

  Widget _buildImage() {
    return Container(
      constraints: const BoxConstraints.expand(),
      decoration: BoxDecoration(
          image:
              DecorationImage(image: FileImage(_imageFile), fit: BoxFit.fill)),
      child: _imageFile == null || _scanResults == null
          ? const Center(child: CircularProgressIndicator())
          : _buildResults(_imageSize, _scanResults),
    );
  }

  @override
  Widget build(BuildContext context) {
    print("_dataList.length: " + _dataList.length.toString());
    return Scaffold(
      appBar: AppBar(
        title: Text("Face Detector"),
        centerTitle: true,
        actions: <Widget>[
          _dataList.length != 0
              ? IconButton(
                  icon: Icon(Icons.list),
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => DataList(
                                  dataList: _dataList,
                                )));
                  },
                )
              : Container()
        ],
      ),
      body: _buildBody(),
      floatingActionButton: new FabMenu(
        menus: menuDataList,
        maskColor: Colors.black,
      ),
      floatingActionButtonLocation: fabMenuLocation,
    );
  }

  Widget _buildBody() {
    return _imageFile == null
        ? const Center(
            child: Text("No image selected"),
          )
        : _buildImage();
  }
}

// Paints rectangles around all the text in the image.
class FaceDetectorPainter extends CustomPainter {
  FaceDetectorPainter(this.absoluteImageSize, this.faces);

  final Size absoluteImageSize;
  final List<Face> faces;

  @override
  void paint(Canvas canvas, Size size) {
    final double scaleX = size.width / absoluteImageSize.width;
    final double scaleY = size.height / absoluteImageSize.height;

    // Rect scaleRect(Barcode barcode) {
    //   return Rect.fromLTRB(
    //     barcode.boundingBox.left * scaleX,
    //     barcode.boundingBox.top * scaleY,
    //     barcode.boundingBox.right * scaleX,
    //     barcode.boundingBox.bottom * scaleY,
    //   );
    // }

    final Paint paint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.0
      ..color = Colors.red;

    // for (Barcode barcode in barcodeLocations) {
    //   paint.color = Colors.green;
    //   canvas.drawRect(scaleRect(barcode), paint);
    // }
    for (Face face in faces) {
      canvas.drawRect(
        Rect.fromLTRB(
          face.boundingBox.left * scaleX,
          face.boundingBox.top * scaleY,
          face.boundingBox.right * scaleX,
          face.boundingBox.bottom * scaleY,
        ),
        paint,
      );
    }
  }

  @override
  bool shouldRepaint(FaceDetectorPainter oldDelegate) {
    return oldDelegate.absoluteImageSize != absoluteImageSize ||
        oldDelegate.faces != faces;
  }
}
