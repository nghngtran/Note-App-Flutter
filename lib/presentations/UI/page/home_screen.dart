import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:note_app/presentations/UI/custom_widget/custom_list_notes.dart';

import 'package:note_app/presentations/UI/custom_widget/custom_note_card.dart';
import 'package:note_app/presentations/UI/custom_widget/custom_type_tag.dart';

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
//      InkWell(
//        onTap: _startSearch,
//        child:
//        Column(
//          mainAxisAlignment: MainAxisAlignment.center,
//          children: <Widget>[
//            Container(
//                margin: EdgeInsets.only(
//                    left: 3 * MediaQuery.of(context).size.width / 100,
//                    right: 3 * MediaQuery.of(context).size.width / 100),
//                width: 70 * MediaQuery.of(context).size.width / 100,
//                height: 5 * MediaQuery.of(context).size.height / 100,
//                decoration: BoxDecoration(
//                  borderRadius: BorderRadius.all(Radius.circular(10)),
//                  color: Colors.blue.withOpacity(0.9),
//                ),
//                child: Row(
//                  mainAxisAlignment: MainAxisAlignment.start,
//                  children: <Widget>[
//                    SizedBox(
//                        width: 2 * MediaQuery.of(context).size.width / 100),
//                    Icon(Icons.search, size: 20, color: Colors.white),
//                    SizedBox(
//                        width: 2 * MediaQuery.of(context).size.width / 100),
//                    Text('Seach for a word .. ',
//                        style: Theme.of(context)
//                            .textTheme
//                            .subhead
//                            .copyWith(color: Colors.white))
//                  ],
//                ))
//          ],
//        ),
//      ),
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
        floatingActionButton: FloatingActionButton(backgroundColor: Colors.black,
            child: Icon(Icons.add, size: 18), onPressed: () {}),
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
//        Container(
//            width: MediaQuery.of(context).size.width,
//               height: MediaQuery.of(context).size.height,
//               child: Stack( children:<Widget>[NoteGrid(listNotes)]))


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
//Widget historyGrid(BuildContext context, List<Note> notes)
//{
//  List<Widget> date = List<Widget>();
//  List<NoteCardModel> notecard = List<NoteCardModel>();
//  for (int i = 0; i < notes.length; i++)
//  {
//    if (notes[i] is DateNote)
//    {
//    date.add(NoteCard(notes[i]));
//    }
//    else {
//      notecard.add(notes[i]);
//    }
//  }
//  return Column(
//    children: <Widget>[
//      Container(child:Column(children:date)),
//      noteGridBuilder(context,notecard)
//    ],
//  );
//
//}
