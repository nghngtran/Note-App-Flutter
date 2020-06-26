import 'dart:async';

import 'package:note_app/utils/model/tag.dart';
import 'package:note_app/utils/repository/tag_repo.dart';

class TagBUS {
  final _tagRepository = TagRepository();

  ///Check tag Exist
  ///Required: Tag
  ///case tag exist return true;
  ///case tag not exist return false;
  isTitleTagExist(String title) async {
    final stopwatch = Stopwatch()..start();
    var res = await _tagRepository.isTagExist(title);
    print('[Time] Check Tag ${title} exists executed in ${stopwatch.elapsed}');
    return res;
  }
  //Get list tag
  //Required: optional {query}
  //case not found return []
  //case found return List<Tag>
  getTags({String query}) async {
    final stopwatch = Stopwatch()..start();
    var res = await _tagRepository.getAllTags(query: query);
    print('[Time] Query All Tag executed in ${stopwatch.elapsed}');
    return res;
  }
  //Get Tag from database
  //Required tagId
  //case tag exist return tag
  //case tag not exist return null
  getTagById(String tagId) async {
    final stopwatch = Stopwatch()..start();
    var res = await _tagRepository.getTag(tagId);
    print('[Time] Query Tag by ID ${tagId} executed in ${stopwatch.elapsed}');
    return res;
  }
  //Add Tag to database
  //case exist tag won't add and return -1
  //case non-exist tag will add and return tagId
  addTag(Tag tag) async {
    final stopwatch = Stopwatch()..start();
    if (!(await isTitleTagExist(tag.title))) {
      await _tagRepository.insertTag(tag);
      print('[Time] Add new Tag ${tag.title} executed in ${stopwatch.elapsed}');
      return true;
    }
    else {
      print('[Time] Add new Tag ${tag.title} executed in ${stopwatch.elapsed}');
      return false;
    }
  }
  //Update Tag
  //Required: Tag
  updateTag(Tag tag) async {
    final stopwatch = Stopwatch()..start();
    var res =  await _tagRepository.updateTags(tag);
    print('[Time] Update Tag ${tag.title} executed in ${stopwatch.elapsed}');
    return res >0;
  }

  deleteTagById(String tagId) async {
    final stopwatch = Stopwatch()..start();
    var res =  await _tagRepository.deleteTagById(tagId);
    print('[Time] Delete Tag ${tagId} executed in ${stopwatch.elapsed}');
    return res>0;
  }
}
