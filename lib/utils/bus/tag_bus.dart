import 'dart:async';

import 'package:note_app/utils/model/tag.dart';
import 'package:note_app/utils/repository/tag_repo.dart';

class TagBUS {
  final _tagRepository = TagRepository();

  //Stream controller is the 'Admin' that manages
  //the state of our stream of data like adding
  //new data, change the state of the stream
  //and broadcast it to observers/subscribers
  //final _tagController = StreamController<List<Tag>>.broadcast();

  //get tags => _tagController.stream;

  TagBloc() {
    getTags();
  }
  ///Check tag Exist
  ///Required: Tag
  ///case tag exist return true;
  ///case tag not exist return false;
  isTitleTagExist(String title) async {
    return await _tagRepository.isTagExist(title);
  }
  //Get list tag
  //Required: optional {query}
  //case not found return []
  //case found return List<Tag>
  getTags({String query}) async {
    //sink is a way of adding data reactively to the stream
    //by registering a new event
    var res = await _tagRepository.getAllTags(query: query);
    //_tagController.sink.add(res);
    return res;
  }
  //Get Tag from database
  //Required tagId
  //case tag exist return tag
  //case tag not exist return null
  getTagById(String tagId) async {
    var res = await _tagRepository.getTag(tagId);
    return res;
  }
  //Add Tag to database
  //case exist tag won't add and return -1
  //case non-exist tag will add and return tagId
  addTag(Tag tag) async {
    if (!(await isTitleTagExist(tag.title))) {
      await _tagRepository.insertTag(tag);
      //getTags();
      return true;
    }
    else return false;
  }
  //Update Tag
  //Required: Tag
  updateTag(Tag tag) async {
    //if (!isTagExist(tag)) {
      return await _tagRepository.updateTags(tag) > 0;
      //getTags();
      //return true;
    //}
    //return false;
  }

  deleteTagById(String id) async {
    return await _tagRepository.deleteTagById(id) > 0;
    //getTags();
  }

//  dispose() {
//    _tagController.close();
//  }
}
