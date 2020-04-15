import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:note_app/presentations/UI/custom_widget/custom_note_card.dart';

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
  List<NoteCardModel> listNotes = List<NoteCardModel>();

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
          color: Colors.blue,
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
      InkWell(
        onTap: _startSearch,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Container(
                margin: EdgeInsets.only(
                    left: 3 * MediaQuery.of(context).size.width / 100,
                    right: 3 * MediaQuery.of(context).size.width / 100),
                width: 70 * MediaQuery.of(context).size.width / 100,
                height: 5 * MediaQuery.of(context).size.height / 100,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(10)),
                  color: Colors.blue.withOpacity(0.9),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    SizedBox(
                        width: 2 * MediaQuery.of(context).size.width / 100),
                    Icon(Icons.search, size: 20, color: Colors.white),
                    SizedBox(
                        width: 2 * MediaQuery.of(context).size.width / 100),
                    Text('Seach for a word .. ',
                        style: Theme.of(context)
                            .textTheme
                            .subhead
                            .copyWith(color: Colors.white))
                  ],
                ))
          ],
        ),
      ),
    ];
  }

  Widget build(BuildContext context) {
    listNotes.add(new NoteCardModel(
        tag: "Homework",
        name: "Intro SE",
        contentCard: "Deadline : 15/4/2020"));
    print(listNotes.length.toString());
    return Scaffold(
        resizeToAvoidBottomPadding: false,
        floatingActionButton: FloatingActionButton(
            child: Icon(Icons.add, size: 18), onPressed: () {}),
        appBar: AppBar(
          backgroundColor: Colors.white,
          title: _isSearching ? _buildSearchField() : null,
          actions: _buildActions(),
          leading: _isSearching
              ? const BackButton(color: Colors.blue)
              : IconButton(
                  color: Colors.blue,
                  icon: Icon(Icons.menu, size: 18),
                  onPressed: () {},
                ),
        ),
        body:
//        ListView.builder(
//          padding: EdgeInsets.only(left: 6*MediaQuery.of(context).size.width / 100,
//          right: 35*MediaQuery.of(context).size.width / 100),
//          itemCount: listNotes.length,
//          itemBuilder: (context,index){
//            final item = listNotes[index];
//           print(item.title.toString());
//            return NoteCard(item);
//          },
//        )
            Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[noteGridBuilder(context, listNotes)],
        ));
  }
}

Widget noteGridBuilder(BuildContext context, List<NoteCardModel> indexes) {
  List<Widget> columnOne = List<Widget>();
  List<Widget> columnTwo = List<Widget>();

  bool secondColumnFirst = false;

  if ((indexes.length - 1).isEven) {
    secondColumnFirst = false;
  } else {
    secondColumnFirst = true;
  }

  for (int i = 0; i < indexes.length; i++) {
    int bIndex = (indexes.length - 1) - i;
    if (bIndex.isEven) {
      columnOne.add(NoteCard(indexes[bIndex]));
    } else {
      columnTwo.add(NoteCard(indexes[bIndex]));
    }
  }

  if (indexes.length > 0) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Container(
          width: MediaQuery.of(context).size.width / 2 - 4,
          child: Column(
            children: secondColumnFirst ? columnTwo : columnOne,
          ),
        ),
        Container(
          width: MediaQuery.of(context).size.width / 2 - 4,
          child: Column(
            children: secondColumnFirst ? columnOne : columnTwo,
          ),
        ),
      ],
    );
  } else
    return null;
}
