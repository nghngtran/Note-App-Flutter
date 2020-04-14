import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class CustomBtn extends StatelessWidget{
  Widget build(BuildContext context)
  {
    return Container(width: MediaQuery.of(context).size.width/100*15,
        height:  MediaQuery.of(context).size.width/100*15,
        child:FloatingActionButton(
      backgroundColor: Colors.blue,
      child: Icon(Icons.add,size: 20),
      onPressed: (){},
    ));
  }
}