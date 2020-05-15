import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:note_app/presentations/UI/custom_widget/custom_list_notes.dart';

import 'package:note_app/presentations/UI/custom_widget/custom_note_card.dart';
import 'package:note_app/presentations/UI/custom_widget/custom_type_tag.dart';
import 'package:note_app/presentations/UI/page/create_note.dart';
import 'package:note_app/presentations/UI/page/image_pick.dart';
import 'package:note_app/utils/database/model/noteItem.dart';
import 'package:page_transition/page_transition.dart';

class HomeScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return HomeScreenState();
  }
}

class HomeScreenState extends State<HomeScreen> {
  bool _isSearching = false;
  String searchQuery = "Search for a word ...";
  TextEditingController _searchQuery;
  List<Note> listNotes = List<Note>();
  bool visible = true;
  List<NoteItem> listNote = List<NoteItem>();
  ScrollController mainController = ScrollController();
  void initState() {
    super.initState();
    _searchQuery = new TextEditingController();
  }

  void _stopSearching() {
    _clearSearchQuery();

    setState(() {
      _isSearching = false;
    });
  }

  void _clearSearchQuery() {
    setState(() {
      _searchQuery.clear();
      updateSearchQuery("Search for a word");
    });
  }

  void _startSearch() {
    ModalRoute.of(context)
        .addLocalHistoryEntry(new LocalHistoryEntry(onRemove: _stopSearching));

    setState(() {
      _isSearching = true;
    });
  }

  Widget _buildSearchField() {
    return TextField(
      controller: _searchQuery,
      autofocus: true,
      decoration: const InputDecoration(
        hintText: 'Search...',
        border: InputBorder.none,
        hintStyle: TextStyle(color: Colors.black45),
      ),
      style: const TextStyle(color: Colors.black, fontSize: 18.0),
      onChanged: updateSearchQuery,
    );
  }

  void updateSearchQuery(String newQuery) {
    setState(() {
      searchQuery = newQuery;
    });
  }

  List<Widget> _buildActions() {
    if (_isSearching) {
      return <Widget>[
        IconButton(
          color: Colors.black,
          icon: const Icon(Icons.clear, size: 24),
          onPressed: () {
            if (_searchQuery == null || _searchQuery.text.isEmpty) {
              Navigator.pop(context);
              return;
            }
            _clearSearchQuery();
          },
        ),
      ];
    }

    return <Widget>[
      IconButton(onPressed: _startSearch,
       icon: Icon(Icons.search),
       iconSize: 24,
        color: Colors.black,
      )
    ];
  }

  Widget build(BuildContext context) {
    List<NoteCardModel> notecard = List<NoteCardModel>();
    notecard.add(NoteCardModel(
        tag: "Homework",
        name: "Intro SE",
        imageUrl: "assets/img.png",
        contentCard: "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua."));
    notecard.add(NoteCardModel(
        tag: "Homework",
        name: "Intro SE",
        imageUrl: "assets/asset_bg.png",
        contentCard: "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. "));
    listNotes.add(Note(date: DateNote(dateNote: "Today"), list: notecard));
    notecard.add(NoteCardModel(
        tag: "Homework",
        name: "Intro SE",
        contentCard: "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua."));
    listNotes.add(Note(date: DateNote(dateNote: "12/04/2020"), list: notecard));
    return Scaffold(
        backgroundColor: Colors.white,
        resizeToAvoidBottomPadding: false,
        floatingActionButton: FloatingActionButton(heroTag: "btnAdd",backgroundColor: Colors.black,
            child: Icon(Icons.add, size: 18), onPressed: () {
          Navigator.push(context, PageTransition(type: PageTransitionType.downToUp,child:CreateNote(listNote)));
            }),
        appBar: AppBar(
          backgroundColor: Color.fromRGBO(255,209,16,1.0),
          title: _isSearching ? _buildSearchField() : null,
          actions: _buildActions(),
          leading: _isSearching
              ? const BackButton(color: Colors.black)
              : IconButton(
                  color: Colors.black,
                  icon: Icon(Icons.menu, size: 24),
                  onPressed: () {},
                ),
        ),
        body:
     ListView(controller: mainController, // parent ListView
    children: <Widget>[
        TagBar(mainController),
        SingleChildScrollView(
            child:
           Container( width: MediaQuery.of(context).size.width,
               height: MediaQuery.of(context).size.height,
               child: Stack( children:<Widget>[NoteGrid(listNotes)]),
            )
    )
   ]));
  }
}

