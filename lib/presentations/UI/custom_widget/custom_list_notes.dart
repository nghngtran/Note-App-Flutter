import 'package:flutter/cupertino.dart';
import 'package:flutter/rendering.dart';

class ListNote extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return ListState();
  }
}

class ListState extends State<ListNote> {
  ScrollController _scrollController;
  bool _visible = true;
  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
    _scrollController.addListener(() {
      if (_scrollController.position.userScrollDirection ==
          ScrollDirection.reverse) {
        setState(() => _visible = false);
      }

      if (_scrollController.position.userScrollDirection ==
          ScrollDirection.forward) {
        setState(() => _visible = true);
      }
    });
  }

  Widget build(BuildContext context) {}
}
