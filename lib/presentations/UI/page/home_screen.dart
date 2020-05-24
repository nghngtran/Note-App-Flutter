import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:note_app/presentations/UI/custom_widget/custom_list_notes.dart';

import 'package:note_app/presentations/UI/custom_widget/custom_note_card.dart';
import 'package:note_app/presentations/UI/custom_widget/custom_type_tag.dart';
import 'package:note_app/presentations/UI/page/base_view.dart';
import 'package:note_app/presentations/UI/page/create_note.dart';
import 'package:note_app/presentations/UI/page/image_pick.dart';
import 'package:note_app/utils/database/model/note.dart';
import 'package:note_app/utils/database/model/noteItem.dart';
import 'package:note_app/view_model/list_tag_viewmodel.dart';
import 'package:note_app/view_model/tag_view_model.dart';
import 'package:page_transition/page_transition.dart';
import 'package:note_app/presentations/UI/custom_widget/custom_text_style.dart';

class HomeScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return HomeScreenState();
  }
}

class HomeScreenState extends State<HomeScreen>
    with SingleTickerProviderStateMixin {
  bool _isSearching = false;
  String searchQuery = "Search for a word ...";
  TextEditingController _searchQuery;
  List<Note> listNotes = List<Note>();
  bool visible = true;
  bool isCollapsed = true;
  double screenWidth, screenHeight;
  final Duration duration = const Duration(milliseconds: 300);
  AnimationController _controller;
  Animation<double> _scaleAnimation;
  Animation<double> _menuScaleAnimation;
  Animation<Offset> _slideAnimation;
  bool _light = true;
  ScrollController mainController = ScrollController();
  void initState() {
    super.initState();
    _searchQuery = new TextEditingController();
    _controller = AnimationController(vsync: this, duration: duration);
    _scaleAnimation = Tween<double>(begin: 1, end: 1).animate(_controller);
    _menuScaleAnimation =
        Tween<double>(begin: 0.5, end: 1).animate(_controller);
    _slideAnimation = Tween<Offset>(begin: Offset(1, 0), end: Offset(-1.5, 0))
        .animate(_controller);
  }

  @override
  void dispose() {
    _controller.dispose();
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
      IconButton(
        onPressed: _startSearch,
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
              backgroundColor: Colors.white,
              resizeToAvoidBottomPadding: false,
              floatingActionButton: FloatingActionButton(
                  heroTag: "btnAdd",
                  backgroundColor: Colors.black,
                  child: Icon(Icons.add, size: 18),
                  onPressed: () {
                    Navigator.push(
                        context,
                        PageTransition(
                            type: PageTransitionType.downToUp,
                            child: CreateNote()));
                  }),
              appBar: AppBar(
                backgroundColor: Color.fromRGBO(255, 209, 16, 1.0),
                elevation: 0.0,
                title: _isSearching ? _buildSearchField() : null,
                actions: _buildActions(),
                leading: _isSearching
                    ? const BackButton(color: Colors.black)
                    : IconButton(
                        color: Colors.black,
                        icon: Icon(Icons.menu, size: 24),
                        onPressed: () {
                          setState(() {
                            if (isCollapsed)
                              _controller.forward();
                            else
                              _controller.reverse();

                            isCollapsed = !isCollapsed;
                          });
                        }),
              ),
              body: Stack(
                children: <Widget>[
                  menu(context),
                  home(context, tagCreated),
                ],
              ),
            ));
  }

  Widget home(context, TagCreatedModel model) {
    return AnimatedPositioned(
        duration: duration,
        top: 0,
        bottom: 0,
        left: isCollapsed ? 0 : MediaQuery.of(context).size.width * 0.6,
        right: isCollapsed ? 0 : -0.2 * MediaQuery.of(context).size.width,
        child: Material(
            animationDuration: duration,
            child: ScaleTransition(
                scale: _scaleAnimation,
                child: ListView(controller: mainController, // parent ListView
                    children: <Widget>[
                      TagBar(mainController, model),
                      SingleChildScrollView(
                          child: Container(
                        width: MediaQuery.of(context).size.width,
                        height: MediaQuery.of(context).size.height,
                        child: NoteGrid(listNotes),
                      ))
                    ]))));
  }

  Widget menu(context) {
    return SlideTransition(
      position: _slideAnimation,
      child: ScaleTransition(
        scale: _menuScaleAnimation,
        child: Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          alignment: Alignment.topLeft,
          child: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                MergeSemantics(
                  child: ListTile(
                    title: Text('Lights'),
                    trailing: CupertinoSwitch(
                      value: _light,
                      onChanged: (bool value) {
                        setState(() {
                          _light = value;
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
      ),
    );
  }
}
