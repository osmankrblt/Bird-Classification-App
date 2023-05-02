import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';

class BirdModel {
  String bird_name;
  String bird_confidence;
  Uint8List bird_image;
  String time;

  BirdModel(
      {required this.bird_name,
      required this.bird_confidence,
      required this.bird_image,
      this.time = ""});

  static imagetobase64(Uint8List image) {
    String _base64String = base64.encode(image);

    return _base64String;
  }

  static base64toimage(String image_base64) {
    Uint8List _base64String = base64.decode(image_base64);

    return _base64String;
  }

  static Map<String, dynamic> toJson(BirdModel bird) {
    return {
      "bird_name": bird.bird_name,
      "bird_confidence": bird.bird_confidence,
      "bird_image": imagetobase64(bird.bird_image),
      "time": DateFormat('yyyy-MM-dd – kk:mm').format(DateTime.now()),
    };
  }

  factory BirdModel.fromMap(Map<String, dynamic> map) {
    return BirdModel(
      bird_name: map["bird_name"] ?? "",
      bird_confidence: map["bird_confidence"] ?? "",
      bird_image: base64toimage(map["bird_image"]) ?? "",
      time: map["time"] ?? "",
    );
  }
}
