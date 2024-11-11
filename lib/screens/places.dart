import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:favorite_places/screens/add_place.dart';
import 'package:favorite_places/widgets/places_list.dart';
import 'package:favorite_places/providers/user_places.dart';

// class PlacesScreen extends ConsumerStatefulWidget {
//   const PlacesScreen({super.key});

//   @override
//   ConsumerState<PlacesScreen> createState() {
//     return _PlacesScreenState();
//   }
// }

// class _PlacesScreenState extends ConsumerState<PlacesScreen> {
//   late Future<void> _futurePlace;
//   @override
//   void initState() {

//     super.initState();
//      _futurePlace = ref.read(userPlacesProvider.notifier).loadPlaces();
//   }

//   @override
//   Widget build(BuildContext context) {
//     final userPlaces = ref.watch(userPlacesProvider);

//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Your Places'),
//         actions: [
//           IconButton(
//             icon: const Icon(Icons.add),
//             onPressed: () {
//               Navigator.of(context).push(
//                 MaterialPageRoute(
//                   builder: (ctx) => const AddPlaceScreen(),
//                 ),
//               );
//             },
//           ),
//         ],
//       ),
//       body:FutureBuilder(
//         future: _futurePlace,
//         builder: (context, snapshot) => snapshot.connectionState == ConnectionState.waiting ? const Center(child: CircularProgressIndicator(),) : PlacesList(
//         places: userPlaces,
//       ), ) ,
//     );
//   }
// }
class PlacesScreen extends ConsumerStatefulWidget {
  const PlacesScreen({super.key});

  @override
  ConsumerState<PlacesScreen> createState() {
    return _PlacesScreenState();
  }
}

class _PlacesScreenState extends ConsumerState<PlacesScreen> {
  late Future<void> placesFuture;
  @override
  void initState() {
    placesFuture = ref.read(userPlacesProvider.notifier).loadPlaces();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final userPlaces = ref.watch(userPlacesProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Your Places'),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (ctx) => const AddPlaceScreen(),
                ),
              );
            },
          ),
        ],
      ),
      body: Padding(
          padding: const EdgeInsets.all(8.0),
          child:FutureBuilder(
            future: placesFuture,
            builder: (context, snapshot) =>snapshot.connectionState == ConnectionState.waiting ? Center(
              child: CircularProgressIndicator(),
            ): PlacesList(
            places: userPlaces,
          ) ,),
          ),
    );
  }
}

//  FutureBuilder(
//           future: _placesFuture,
//           builder: (context, snapshot) =>
//               snapshot.connectionState == ConnectionState.waiting
//                   ? const Center(child: CircularProgressIndicator())
//                   : PlacesList(
//                       places: userPlaces,
//                     ),
//         ),