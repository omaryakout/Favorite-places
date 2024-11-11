import 'package:flutter/material.dart';
import 'package:location/location.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:favorite_places/models/place.dart';
import 'package:favorite_places/screens/map_screen.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class LocationInput extends StatefulWidget {
  LocationInput({super.key, required this.onPickLocation});

  void Function(PlaceLocation placeLocation) onPickLocation;

  @override
  State<LocationInput> createState() => _LocationInputState();
}

class _LocationInputState extends State<LocationInput> {
  var locationLoading = false;
  PlaceLocation? _pickedLocation;

  Future<void> savePlace(double lat, double long) async {
    final url = Uri.parse(
        'https://api.tomtom.com/search/2/reverseGeocode/$lat,$long.json?key=Fk8Btn4WlUe1gEiZQSs73VSZfj64DjxR&returnSpeedLimit=false&heading=90&radius=10000');

    final response = await http.get(url);
    final resData = json.decode(response.body);
    final address = resData['addresses'][0]['address']["localName"];
    setState(() {
      _pickedLocation = PlaceLocation(
        latitude: lat,
        longitude: long,
        address: address,
      );
      locationLoading = false;
    });
    print(address);

    widget.onPickLocation(_pickedLocation!);
  }

  String get locationImage  {
    if (_pickedLocation == null) {
      return '';
    }
    final lat = _pickedLocation!.latitude;
    final lng =  _pickedLocation!.longitude;
    return 'https://api.tomtom.com/map/1/staticimage?key=Fk8Btn4WlUe1gEiZQSs73VSZfj64DjxR&zoom=16&center=$lng,$lat&format=jpg&layer=basic&style=main&width=1305&height=748&view=Unified&language=en-GB';
  }

  void chooseLocation() async {
    Location location = new Location();

    bool serviceEnabled;
    PermissionStatus permissionGranted;
    LocationData locationData;

    serviceEnabled = await location.serviceEnabled();
    if (!serviceEnabled) {
      serviceEnabled = await location.requestService();
      if (!serviceEnabled) {
        return;
      }
    }

    permissionGranted = await location.hasPermission();
    if (permissionGranted == PermissionStatus.denied) {
      permissionGranted = await location.requestPermission();
      if (permissionGranted != PermissionStatus.granted) {
        return;
      }
    }
    setState(() {
      locationLoading = true;
    });
    locationData = await location.getLocation();
    final lat = locationData.latitude;
    final long = locationData.longitude;

    if (lat == null || long == null) {
      return;
    }

    savePlace(lat, long);
  }

  void pickPlaceFromMap() async {
    final pickedLocation =
        await Navigator.of(context).push<LatLng>(MaterialPageRoute(
      builder: (context) => MapScreen(),
    ));

    if (pickedLocation == null) {
      return;
    }

    savePlace(
      pickedLocation.latitude,pickedLocation.longitude
    );
  }

  @override
  Widget build(BuildContext context) {
    Widget previewContent = Text(
      'No location chosen',
      textAlign: TextAlign.center,
      style: Theme.of(context).textTheme.bodyLarge!.copyWith(
            color: Theme.of(context).colorScheme.onBackground,
          ),
    );

    if (_pickedLocation != null) {
      previewContent = Image.network(
        locationImage,
        fit: BoxFit.cover,
        width: double.infinity,
        height: double.infinity,
      );
    }

    if (locationLoading) {
      previewContent = const CircularProgressIndicator();
    }

    return Column(
      children: [
        Container(
          height: 180,
          width: double.infinity,
          child: previewContent,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            border: Border.all(
              width: 1,
              color: Theme.of(context).colorScheme.primary.withOpacity(0.2),
            ),
          ),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            TextButton.icon(
              onPressed: chooseLocation,
              icon: Icon(Icons.pin_drop),
              label: Text('choose your location'),
            ),
            TextButton.icon(
              onPressed: pickPlaceFromMap,
              icon: Icon(Icons.map),
              label: Text('select on map'),
            ),
          ],
        )
      ],
    );
  }
}
