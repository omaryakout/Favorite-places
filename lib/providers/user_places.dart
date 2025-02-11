import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'dart:io';
import 'package:favorite_places/models/place.dart';
import 'package:path_provider/path_provider.dart' as syspath;
import 'package:path/path.dart' as path;
import 'package:sqflite/sqflite.dart' as sql;
import 'package:sqflite/sqlite_api.dart';
import 'package:flutter/material.dart';

Future<Database> _getDataBase() async {
  final dbPath = await sql.getDatabasesPath();
  final db = await sql.openDatabase(
    path.join(dbPath, 'places.db'),
    onCreate: (db, version) => db.execute(
        'CREATE TABLE user_places (id INTEGER PRIMARY KEY, title TEXT, lat REAL, image TEXT, adress TEXT, lng REAL)'),
    version: 3,
  );
  return db;
}

class UserPlacesNotifier extends StateNotifier<List<Place>> {
  UserPlacesNotifier() : super(const []);

  Future<void> loadPlaces() async {
    final db = await _getDataBase();
    final data = await db.query('user_places');
    final places = data
        .map(
          (row) => Place(
            title: row['title'] as String,
            image: File(row['image'] as String),
            placeLocation: PlaceLocation(
                latitude: row['lat'] as double,
                longitude: row['lng'] as double,
                address: row['address'] as String),
          ),
        )
        .toList();
    state = places;
  }

  void addPlace(String title, File image, PlaceLocation placeLocation) async {
    final appDir = await syspath.getApplicationDocumentsDirectory();
    final fileName = path.basename(image.path);
    final copiedImage = await image.copy('${appDir.path}/$fileName');
    print(fileName);

    final newPlace =
        Place(title: title, image: copiedImage, placeLocation: placeLocation);

    final db = await _getDataBase();
    db.insert(
      'user_places',
      {
        'id': newPlace.id,
        'title': newPlace.title,
        'lat': newPlace.placeLocation.latitude,
        'image': newPlace.image.path,
        'lng': newPlace.placeLocation.longitude,
        'address': newPlace.placeLocation.address,
      },
    );

    state = [newPlace, ...state];
  }
}

final userPlacesProvider =
    StateNotifierProvider<UserPlacesNotifier, List<Place>>(
        (ref) => UserPlacesNotifier());



























// import 'dart:io';

// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:path_provider/path_provider.dart' as syspaths;
// import 'package:path/path.dart' as path;
// import 'package:sqflite/sqflite.dart' as sql;
// import 'package:sqflite/sqlite_api.dart';

// import 'package:favorite_places/models/place.dart';

// Future<Database> _getDatabase() async {
//   final dbPath = await sql.getDatabasesPath();
//   final db = await sql.openDatabase(
//     path.join(dbPath, 'places.db'),
//     onCreate: (db, version) {
//       return db.execute(
//           'CREATE TABLE user_places(id TEXT PRIMARY KEY, title TEXT, image TEXT, lat REAL, lng REAL, address TEXT)');
//     },
//     version: 1,
//   );
//   return db;
// }

// class UserPlacesNotifier extends StateNotifier<List<Place>> {
//   UserPlacesNotifier() : super(const []);

//   Future<void> loadPlaces() async {
//     final db = await _getDatabase();
//     final data = await db.query('user_places');
//     final places = data
//         .map(
//           (row) => Place(
//             id: row['id'] as String,
//             title: row['title'] as String,
//             image: File(row['image'] as String),
//             placeLocation: PlaceLocation(
//               latitude: row['lat'] as double,
//               longitude: row['lng'] as double,
//               address: row['address'] as String,
//             ),
//           ),
//         )
//         .toList();

//     state = places;
//   }

//   void addPlace(String title, File image, PlaceLocation location) async {
//     final appDir = await syspaths.getApplicationDocumentsDirectory();
//     final filename = path.basename(image.path);
//     final copiedImage = await image.copy('${appDir.path}/$filename');

//     final newPlace =
//         Place(title: title, image: copiedImage, placeLocation: location);

//     final db = await _getDatabase();
//     db.insert('user_places', {
//       'id': newPlace.id,
//       'title': newPlace.title,
//       'image': newPlace.image.path,
//       'lat': newPlace.placeLocation.latitude,
//       'lng': newPlace.placeLocation.longitude,
//       'address': newPlace.placeLocation.address,
//     });

//     state = [newPlace, ...state];
//   }
// }

// final userPlacesProvider =
//     StateNotifierProvider<UserPlacesNotifier, List<Place>>(
//   (ref) => UserPlacesNotifier(),
// );