
import 'dart:async';

import 'package:note_app/utils/model/thumbnailNote.dart';
import 'package:note_app/utils/repository/thumnail_repo.dart';

class ThumbnailBUS {
  final _thumbnailRepository = ThumbnailRepository();

  //Stream controller is the 'Admin' that manages
  //the state of our stream of data like adding
  //new data, change the state of the stream
  //and broadcast it to observers/subscribers
  //final _thumbnailController = StreamController<List<ThumbnailNote>>.broadcast();

  //get thumbnails => _thumbnailController.stream;

  ThumbnailBloc() {
    getThumbnails();
  }

  getThumbnailsByKeyWord() async{
    return await getThumbnails();
  }
  getThumbnails({String query}) async {
    //sink is a way of adding data reactively to the stream
    //by registering a new event
    var result = await _thumbnailRepository.getAllThumbnails(query: query);
    //_thumbnailController.sink.add(result);
    return result;
  }

  addThumbnail(ThumbnailNote thumbnail) async {
    return await _thumbnailRepository.insertThumbnail(thumbnail) > 0;
    //getThumbnails();
  }

  updateThumbnail(ThumbnailNote thumbnail) async {
    return await _thumbnailRepository.updateThumbnail(thumbnail) > 0;
    //getThumbnails();
  }

  deleteThumbnailById(String id) async {
   return await _thumbnailRepository.deleteThumbnailById(id) > 0;
    //getThumbnails();
  }

//  dispose() {
//    _thumbnailController.close();
//  }
}