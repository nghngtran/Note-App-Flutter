import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class CustomTag extends StatelessWidget{
  Widget build(BuildContext context)
  {
    return Container(width: MediaQuery.of(context).size.width/100*10,
        height:  MediaQuery.of(context).size.height/100*5,
  decoration: BoxDecoration(
  borderRadius: BorderRadius.all(Radius.circular(5)),
  color: Colors.white,
        child:Text(

        ));
  }
}