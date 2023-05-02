import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'classes/bird_class.dart';
import 'helpers/local_helper.dart';

class FavouritesPage extends StatefulWidget {
  const FavouritesPage({super.key});

  @override
  State<FavouritesPage> createState() => _FavouritesPageState();
}

class _FavouritesPageState extends State<FavouritesPage> {
  late SharedPrefStorage _pref;
  List<dynamic> _detections = [];
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      _pref = await SharedPrefStorage().createPref();
      _detections = _pref.getBirdsFromLocal();

      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Fovourite Classifications",
          style: TextStyle(
            color: Colors.black,
            fontStyle: FontStyle.italic,
          ),
        ),
        actions: [
          IconButton(
            onPressed: () async {
              _detections = [];
              await _pref.clear();
              setState(() {});
            },
            icon: Icon(
              Icons.delete_outlined,
              color: Colors.red,
              size: 30,
            ),
          ),
        ],
        backgroundColor: Colors.white,
      ),
      body: SafeArea(
        child: ListView.builder(
          itemCount: _detections.length,
          itemBuilder: (context, index) {
            BirdModel _bird = BirdModel.fromMap(
              jsonDecode(
                _detections[index],
              ),
            );
            return Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                height: 150,
                decoration: BoxDecoration(
                  border: Border.all(
                    width: 3,
                  ),
                  borderRadius: BorderRadius.circular(
                    30,
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Container(
                      height: 150,
                      padding: const EdgeInsets.all(
                        5.0,
                      ),
                      child: Image.memory(
                        _bird.bird_image,
                      ),
                    ),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Text(
                          _bird.bird_name,
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          _bird.bird_confidence,
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          _bird.time,
                        ),
                      ],
                    )
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
