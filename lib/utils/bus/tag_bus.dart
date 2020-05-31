import 'dart:async';

import 'package:note_app/utils/repository/tag_repo.dart';
import 'package:note_app/utils/model/tag.dart';

class TagBUS {
  final _tagRepository = TagRepository();

  //Stream controller is the 'Admin' that manages
  //the state of our stream of data like adding
  //new data, change the state of the stream
  //and broadcast it to observers/subscribers
  final _tagController = StreamController<List<Tag>>.broadcast();

  get tags => _tagController.stream;

  TagBloc() {
    getTags();
  }

  getTags({String query}) async {
    //sink is a way of adding data reactively to the stream
    //by registering a new event
    _tagController.sink.add(await _tagRepository.getAllTags(query: query));
  }

  addTag(Tag tag) async {
    await _tagRepository.insertTags(tag);
    getTags();
  }

  updateTag(Tag tag) async {
    await _tagRepository.updateTags(tag);
    getTags();
  }

  deleteTagById(String id) async {
    _tagRepository.deleteTagById(id);
    getTags();
  }

  dispose() {
    _tagController.close();
  }
