import 'package:flutter/material.dart';
import 'package:map_launcher/map_launcher.dart';
import 'package:map_launcher_example/maps_sheet.dart';

class ShowDirections extends StatefulWidget {
  const ShowDirections({Key? key}) : super(key: key);

  @override
  _ShowDirectionsState createState() => _ShowDirectionsState();
}

class _ShowDirectionsState extends State<ShowDirections> {
  double destinationLatitude = 51.085528212979256;
  double destinationLongitude = -114.17912938148896;
  String destinationTitle = '6326 Bowness Rd NW';

  double originLatitude = 51.13594916447705;
  double originLongitude = -113.96474408926466;
  String originTitle = 'My point';

  // List<Coords> waypoints = [];
  List<String> waypoints = [
    '5920 Bowness Rd NW, Calgary, AB, Canada',
    '5903 Bow Crescent NW',
    '6132 Bow Crescent NW',
  ];

  DirectionsMode directionsMode = DirectionsMode.driving;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0),
        child: Column(
          children: <Widget>[
            FormTitle('Destination'),
            TextFormField(
              autocorrect: false,
              autovalidateMode: AutovalidateMode.disabled,
              decoration: InputDecoration(labelText: 'Destination Latitude'),
              initialValue: destinationLatitude.toString(),
              onChanged: (newValue) {
                setState(() {
                  destinationLatitude = double.tryParse(newValue) ?? 0;
                });
              },
            ),
            TextFormField(
              autocorrect: false,
              autovalidateMode: AutovalidateMode.disabled,
              decoration: InputDecoration(labelText: 'Destination Longitude'),
              initialValue: destinationLongitude.toString(),
              onChanged: (newValue) {
                setState(() {
                  destinationLongitude = double.tryParse(newValue) ?? 0;
                });
              },
            ),
            TextFormField(
              autocorrect: false,
              autovalidateMode: AutovalidateMode.disabled,
              decoration: InputDecoration(labelText: 'Destination Title'),
              initialValue: destinationTitle,
              onChanged: (newValue) {
                setState(() {
                  destinationTitle = newValue;
                });
              },
            ),
            FormTitle('Origin'),
            TextFormField(
              autocorrect: false,
              autovalidateMode: AutovalidateMode.disabled,
              decoration: InputDecoration(
                labelText: 'Origin Latitude (uses current location if empty)',
              ),
              initialValue: originLatitude.toString(),
              onChanged: (newValue) {
                setState(() {
                  originLatitude = double.tryParse(newValue) ?? 0;
                });
              },
            ),
            TextFormField(
              autocorrect: false,
              autovalidateMode: AutovalidateMode.disabled,
              decoration: InputDecoration(
                labelText: 'Origin Longitude (uses current location if empty)',
              ),
              initialValue: originLongitude.toString(),
              onChanged: (newValue) {
                setState(() {
                  originLongitude = double.tryParse(newValue) ?? 0;
                });
              },
            ),
            TextFormField(
              autocorrect: false,
              autovalidateMode: AutovalidateMode.disabled,
              decoration: InputDecoration(labelText: 'Origin Title'),
              initialValue: originTitle,
              onChanged: (newValue) {
                setState(() {
                  originTitle = newValue;
                });
              },
            ),
            WaypointsForm(
              waypoints: waypoints,
              onWaypointsUpdated: (updatedWaypoints) {
                setState(() {
                  waypoints = updatedWaypoints;
                });
              },
            ),
            FormTitle('Directions Mode'),
            Container(
              alignment: Alignment.centerLeft,
              child: DropdownButton(
                value: directionsMode,
                onChanged: (newValue) {
                  setState(() {
                    directionsMode = newValue as DirectionsMode;
                  });
                },
                items: DirectionsMode.values.map((directionsMode) {
                  return DropdownMenuItem(
                    value: directionsMode,
                    child: Text(directionsMode.toString()),
                  );
                }).toList(),
              ),
            ),
            SizedBox(height: 20),
            MaterialButton(
              onPressed: () {
                MapsSheet.show(
                  context: context,
                  onMapTap: (map) {
                    map.showDirections(
                      destination: Coords(
                        destinationLatitude,
                        destinationLongitude,
                      ),
                      destinationTitle: destinationTitle,
                      origin: Coords(originLatitude, originLongitude),
                      originTitle: originTitle,
                      waypoints: waypoints,
                      directionsMode: directionsMode,
                    );
                  },
                );
              },
              child: Text('Show Maps'),
            )
          ],
        ),
      ),
    );
  }
}

class FormTitle extends StatelessWidget {
  final String title;
  final Widget? trailing;

  FormTitle(this.title, {this.trailing});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(height: 20),
        Row(
          children: [
            Text(
              title,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: Colors.blue,
              ),
            ),
            Spacer(),
            if (trailing != null) trailing!,
          ],
        ),
      ],
    );
  }
}

class WaypointsForm extends StatelessWidget {
  final List<String> waypoints;
  final void Function(List<String> waypoints) onWaypointsUpdated;

  WaypointsForm({required this.waypoints, required this.onWaypointsUpdated});

  void updateWaypoint(String waypoint, int index) {
    final tempWaypoints = [...waypoints];
    tempWaypoints[index] = waypoint;
    onWaypointsUpdated(tempWaypoints);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ...waypoints.map((waypoint) {
          final waypointIndex = waypoints.indexOf(waypoint);
          return [
            FormTitle(
              'Waypoint #${waypointIndex + 1}',
              trailing: IconButton(
                icon: Icon(Icons.delete, color: Colors.red[300]),
                onPressed: () {
                  onWaypointsUpdated([...waypoints]..removeAt(waypointIndex));
                },
              ),
            ),
            TextFormField(
              autocorrect: false,
              autovalidateMode: AutovalidateMode.disabled,
              decoration: InputDecoration(
                labelText: 'Waypoint #${waypointIndex + 1} latitude',
              ),
              initialValue: waypoint.toString(),
              onChanged: (newValue) {
                updateWaypoint(
                  newValue,
                  waypointIndex,
                );
              },
            ),
            // TextFormField(
            //   autocorrect: false,
            //   autovalidateMode: AutovalidateMode.disabled,
            //   decoration: InputDecoration(
            //     labelText: 'Waypoint #$waypointIndex longitude',
            //   ),
            //   initialValue: waypoint.longitude.toString(),
            //   onChanged: (newValue) {
            //     updateWaypoint(
            //       Coords(waypoint.latitude, double.tryParse(newValue) ?? 0),
            //       waypointIndex,
            //     );
            //   },
            // ),
          ];
        }).expand((element) => element),
        SizedBox(height: 20),
        Row(children: [
          MaterialButton(
            child: Text(
              'Add Waypoint',
              style: TextStyle(
                // color: Colors.blue,
                fontWeight: FontWeight.w600,
              ),
            ),
            onPressed: () {
              onWaypointsUpdated([...waypoints]..add('Empty'));
            },
          ),
        ]),
      ],
    );
  }
}
