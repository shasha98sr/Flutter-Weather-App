import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:weatherapp/constants.dart';
import 'package:weatherapp/model/weather_model.dart';
import 'package:weatherapp/services/database_helper.dart';
import 'package:weatherapp/services/weather_api.dart';
import 'package:date_format/date_format.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({Key? key}) : super(key: key);

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  late Future<WeatherModel> selectedLocationWeather;
  List _savedData = [];
  String location = "Dubai";
  late TextEditingController controller;

  @override
  void initState() {
    super.initState();
    controller = TextEditingController();
    selectedLocationWeather = WeatherApi.getWeather(location);
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add),
        onPressed: () async {
          final input = await openDialog();
          if (input == null || input.isEmpty) return;
          _savedData = await DatabaseHelper.instance.queryAllRows();

          setState(() {
            selectedLocationWeather = WeatherApi.getWeather(input);
          });
        },
      ),
      appBar: AppBar(
        toolbarHeight: 0,
        backgroundColor: primaryColor,
        title: const Text('Weatherly'),
      ),
      body: SafeArea(
        child: FutureBuilder<WeatherModel>(
          future: selectedLocationWeather,
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return const Center(child: CircularProgressIndicator());
            }
            WeatherModel locationWeather = snapshot.data!;
            addToDatabase(locationWeather);
            return SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Container(
                    height: 130,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: defaultPadding, vertical: defaultPadding),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            locationWeather.name,
                            style: const TextStyle(
                                fontSize: 40, color: Colors.white),
                          ),
                          Text(
                            formatDate(
                                DateTime.fromMillisecondsSinceEpoch(
                                    locationWeather.dt * 1000),
                                [DD, ', ', dd, '. ', MM]),
                            style: const TextStyle(
                                fontSize: 20, color: Colors.white),
                          ),
                        ],
                      ),
                    ),
                    color: primaryColor,
                  ),
                  Container(
                    height: 200,
                    color: secondaryColor,
                    child: Padding(
                      padding: const EdgeInsets.all(defaultPadding),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "${locationWeather.main.temp}°",
                                style: const TextStyle(
                                    fontSize: 60,
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold),
                              ),
                              Text(
                                locationWeather.weather[0].main.toString(),
                                style: const TextStyle(
                                    fontSize: 30, color: Colors.white),
                              ),
                            ],
                          ),
                          SizedBox(
                            height: 120,
                            width: 120,
                            // color: Colors.black,
                            child: Image.network(
                              'http://openweathermap.org/img/w/${locationWeather.weather[0].icon}.png',
                              color: Colors.white,
                              fit: BoxFit.contain,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Container(
                    height: 50,
                    color: primaryColor,
                    child: Row(
                      children: [
                        const SizedBox(width: defaultPadding + 20),
                        const FaIcon(FontAwesomeIcons.temperatureHalf,
                            color: Colors.white),
                        const SizedBox(width: 10),
                        Text(
                          "${locationWeather.main.tempMax}° / ${locationWeather.main.tempMin}°",
                          style: const TextStyle(color: Colors.white),
                        ),
                        const SizedBox(width: 30),
                        const FaIcon(FontAwesomeIcons.cloudRain,
                            color: Colors.white),
                        const SizedBox(width: 10),
                        Text(
                          "${locationWeather.clouds.all}%",
                          style: const TextStyle(color: Colors.white),
                        ),
                      ],
                    ),
                  ),
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Container(
                      color: backgroundColor,
                      child: Padding(
                        padding: const EdgeInsets.all(defaultPadding),
                        child: Row(
                          children: [
                            for (int i = _savedData.length - 1; i > 0; i--)
                              Padding(
                                padding: const EdgeInsets.all(16),
                                child: Column(
                                  children: [
                                    Text(
                                        _savedData[i]
                                            [DatabaseHelper.columnCityName],
                                        style: const TextStyle(
                                            fontSize: 30, color: lightGrey)),
                                    const SizedBox(height: 15),
                                    const FaIcon(
                                      FontAwesomeIcons.cloud,
                                      size: 90,
                                      color: lightGrey,
                                    ),
                                    const SizedBox(height: 15),
                                    Text(
                                      "${_savedData[i][DatabaseHelper.columnTempMax]}° / ${_savedData[i][DatabaseHelper.columnTempMin]}°",
                                      style: const TextStyle(
                                          fontSize: 15,
                                          color: lightGrey,
                                          fontWeight: FontWeight.w300),
                                    ),
                                  ],
                                ),
                              ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  Future<String?> openDialog() => showDialog<String>(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text("Enter location"),
          content: TextField(
            autofocus: true,
            controller: controller,
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(controller.text);
              },
              child: const Text('SUBMIT'),
            ),
          ],
        ),
      );

  void addToDatabase(WeatherModel locationWeather) async {
    await DatabaseHelper.instance.insert({
      DatabaseHelper.columnCityName: locationWeather.name,
      DatabaseHelper.columnTemp: locationWeather.main.temp,
      DatabaseHelper.columnTempMin: locationWeather.main.tempMin,
      DatabaseHelper.columnTempMax: locationWeather.main.tempMax,
      DatabaseHelper.columnHumidity: locationWeather.main.humidity,
      DatabaseHelper.columnRain: locationWeather.clouds.all
    });
  }
}
