import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:injectable/injectable.dart';

import '../model/things_model.dart';

abstract class CreateThingApiI {
  Future<void> addThing(ThingsModel model);

  Future<void> updateThing(ThingsModel model);

  Future<ThingsModel?> fetchThing(String id);

  Future<void> updateFavorite(String id, bool isFavorite);
}

@LazySingleton(as: CreateThingApiI)
class CreateThingApi implements CreateThingApiI {
  final _firestore = FirebaseFirestore.instance;
  final _auth = FirebaseAuth.instance;

  CollectionReference get _collection => _firestore.collection('item');

  @override
  Future<void> addThing(ThingsModel model) async {
    final data = model.toJson()
    ..remove('id');
    await _collection.add(data);
  }

  @override
  Future<void> updateThing(ThingsModel model) async {
    await _collection.doc(model.id).update(model.toJson());
  }

  @override
  Future<ThingsModel?> fetchThing(String id) async {
    final doc = await _collection.doc(id).get();
    final data = doc.data();
    if (data == null) return null;
    return ThingsModel.fromJson({...data as Map<String, dynamic>, 'id': id});
  }

  @override
  Future<void> updateFavorite(String id, bool isFavorite) async {
    await _collection.doc(id).update({'favorites': isFavorite});
  }
}
