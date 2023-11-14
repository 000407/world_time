import 'package:flutter/material.dart';
import 'package:world_time/time_data.dart';

class LocationTimeItem extends StatelessWidget {
  final TimeData timeData;

  const LocationTimeItem({super.key, required this.timeData});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(14.0),
      child: Row(
        children: [
          Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              SizedBox(
                width: 190,
                height: 40,
                child: Text(timeData.timezone),
              ),
              SizedBox(
                width: 190,
                height: 50,
                child:
                    Text(timeData.city, style: const TextStyle(fontSize: 32)),
              )
            ],
          ),
          SizedBox(
              width: 190,
              height: 90,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(timeData.time,
                      style: const TextStyle(
                        fontSize: 60,
                      )),
                ],
              )),
        ],
      ),
    );
  }
}
