import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:weatherapp/constants.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({Key? key}) : super(key: key);

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Container(
              height: 130,
              child: Padding(
                padding: const EdgeInsets.symmetric(
                    horizontal: defaultPadding + 20, vertical: defaultPadding),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: const [
                    Text(
                      "Los Angeles",
                      style: TextStyle(fontSize: 40, color: Colors.white),
                    ),
                    Text("Thursday, 12. August",
                        style: TextStyle(fontSize: 20, color: Colors.white)),
                  ],
                ),
              ),
              color: primaryColor,
            ),
            Container(
              height: 200,
              color: secondaryColor,
              child: const Padding(
                  padding: EdgeInsets.all(defaultPadding),
                  child: ListTile(
                    title: Text(
                      "56",
                      style: TextStyle(
                          fontSize: 60,
                          color: Colors.white,
                          fontWeight: FontWeight.bold),
                    ),
                    subtitle: Text(
                      "Rainy",
                      style: TextStyle(fontSize: 30, color: Colors.white),
                    ),
                    trailing: FaIcon(
                      FontAwesomeIcons.cloudRain,
                      size: 150,
                      color: Colors.white,
                    ),
                  )),
            ),
            Container(
              height: 50,
              color: primaryColor,
            ),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Container(
                color: backgroundColor,
                child: Padding(
                  padding: EdgeInsets.all(defaultPadding),
                  child: Row(
                    children: [
                      for (int i = 0; i < 3; i++)
                        Padding(
                          padding: const EdgeInsets.all(16),
                          child: Container(
                            child: Column(
                              children: [
                                Text("Delhi",
                                    style: TextStyle(
                                        fontSize: 30, color: lightGrey)),
                                SizedBox(height: 15),
                                FaIcon(
                                  FontAwesomeIcons.cloud,
                                  size: 90,
                                  color: lightGrey,
                                ),
                                SizedBox(height: 15),
                                Text(
                                  "75 / 55",
                                  style: TextStyle(
                                      fontSize: 30,
                                      color: lightGrey,
                                      fontWeight: FontWeight.w300),
                                ),
                              ],
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
