import 'dart:convert';
import 'dart:io';
import 'package:wikipedia/wikipedia.dart';
import 'constants.dart';
import 'detection_page.dart';
import "detector.dart";
import 'extensions.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'favourites.dart';

class HomePage extends StatefulWidget {
  HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int selectedIndex = 1;
  static List<Widget> _pages = <Widget>[
    FavouritesPage(),
    DetectionPage(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: BottomNavigationBar(
        onTap: _onItemTapped,
        currentIndex: selectedIndex,
        items: [
          BottomNavigationBarItem(
            label: "Favorites",
            icon: Icon(
              Icons.favorite,
              color: Colors.red,
              size: 27,
            ),
          ),
          BottomNavigationBarItem(
            label: "Classification",
            icon: Icon(
              Icons.remove_red_eye_outlined,
              color: Colors.red,
              size: 27,
            ),
          ),
        ],
      ),
      body: Center(
        child: _pages.elementAt(selectedIndex),
      ),
    );
  }
}
