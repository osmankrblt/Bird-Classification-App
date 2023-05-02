import 'dart:convert';
import 'dart:io';
import 'package:bird_classification_app/widgets/wikiWidget.dart';
import 'package:wikipedia/wikipedia.dart';
import 'package:http/http.dart' as http;
import 'classes/bird_class.dart';
import 'constants.dart';
import "detector.dart";
import 'extensions.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'favourites.dart';
import 'helpers/local_helper.dart';
import 'utils/utils.dart';

class DetectionPage extends StatefulWidget {
  DetectionPage({super.key});

  @override
  State<DetectionPage> createState() => _DetectionPageState();
}

class _DetectionPageState extends State<DetectionPage> {
  XFile? selectedImage = null;

  late Detector detector;

  List<dynamic> birdClassificationInfo = [];

  bool isLoading = false;

  List<dynamic> wikiResults = [];
  var _pref;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    detector = Detector();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      _pref = await SharedPrefStorage().createPref();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: birdClassificationInfo.isNotEmpty &&
              birdClassificationInfo[0] != "None"
          ? Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                IconButton(
                  icon: const Icon(
                    Icons.favorite,
                    color: Colors.red,
                    size: 30,
                  ),
                  onPressed: () {
                    saveDetection();
                  },
                ),
                FloatingActionButton(
                  onPressed: () {
                    getInfo(context);
                  },
                  child: const Icon(
                    Icons.info_outline_rounded,
                  ),
                ),
              ],
            )
          : const SizedBox(),
      appBar: AppBar(
        title: const Text(
          "Bird Classifier",
          style: TextStyle(
            color: Colors.black,
            fontStyle: FontStyle.italic,
          ),
        ),
        backgroundColor: Colors.white,
      ),
      body: Column(
        children: [
          showImage(
            context.dynamicHeight(
              0.5,
            ),
          ),
          showResult(
            context.dynamicHeight(
              0.1,
            ),
          ),
          showButtons(
            context.dynamicHeight(
              0.1,
            ),
          ),
        ],
      ),
    );
  }

  Future<dynamic> getInfo(BuildContext context) async {
    return showModalBottomSheet(
      backgroundColor: Colors.transparent,
      enableDrag: true,
      isDismissible: true,
      useSafeArea: true,
      context: context,
      builder: (context) {
        return Stack(
          children: [
            ListView.builder(
              itemCount: wikiResults.length,
              padding: const EdgeInsets.all(8),
              itemBuilder: (context, index) => WikiWidget(
                bird: wikiResults[index],
              ),
            ),
            Visibility(
              visible: isLoading,
              child: Container(
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height,
                child: const Center(
                  child: CircularProgressIndicator(),
                ),
              ),
            )
          ],
        );
      },
    );
  }

  Container showButtons(double height) {
    return Container(
      height: height,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          ElevatedButton(
            child: const Text(
              "Gallery",
            ),
            onPressed: () async {
              await pickImage(
                ImageSource.gallery,
              );
              if (selectedImage != null) {
                await detectImage();
              }
            },
          ),
          SizedBox(
            width: context.dynamicWidth(
              0.1,
            ),
          ),
          ElevatedButton(
            style: buttonStyle,
            child: const Text(
              "Camera",
            ),
            onPressed: () async {
              await pickImage(
                ImageSource.camera,
              );
              if (selectedImage != null) {
                await detectImage();
              }
            },
          ),
        ],
      ),
    );
  }

  Container showResult(double height) {
    return Container(
      height: height,
      child: isLoading
          ? const CircularProgressIndicator()
          : birdClassificationInfo.isNotEmpty
              ? Text(
                  "Class : ${birdClassificationInfo[0]} , Confidence: %${birdClassificationInfo[1]}",
                )
              : Text(" "),
    );
  }

  Container showImage(double height) {
    return Container(
      height: height,
      child: selectedImage != null
          ? Container(
              margin: const EdgeInsets.all(30.0),
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: FileImage(
                    File(
                      selectedImage!.path,
                    ),
                  ),
                ),
              ),
            )
          : Container(
              margin: const EdgeInsets.all(30.0),
              decoration: BoxDecoration(
                color: Colors.white,
                border: Border.all(
                  color: Colors.black,
                ),
              ),
            ),
    );
  }

  pickImage(source) async {
    final ImagePicker picker = ImagePicker();

    selectedImage = await picker.pickImage(
      source: source,
    );

    setState(() {});
  }

  saveDetection() async {
    BirdModel _bird = BirdModel(
      bird_name: birdClassificationInfo[0],
      bird_confidence: birdClassificationInfo[1].toString(),
      bird_image: File(
        selectedImage!.path,
      ).readAsBytesSync(),
    );

    await _pref.saveBirdsToLocal(_bird);
  }

  detectImage() async {
    isLoading = true;

    birdClassificationInfo = await detector.predict(
      File(
        selectedImage!.path,
      ),
    );
    debugPrint(birdClassificationInfo[0]);
    wikiResults = birdClassificationInfo[0] != "None"
        ? await getWiki(birdClassificationInfo[0])
        : [];

    isLoading = false;

    setState(() {});
  }
}
