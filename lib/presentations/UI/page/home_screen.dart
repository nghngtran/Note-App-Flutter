import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:note_app/presentations/UI/custom_widget/custom_list_notes.dart';

import 'package:note_app/presentations/UI/custom_widget/custom_note_card.dart';
import 'package:note_app/presentations/UI/custom_widget/custom_type_tag.dart';
import 'package:note_app/presentations/UI/page/base_view.dart';
import 'package:note_app/presentations/UI/page/create_note.dart';
import 'package:note_app/presentations/UI/page/image_pick.dart';
import 'package:note_app/utils/model/note.dart';
import 'package:note_app/utils/model/noteItem.dart';
import 'package:note_app/view_model/list_tag_viewmodel.dart';
import 'package:note_app/view_model/tag_view_model.dart';
import 'package:page_transition/page_transition.dart';
import 'package:note_app/presentations/UI/custom_widget/custom_text_style.dart';
import 'package:provider/provider.dart';

import '../../../main.dart';

class HomeScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return HomeScreenState();
  }
}

class HomeScreenState extends State<HomeScreen>
    with SingleTickerProviderStateMixin {
  TagCreatedModel model = TagCreatedModel();
  bool _isSearching = false;
  String searchQuery = "Search for a word ...";
  TextEditingController _searchQuery;
  List<Note> listNotes = List<Note>();
  bool visible = true;
  bool isCollapsed = true;

  bool _light = true;
  ScrollController mainController = ScrollController();

  void initState() {
    super.initState();
    _searchQuery = new TextEditingController();
  }

  @override
  void dispose() {
    _searchQuery.dispose();
    super.dispose();
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
        hintStyle: TextStyle(color: Colors.white10),
      ),
      style: TextStyle(
          color: Theme.of(context).textTheme.caption.color, fontSize: 18.0),
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
          color: Theme.of(context).iconTheme.color,
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
      IconButton(
        onPressed: _startSearch,
        icon: Icon(Icons.search),
        iconSize: 24,
        color: Theme.of(context).iconTheme.color,
      )
    ];
  }

  Widget build(BuildContext context) {
    List<NoteCardModel> notecard = List<NoteCardModel>();
    notecard.add(NoteCardModel(
        tag: "Homework",
        name: "Intro SE",
        imageUrl: "assets/img.png",
        contentCard:
            "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua."));
    notecard.add(NoteCardModel(
        tag: "Homework",
        name: "Intro SE",
        imageUrl: "assets/asset_bg.png",
        contentCard:
            "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. "));
    listNotes.add(Note(date: DateNote(dateNote: "Today"), list: notecard));
    notecard.add(NoteCardModel(
        tag: "Homework",
        name: "Intro SE",
        contentCard:
            "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua."));
    listNotes.add(Note(date: DateNote(dateNote: "12/04/2020"), list: notecard));
    return BaseView<TagCreatedModel>(
        onModelReady: (tagCreated) => tagCreated.getTagCreated(),
        builder: (context, tagCreated, child) => Scaffold(
            backgroundColor: Theme.of(context).backgroundColor,
            drawer: Drawer(
              child: ListView(
                  // Important: Remove any padding from the ListView.
                  padding: EdgeInsets.zero,
                  children: <Widget>[
                    DrawerHeader(
                        padding: EdgeInsets.fromLTRB(15, 30, 15, 0),
                        decoration: BoxDecoration(
                            shape: BoxShape.rectangle,
                            color: Colors.transparent),
                        child: Text("Settings your app",
                            style: TextStyle(
                                color: Theme.of(context).iconTheme.color,
                                fontSize: 20))),
                    MergeSemantics(
                      child: ListTile(
                        title: Text('Dark Theme',
                            style: TextStyle(
                                color: Theme.of(context).iconTheme.color,
                                fontSize: 16)),
                        trailing: CupertinoSwitch(
                          value:
                              Provider.of<AppStateNotifier>(context).isDarkMode,
                          onChanged: (bool value) {
                            setState(() {
                              Provider.of<AppStateNotifier>(context,
                                      listen: false)
                                  .updateTheme(value);
                            });
                          },
                        ),
                        onTap: () {
                          setState(() {
                            _light = !_light;
                          });
                        },
                      ),
                    )
                  ]),
            ),
//            backgroundColor: Colors.white,
            resizeToAvoidBottomPadding: false,
            floatingActionButton: FloatingActionButton(
                heroTag: "btnAdd",
                backgroundColor:
                    Theme.of(context).floatingActionButtonTheme.backgroundColor,
                splashColor:
                    Theme.of(context).floatingActionButtonTheme.backgroundColor,
                child: Icon(Icons.add,
                    size: 28, color: Theme.of(context).iconTheme.color),
                onPressed: () {
                  Navigator.push(
                      context,
                      PageTransition(
                          type: PageTransitionType.downToUp,
                          child: CreateNote()));
                }),
            appBar: AppBar(
//                backgroundColor: Color.fromRGBO(255, 209, 16, 1.0),
              elevation: 0.0,
              title: _isSearching ? _buildSearchField() : null,
              actions: _buildActions(),
//                leading: _isSearching
//                    ? BackButton(color: Theme.of(context).primaryColor)
//                    : Container()
//                IconButton(
//                        color: Theme.of(context).primaryColor,
//                        icon: Icon(Icons.menu, size: 24),
//                        onPressed: () {
//                          setState(() {
//                            if (isCollapsed)
//                              _controller.forward();
//                            else
//                              _controller.reverse();
//
//                            isCollapsed = !isCollapsed;
//                          });
//                        }),
            ),
            body: ListView(controller: mainController, // parent ListView
                children: <Widget>[
                  TagBar(mainController, model),
                  SingleChildScrollView(
                      child: Container(
                    width: MediaQuery.of(context).size.width,
                    height: MediaQuery.of(context).size.height,
                    child: NoteGrid(listNotes),
                  ))
                ])
//              Stack(
//                children: <Widget>[
//                  menu(context),
//                  home(context, tagCreated),
//                ],
//              ),
            ));
  }
}

