import 'package:flutter/cupertino.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:note_app/presentations/UI/custom_widget/custom_button.dart';

class CustomScaffold extends StatelessWidget{
    final CustomBtn add;
    final Widget bodyContainer;
    CustomScaffold(
        { Widget childContainer, CustomBtn addBtn})
         : add = addBtn,
          bodyContainer = childContainer;
    Widget build(BuildContext context)
    {
      final TextTheme _textTheme = Theme.of(context).textTheme;
      return Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Expanded(flex: 8, child: bodyContainer),
      Row(
        mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget> [
            SizedBox(width: 82 *  MediaQuery.of(context).size.width/100),
                    (add != null) ? add : Container()]
      ),
        SizedBox(height: 2*  MediaQuery.of(context).size.height/100)]
      );
    }
}