import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class CustomNavigation extends StatelessWidget{

  Widget build(BuildContext context)
  {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        Expanded(flex: 1, child: Container(
          width: MediaQuery.of(context).size.width/100 * 10,
          child: RaisedButton(
            child: Icon(Icons.menu, color: Colors.black12,size: 16),
          )
        ))
      ],
    );
  }
}