//  Widget home(context, TagCreatedModel model) {
//    return AnimatedPositioned(
//        duration: duration,
//        top: 0,
//        bottom: 0,
//        left: isCollapsed ? 0 : MediaQuery.of(context).size.width * 0.4,
//        right: isCollapsed ? 0 : -0.2 * MediaQuery.of(context).size.width,
//        child: Material(
//            animationDuration: duration,
//            child: ScaleTransition(
//                scale: _scaleAnimation,
//                child: ListView(controller: mainController, // parent ListView
//                    children: <Widget>[
//                      TagBar(mainController, model),
//                      SingleChildScrollView(
//                          child: Container(
//                        width: MediaQuery.of(context).size.width,
//                        height: MediaQuery.of(context).size.height,
//                        child: NoteGrid(listNotes),
//                      ))
//                    ]))));
//  }
//
//  Widget menu(context) {
//    return SlideTransition(
//      position: _slideAnimation,
////      child: ScaleTransition(
////        scale: _menuScaleAnimation,
//      child: Container(
//        width: MediaQuery.of(context).size.width,
//        height: MediaQuery.of(context).size.height,
//        alignment: Alignment.topLeft,
//        child: Column(
//            mainAxisSize: MainAxisSize.min,
//            mainAxisAlignment: MainAxisAlignment.spaceAround,
//            crossAxisAlignment: CrossAxisAlignment.start,
//            children: <Widget>[
//              MergeSemantics(
//                child: ListTile(
//                  title: Text('Lights'),
//                  trailing: CupertinoSwitch(
//                    value: _light,
//                    onChanged: (bool value) {
//                      setState(() {
//                        _light = value;
//                      });
//                    },
//                  ),
//                  onTap: () {
//                    setState(() {
//                      _light = !_light;
//                    });
//                  },
//                ),
//              )
//            ]),
//      ),
//    );
//  }
//}
