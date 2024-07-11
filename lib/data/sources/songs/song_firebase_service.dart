import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dartz/dartz.dart';
import 'package:tune_box/data/models/song/song_model.dart';
import 'package:tune_box/domain/entities/song/song_entity.dart';

abstract class SongFirebaseService {
  Future<Either> getNewsSongs();
}

class SongFirebaseServiceImpl extends SongFirebaseService {
  @override
  Future<Either> getNewsSongs() async {
    try {
      List<SongEntity> songs = [];
      var data = await FirebaseFirestore.instance
          .collection('Songs')
          .orderBy('release', descending: true)
          .limit(3)
          .get();

      for (var element in data.docs) {
        var song = SongModel.fromMap(element.data());
        songs.add(
          song.toEntity(),
        );
      }
      return Right(songs);
    } catch (e) {
      return const Left("An error occured.");
    }
  }
}