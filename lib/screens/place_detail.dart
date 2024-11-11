import 'package:flutter/material.dart';

import 'package:favorite_places/models/place.dart';
import 'map_screen.dart';

class PlaceDetailScreen extends StatelessWidget {
  const PlaceDetailScreen({super.key, required this.place});

  final Place place;
  String get locationImage {
    final lat = place.placeLocation.latitude;
    final lng = place.placeLocation.longitude;
    return 'https://api.tomtom.com/map/1/staticimage?key=Fk8Btn4WlUe1gEiZQSs73VSZfj64DjxR&zoom=10&center=$lng,$lat&format=jpg&layer=basic&style=main&width=1305&height=748&view=Unified&language=en-GB';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(place.title),
        ),
        body: Stack(
          children: [
            Image.file(
              place.image,
              fit: BoxFit.cover,
              width: double.infinity,
              height: double.infinity,
            ),
            Positioned(
                bottom: 0,
                left: 0,
                right: 0,
                child: Column(
                  children: [
                    GestureDetector(
                      onTap: () {
                        Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) => MapScreen(location: place.placeLocation,isSelecting:false ),
                        ));
                      },
                      child: CircleAvatar(
                        radius: 90,
                        foregroundImage: NetworkImage(locationImage),
                      ),
                    ),
                    Container(
                      alignment: Alignment.center,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 24,
                        vertical: 16,
                      ),
                      decoration: const BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            Colors.transparent,
                            Colors.black54,
                          ],
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                        ),
                      ),
                      child: Text(
                        place.placeLocation.address,
                        textAlign: TextAlign.center,
                        style: Theme.of(context).textTheme.titleLarge!.copyWith(
                              color: Theme.of(context).colorScheme.onBackground,
                            ),
                      ),
                    ),
                  ],
                ))
          ],
        ));
  }
}
