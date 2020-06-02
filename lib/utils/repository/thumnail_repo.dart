import 'package:note_app/utils/dao/thumbnail_dao.dart';
import 'package:note_app/utils/model/thumbnailNote.dart';

class ThumbnailRepository {
  final thumbnailDao = ThumbnailNoteDAO();

  Future getAllThumbnails({String query}) => thumbnailDao.getThumbnails(query: query);

  Future getThumbnail(int id) => thumbnailDao.getThumbnailByID(id);

  Future insertThumbnail(ThumbnailNote thumbnail) => thumbnailDao.createThumbnail(thumbnail);
  Future updateThumbnail(ThumbnailNote thumbnail) => thumbnailDao.updateThumbnail(thumbnail);

  Future deleteThumbnailById(int id) => thumbnailDao.deleteThumbnail(id);

  //We are not going to use this in the demo
  Future deleteAllThumbnails() => thumbnailDao.deleteAllThumbnails();
}