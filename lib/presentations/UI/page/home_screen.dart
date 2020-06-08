import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:note_app/presentations/UI/custom_widget/custom_list_notes.dart';

import 'package:note_app/presentations/UI/custom_widget/custom_note_card.dart';
import 'package:note_app/presentations/UI/custom_widget/custom_type_tag.dart';
import 'package:note_app/presentations/UI/page/base_view.dart';
import 'package:note_app/presentations/UI/page/create_note.dart';
import 'package:note_app/presentations/UI/page/image_pick.dart';
import 'package:note_app/utils/bus/tag_bus.dart';
import 'package:note_app/utils/bus/thumbnail_bus.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:note_app/utils/model/tag.dart';
import 'package:note_app/utils/model/thumbnailNote.dart';
import 'package:note_app/view_model/list_tb_note_view_model.dart';
import 'package:note_app/view_model/list_tag_view_model.dart';
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
//    print(listTBNote.length);
    return MultiProvider(
        providers: [
          ChangeNotifierProvider<TagCreatedModel>(
              create: (BuildContext context) {
            return TagCreatedModel();
          }),
          ChangeNotifierProvider<NoteCreatedModel>(
              create: (BuildContext context) {
            return NoteCreatedModel();
          })
        ],
        child: Scaffold(
            backgroundColor: Theme.of(context).backgroundColor,
            drawer: Drawer(
              child: ListView(padding: EdgeInsets.zero, children: <Widget>[
                DrawerHeader(
                    padding: EdgeInsets.fromLTRB(15, 30, 15, 0),
                    decoration: BoxDecoration(
                        shape: BoxShape.rectangle, color: Colors.transparent),
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
                      value: Provider.of<AppStateNotifier>(context).isDarkMode,
                      onChanged: (bool value) {
                        setState(() {
                          Provider.of<AppStateNotifier>(context, listen: false)
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
              elevation: 0.0,
              title: _isSearching ? _buildSearchField() : null,
              actions: _buildActions(),
            ),
            body: ListView(controller: mainController, // parent ListView
                children: <Widget>[
                  Consumer<TagCreatedModel>(
                      builder: (context, tagCreatedModel, _) {
                    tagCreatedModel.loadData();
                    return TagBar(mainController, tagCreatedModel);
                  }),
                  SingleChildScrollView(
                      child: Container(
                          width: MediaQuery.of(context).size.width,
                          height: MediaQuery.of(context).size.height,
                          child: Consumer<NoteCreatedModel>(
                              builder: (context, listTBNote, _) {
                            listTBNote.loadData();
                            if (listTBNote.listSize > 0) {
                              return NoteGrid(listTBNote.getNoteCreated());
                            }
                            return Center(
                                child:
                                    Text("Empty data.Let's create new note !"));
                          })))
                ])));
  }
}
