import 'package:note_app/utils/dao/tag_dao.dart';
import 'package:note_app/utils/model/tag.dart';

class TagRepository {
  final TagDao = TagDAO();

  Future getAllTags({String query}) => TagDao.getTags(query: query);

  Future getTag(String id) => TagDao.getTagByID(id);

  Future insertTags(Tag note) => TagDao.createTag(note);
  Future updateTags(Tag note) => TagDao.updateTag(note);

  Future deleteTagById(String id) => TagDao.deleteTag(id);

  //We are not going to use this in the demo
  Future deleteAllTags() => TagDao.deleteAllTags();
}