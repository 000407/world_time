import 'dart:developer';

import 'package:day/day.dart';
import 'package:intl/intl.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:world_time/location_time_item.dart';
import 'package:world_time/time_data.dart';
import 'package:world_time/world_time_api.dart';

void main() {
  runApp(const WorldTimeApp());
}

class WorldTimeApp extends StatelessWidget {
  const WorldTimeApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // TRY THIS: Try running your application with "flutter run". You'll see
        // the application has a blue toolbar. Then, without quitting the app,
        // try changing the seedColor in the colorScheme below to Colors.green
        // and then invoke "hot reload" (save your changes or press the "hot
        // reload" button in a Flutter-supported IDE, or press "r" if you used
        // the command line to start the app).
        //
        // Notice that the counter didn't reset back to zero; the application
        // state is not lost during the reload. To reset the state, use hot
        // restart instead.
        //
        // This works for code too, not just values: Most code changes can be
        // tested with just a hot reload.
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.red, brightness: Brightness.dark),
        useMaterial3: true,
      ),
      home: const WorldTimeHome(title: 'World Time'),
    );
  }
}

class WorldTimeHome extends StatefulWidget {
  const WorldTimeHome({super.key, required this.title});

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  State<WorldTimeHome> createState() => _WorldTimeHomeState();
}

class _WorldTimeHomeState extends State<WorldTimeHome> {
  // TextEditingController gives you access to the TextField to which it is bound
  final TextEditingController _continentInputController = TextEditingController();
  final TextEditingController _cityInputController = TextEditingController();

  // Instantiate our API client (further read about "dependency injection")
  final WorldTimeApi _worldTimeApi = WorldTimeApi(Dio());

  bool loading = false;
  List<TimeData> locations = [];

  Future<void> _getTimeAtZone(String continent, String city) async {
    /*var url = Uri.https('worldtimeapi.org', '/api/timezone/$continent/$city');

    var response = await http.get(url);

    log('${url.toString()}');
    log('${response.statusCode}');

    if (response.statusCode >= 200 && response.statusCode < 300) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('yay!'),
      ));
    } else {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Something went wrong! (${response.statusCode})'),
      ));
    }*/

    /*
    * Compare the difference with the commented code above, where we are focusing
    * only on implementing our logic. All of HTTP request building and response parsing
    * are done by the retrofit.
    */
    _worldTimeApi.getTimeAtLocation(continent, city).then((value) {
      // replace the timezone offset (+09:00) from the timestamp;
      // otherwise it will be parsed as UTC time
      final timestamp = value.timestamp.replaceFirst(value.timeOffset, '');

      // Create time string using formatting
      final time = Day.fromString(timestamp).format("HH:mm");
      final timezone = value.timeOffset;

      /*
      This will result in state changes where ONLY the affected widgets are
      forced to be re-rendered on the UI.
       */
      setState(() {
        locations.add(TimeData(timezone: timezone, time: time, city: city));
      });
    }).onError((error, stackTrace) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text('Something went wrong!'),
      ));
    });
  }

  void _addNewTimeAtLocation() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog (
          title: const Text('Choose a Timezone'),
          shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(0))
          ),
          content: Row (
            children: [
              SizedBox(
                width: 90,
                height: 40,
                child: TextField (
                  controller: _continentInputController,
                  decoration: const InputDecoration(hintText: "e.g. Asia"),
                ),
              ),
              const Spacer(),
              SizedBox(
                width: 120,
                height: 40,
                child: TextField (
                  controller: _cityInputController,
                  decoration: const InputDecoration(hintText: "e.g. Tokyo"),
                ),
              )
            ],
          ),
          actions: [
            TextButton (
              onPressed: () {
                Navigator.pop(context);
                _continentInputController.clear();
                _cityInputController.clear();
              },
              child: const Text('CANCEL'),
            ),
            TextButton (
              onPressed: () {
                _getTimeAtZone( _continentInputController.text, _cityInputController.text);

                Navigator.pop(context);

                _continentInputController.clear();
                _cityInputController.clear();
              },
              child: const Text('OK'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return Scaffold(
      appBar: AppBar(
        // TRY THIS: Try changing the color here to a specific color (to
        // Colors.amber, perhaps?) and trigger a hot reload to see the AppBar
        // change color while the other colors stay the same.
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
          actions: [
            TextButton(
                onPressed: _addNewTimeAtLocation,
                child: const Text("ADD")
            ),
          ],
      ),
      body: Center(
        child: ListView.builder(
          itemCount: locations.length,
          itemBuilder: (BuildContext ctxt, int i) {
            return LocationTimeItem(timeData: locations[i]);
          },
        ),
      ),
    );
  }
}
