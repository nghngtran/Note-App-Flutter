import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:note_app/application/constants.dart';
import 'package:note_app/presentations/UI/custom_widget/FAB.dart';
import 'package:note_app/presentations/UI/custom_widget/choose_title.dart';
import 'package:note_app/presentations/UI/custom_widget/custom_text_style.dart';
import 'package:note_app/presentations/UI/page/create_tag.dart';
import 'package:note_app/utils/database/dao/note_dao.dart';
import 'package:note_app/utils/database/model/note.dart';
import 'package:note_app/utils/database/model/noteItem.dart';

class CreateNote extends StatefulWidget {
  Notes note;
  CreateNote(Notes _note):note = _note;
  CreateNoteState createState() => CreateNoteState();
}

class CreateNoteState extends State<CreateNote> {
    bool _isSearching = false;
    String searchQuery = "Search for a word ...";
    TextEditingController _searchQuery;
    bool visible = true;
    ScrollController mainController = ScrollController();
    TextEditingController txtController;

    void initState() {
      super.initState();

      _searchQuery = new TextEditingController();
    }

    void updateSearchQuery(String newQuery) {
      setState(() {
        searchQuery = newQuery;
      });
    }

    void _clearSearchQuery() {
      setState(() {
        _searchQuery.clear();
        updateSearchQuery("Search for a word");
      });
    }

    void _stopSearching() {
      _clearSearchQuery();

      setState(() {
        _isSearching = false;
      });
    }

    void _startSearch() {
      ModalRoute.of(context).addLocalHistoryEntry(
          new LocalHistoryEntry(onRemove: _stopSearching));

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
      double w = MediaQuery.of(context).size.width / 100;
      double h = MediaQuery.of(context).size.height / 100;

   print("Page" + widget.note.contents.length.toString());
      return Scaffold(
          backgroundColor: Colors.white,
          resizeToAvoidBottomPadding: false,
          floatingActionButton:
          FancyFab(widget.note),
          appBar: AppBar(
            backgroundColor: Color.fromRGBO(255, 209, 16, 1.0),
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
          body: Column(crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                SizedBox(height: h*2),
                Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly,children: <Widget>[
                  Expanded(
                      flex: 6,
                      child:InkWell(onTap: (){
                        showDialog(context: context, builder: (BuildContext context) => Dialog(shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
                            child: ChooseTitle()));
                      },
                          child: Container(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: <Widget>[
                            SizedBox(width: w*4),
                            Text(
                              "New untitled note",
                              style: Theme.of(context)
                                  .textTheme
                                  .title
                                  .copyWith(color: Colors.black,fontWeight: Font.SemiBold),
                            ),
                            SizedBox(width: w*2),
                            Image.asset("assets/edit.png", fit: BoxFit.contain,width: w*5,height: w*5,)
                          ],
                        ),
                      ))),
                  Expanded(
                      child: GestureDetector(onTap:(){
                        NoteDAO.insertNote(widget.note);
                      },
                    child: Text(
                      "Save",
                      style: Theme.of(context)
                          .textTheme
                          .title
                          .copyWith(color: Colors.blue,fontWeight: Font.SemiBold),
                    ),
                  ))
                ]),
          Container( width: w * 25,
              height: h* 5,
                        margin: EdgeInsets.only(
                            left: 4 * MediaQuery.of(context).size.width / 100,
                            top: MediaQuery.of(context).size.height / 100 * 2,bottom: h),
                        decoration: BoxDecoration(border: Border.all(color: Colors.black,width: 2),
                            borderRadius: BorderRadius.all(Radius.circular(15),),
                            color: Colors.white),
              child:GestureDetector(
                onTap: () {
                  showDialog(context: context, builder: (BuildContext context) => Dialog(shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
                      child: CreateTag()));
                },
                        child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: <Widget>[
                              SizedBox(width: w*2),
                              Icon(
                                Icons.local_offer,
                                color: Colors.black.withOpacity(0.4),
                              ),
                              SizedBox(width: w),
                              Text(
                                "Add tag",
                                style: Theme.of(context)
                                    .textTheme
                                    .headline7
                                    .copyWith(
                                        color: Colors.black.withOpacity(0.4),fontWeight: Font.Bold),
                              )
                            ]))),
                (widget.note.contents != null)
        ?
                Expanded(child:Container(child:
                ListNoteItems((widget.note))
                ))
                    : Text("")
              ]));
    }

  }
class ListNoteItems extends StatefulWidget{
  List<NoteItem> listNote;
  Notes note;
  ListNoteItems(Notes _note) : note = _note;
  BlockText createState() =>BlockText();
}
class BlockText extends State<ListNoteItems> {
  TextEditingController txtController;
  Widget build(BuildContext context) {
//    print(widget.note.contents.length);
    double w = MediaQuery
        .of(context)
        .size
        .width / 100;
    double h = MediaQuery
        .of(context)
        .size
        .height / 100;
    if (widget.note.contents.length ==0){
      return Text("");
    }
    else{
    return ListView.builder(
        itemCount: widget.note.contents.length, itemBuilder: (context, index) {
//      final item = widget.listNote[index];
      return Container(height: h * 25,
          margin: EdgeInsets.fromLTRB(w * 4, h * 2, w * 2, h),
          padding: EdgeInsets.fromLTRB(w, h, w, h),
          decoration: BoxDecoration(
              border: Border.all(width: 1.5, color: Colors.black),
              borderRadius: BorderRadius.all(Radius.circular(10)),
              color: Colors.greenAccent),
          child: TextFormField(
            maxLength: 1000,
            maxLines: 50,
            controller: txtController,
            style: TextStyle(
                fontSize: 17, fontStyle: FontStyle.normal, color: Colors.black),
            validator: (value) {
              if (value.isEmpty) {
                return 'Pls enter some text';
              }
//              widget.listNote.add(NoteItem.s)
              return value;
            },
          )
      );
    });
  }}
}
